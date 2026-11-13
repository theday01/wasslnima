import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MapProvider } from './interfaces/map-provider.interface';
import {
  Coordinates,
  GeocodeOptions,
  GeocodeResult,
  ReverseGeocodeResult,
  RouteResult,
  MatrixResult,
  EtaResult,
} from './interfaces/map-results.interface';
import { SelfHostedMapProvider } from './providers/self-hosted-map.provider';
import { OpenRouteServiceMapProvider } from './providers/openrouteservice-map.provider';
import { MapboxMapProvider } from './providers/mapbox-map.provider';
import { PlacesService } from './places.service';
import { MapsCacheService } from './maps.cache';

@Injectable()
export class MapsService {
  private readonly logger = new Logger(MapsService.name);
  private activeProvider: MapProvider;
  private readonly providers: Map<string, MapProvider> = new Map();

  constructor(
    private readonly config: ConfigService,
    private readonly selfHostedProvider: SelfHostedMapProvider,
    private readonly orsProvider: OpenRouteServiceMapProvider,
    private readonly mapboxProvider: MapboxMapProvider,
    private readonly placesService: PlacesService,
    private readonly cache: MapsCacheService,
  ) {
    this.providers.set('self-hosted', this.selfHostedProvider);
    this.providers.set('openrouteservice', this.orsProvider);
    this.providers.set('mapbox', this.mapboxProvider);

    const configured = this.config.get<string>('MAP_PROVIDER', 'self-hosted').toLowerCase();
    this.activeProvider = this.providers.get(configured) || this.selfHostedProvider;

    this.logger.log(`Initialized MapsService with default provider: ${this.activeProvider.providerName}`);
  }

  /**
   * Set active provider dynamically at runtime or via configuration
   */
  setProvider(providerName: 'self-hosted' | 'openrouteservice' | 'mapbox') {
    const p = this.providers.get(providerName);
    if (p) {
      this.activeProvider = p;
      this.logger.log(`Switched active map provider to: ${p.providerName}`);
    }
  }

  getActiveProviderName(): string {
    return this.activeProvider.providerName;
  }

  /**
   * Forward Geocoding: Searches PostGIS Places first, then Redis cache, then Provider with Failover
   */
  async search(query: string, options?: GeocodeOptions): Promise<GeocodeResult[]> {
    if (!query || query.trim().length === 0) return [];
    const cleanQuery = query.trim();

    // 1. Search PostGIS places first (Airports, Stations, Malls, Universities, Hospitals)
    const placeMatches = await this.placesService.search(cleanQuery, options?.proximity, options?.limit || 8);
    if (placeMatches.length > 0) {
      this.logger.debug(`Found ${placeMatches.length} matches in PostGIS places for "${cleanQuery}"`);
      // If we got high-confidence results from verified Moroccan landmarks, return them directly
      if (placeMatches.length >= 3 || placeMatches[0].score! >= 0.95) {
        return placeMatches;
      }
    }

    // 2. Check Redis Cache
    const cacheKey = this.cache.generateSearchKey(cleanQuery, options?.proximity?.lat, options?.proximity?.lon);
    const cached = await this.cache.get<GeocodeResult[]>(cacheKey);
    if (cached) {
      return [...placeMatches, ...cached].slice(0, options?.limit || 8);
    }

    // 3. Query Active Provider with Automatic Failover
    let externalResults: GeocodeResult[] = [];
    try {
      externalResults = await this.activeProvider.search(cleanQuery, options);
    } catch (err: any) {
      this.logger.warn(`Primary provider ${this.activeProvider.providerName} search failed: ${err.message}. Trying fallback.`);
      externalResults = await this.executeSearchFallback(cleanQuery, options);
    }

    // Cache the external results for 24 hours
    if (externalResults.length > 0) {
      await this.cache.set(cacheKey, externalResults, 24 * 3600);
    }

    // Combine PostGIS places (prioritized) + External geocoder
    const combined = [...placeMatches, ...externalResults];
    const unique = this.deduplicateGeocodeResults(combined);
    return unique.slice(0, options?.limit || 8);
  }

  /**
   * Reverse Geocoding with Redis caching
   */
  async reverse(lat: number, lon: number): Promise<ReverseGeocodeResult> {
    const cacheKey = this.cache.generateReverseKey(lat, lon);
    const cached = await this.cache.get<ReverseGeocodeResult>(cacheKey);
    if (cached) return cached;

    let res: ReverseGeocodeResult;
    try {
      res = await this.activeProvider.reverse(lat, lon);
    } catch (err: any) {
      this.logger.warn(`Reverse geocoding failed on ${this.activeProvider.providerName}: ${err.message}`);
      res = await this.executeReverseFallback(lat, lon);
    }

    await this.cache.set(cacheKey, res, 48 * 3600);
    return res;
  }

  /**
   * Route calculation with distance, duration, steps, and Redis caching
   */
  async route(
    origin: Coordinates,
    destination: Coordinates,
    profile: 'driving-car' | 'motorcycle' = 'driving-car',
  ): Promise<RouteResult> {
    const cacheKey = this.cache.generateRouteKey(origin.lat, origin.lon, destination.lat, destination.lon);
    const cached = await this.cache.get<RouteResult>(cacheKey);
    if (cached) return cached;

    let result: RouteResult;
    try {
      result = await this.activeProvider.route(origin, destination, profile);
    } catch (err: any) {
      this.logger.warn(`Route calculation failed on ${this.activeProvider.providerName}: ${err.message}`);
      result = await this.executeRouteFallback(origin, destination, profile);
    }

    // Cache route for 2 hours
    await this.cache.set(cacheKey, result, 2 * 3600);
    return result;
  }

  /**
   * Travel ETA and Distance calculation
   */
  async eta(origin: Coordinates, destination: Coordinates): Promise<EtaResult> {
    const r = await this.route(origin, destination);
    return {
      durationSeconds: r.durationSeconds,
      durationMinutes: r.durationMinutes,
      distanceKm: r.distanceKm,
      source: r.source,
    };
  }

  /**
   * Distance Matrix for multiple points
   */
  async matrix(origins: Coordinates[], destinations: Coordinates[]): Promise<MatrixResult> {
    try {
      return await this.activeProvider.matrix(origins, destinations);
    } catch (err: any) {
      this.logger.warn(`Matrix failed on ${this.activeProvider.providerName}: ${err.message}`);
      return this.executeMatrixFallback(origins, destinations);
    }
  }

  private async executeSearchFallback(query: string, options?: GeocodeOptions): Promise<GeocodeResult[]> {
    for (const [name, provider] of this.providers.entries()) {
      if (provider === this.activeProvider) continue;
      try {
        const res = await provider.search(query, options);
        if (res && res.length > 0) return res;
      } catch {
        continue;
      }
    }
    return [];
  }

  private async executeReverseFallback(lat: number, lon: number): Promise<ReverseGeocodeResult> {
    for (const [name, provider] of this.providers.entries()) {
      if (provider === this.activeProvider) continue;
      try {
        return await provider.reverse(lat, lon);
      } catch {
        continue;
      }
    }
    return {
      formattedAddress: `${lat.toFixed(4)}, ${lon.toFixed(4)}`,
      city: 'المغرب',
      coordinates: { lat, lon },
      country: 'Morocco',
      source: 'hard-fallback',
    };
  }

  private async executeRouteFallback(
    origin: Coordinates,
    dest: Coordinates,
    profile: 'driving-car' | 'motorcycle',
  ): Promise<RouteResult> {
    for (const [name, provider] of this.providers.entries()) {
      if (provider === this.activeProvider) continue;
      try {
        return await provider.route(origin, dest, profile);
      } catch {
        continue;
      }
    }
    // Final resilient mathematical fallback
    return (this.selfHostedProvider as any).fallbackHaversineRoute(origin, dest);
  }

  private async executeMatrixFallback(origins: Coordinates[], destinations: Coordinates[]): Promise<MatrixResult> {
    for (const [name, provider] of this.providers.entries()) {
      if (provider === this.activeProvider) continue;
      try {
        return await provider.matrix(origins, destinations);
      } catch {
        continue;
      }
    }
    return { durationsSeconds: [], distancesMeters: [], source: 'fallback' };
  }

  private deduplicateGeocodeResults(results: GeocodeResult[]): GeocodeResult[] {
    const seen = new Set<string>();
    return results.filter((item) => {
      // Key based on rounded coordinates (~50m)
      const coordKey = `${item.coordinates.lat.toFixed(3)},${item.coordinates.lon.toFixed(3)}`;
      if (seen.has(coordKey)) return false;
      seen.add(coordKey);
      return true;
    });
  }
}

