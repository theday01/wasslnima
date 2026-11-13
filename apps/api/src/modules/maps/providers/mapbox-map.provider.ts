import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MapProvider } from '../interfaces/map-provider.interface';
import {
  Coordinates,
  GeocodeOptions,
  GeocodeResult,
  ReverseGeocodeResult,
  RouteResult,
  MatrixResult,
  EtaResult,
} from '../interfaces/map-results.interface';

@Injectable()
export class MapboxMapProvider implements MapProvider {
  readonly providerName = 'mapbox-fallback';
  private readonly logger = new Logger(MapboxMapProvider.name);

  private readonly accessToken: string;
  private readonly baseUrl = 'https://api.mapbox.com';

  constructor(private readonly config: ConfigService) {
    this.accessToken = this.config.get<string>('MAPBOX_ACCESS_TOKEN', '');
  }

  async search(query: string, options?: GeocodeOptions): Promise<GeocodeResult[]> {
    if (!this.accessToken) return [];

    try {
      const encoded = encodeURIComponent(query);
      const url = new URL(`${this.baseUrl}/geocoding/v5/mapbox.places/${encoded}.json`);
      url.searchParams.set('access_token', this.accessToken);
      url.searchParams.set('country', 'ma'); // Morocco only
      url.searchParams.set('limit', String(options?.limit || 8));
      url.searchParams.set('language', 'ar,fr');

      if (options?.proximity) {
        url.searchParams.set('proximity', `${options.proximity.lon},${options.proximity.lat}`);
      }

      const response = await fetch(url.toString(), { signal: AbortSignal.timeout(4000) });
      if (!response.ok) throw new Error(`Mapbox status ${response.status}`);

      const data = await response.json();
      const features = data.features || [];

      return features.map((feat: any) => {
        const coords = feat.center || [0, 0];
        const context = feat.context || [];
        const cityObj = context.find((c: any) => c.id?.startsWith('place'));

        return {
          id: `mapbox-${feat.id}`,
          name: feat.text || query,
          label: feat.place_name || feat.text,
          coordinates: { lat: coords[1], lon: coords[0] },
          city: cityObj?.text,
          country: 'Morocco',
          source: 'mapbox',
        } as GeocodeResult;
      });
    } catch (err: any) {
      this.logger.warn(`Mapbox search failed: ${err.message}`);
      return [];
    }
  }

  async reverse(lat: number, lon: number): Promise<ReverseGeocodeResult> {
    if (!this.accessToken) {
      return {
        formattedAddress: `${lat.toFixed(4)}, ${lon.toFixed(4)}`,
        city: 'المغرب',
        coordinates: { lat, lon },
        country: 'Morocco',
        source: 'mapbox-unconfigured',
      };
    }

    try {
      const url = `${this.baseUrl}/geocoding/v5/mapbox.places/${lon},${lat}.json?access_token=${this.accessToken}&types=address,poi,neighborhood`;
      const response = await fetch(url, { signal: AbortSignal.timeout(4000) });
      if (!response.ok) throw new Error(`Mapbox reverse status ${response.status}`);

      const data = await response.json();
      const first = data.features?.[0];

      return {
        formattedAddress: first?.place_name || `${lat.toFixed(4)}, ${lon.toFixed(4)}`,
        street: first?.text,
        city: 'المغرب',
        coordinates: { lat, lon },
        country: 'Morocco',
        source: 'mapbox',
      };
    } catch (err: any) {
      this.logger.warn(`Mapbox reverse failed: ${err.message}`);
      return {
        formattedAddress: `${lat.toFixed(4)}, ${lon.toFixed(4)}`,
        city: 'المغرب',
        coordinates: { lat, lon },
        country: 'Morocco',
        source: 'fallback',
      };
    }
  }

  async route(
    origin: Coordinates,
    destination: Coordinates,
    profile: 'driving-car' | 'motorcycle' = 'driving-car',
  ): Promise<RouteResult> {
    if (!this.accessToken) throw new Error('MAPBOX_ACCESS_TOKEN missing');

    const coordinates = `${origin.lon},${origin.lat};${destination.lon},${destination.lat}`;
    const url = `${this.baseUrl}/directions/v5/mapbox/driving/${coordinates}?geometries=geojson&overview=full&access_token=${this.accessToken}`;

    const response = await fetch(url, { signal: AbortSignal.timeout(5000) });
    if (!response.ok) throw new Error(`Mapbox directions status ${response.status}`);

    const data = await response.json();
    const route = data.routes?.[0];
    if (!route) throw new Error('No route in Mapbox response');

    const distanceMeters = Math.round(route.distance);
    const durationSeconds = Math.round(route.duration);

    return {
      distanceMeters,
      distanceKm: Math.round((distanceMeters / 1000) * 10) / 10,
      durationSeconds,
      durationMinutes: Math.max(1, Math.round(durationSeconds / 60)),
      geometryGeoJson: route.geometry,
      source: 'mapbox',
    };
  }

  async matrix(origins: Coordinates[], destinations: Coordinates[]): Promise<MatrixResult> {
    if (!this.accessToken) throw new Error('MAPBOX_ACCESS_TOKEN missing');

    const allCoords = [...origins, ...destinations];
    const coordsString = allCoords.map((c) => `${c.lon},${c.lat}`).join(';');
    const sourcesParam = origins.map((_, i) => i).join(';');
    const destinationsParam = destinations.map((_, i) => origins.length + i).join(';');

    const url = `${this.baseUrl}/directions-matrix/v1/mapbox/driving/${coordsString}?sources=${sourcesParam}&destinations=${destinationsParam}&annotations=duration,distance&access_token=${this.accessToken}`;
    const response = await fetch(url, { signal: AbortSignal.timeout(5000) });

    if (!response.ok) throw new Error(`Mapbox matrix status ${response.status}`);
    const data = await response.json();

    return {
      durationsSeconds: data.durations || [],
      distancesMeters: data.distances || [],
      source: 'mapbox',
    };
  }

  async eta(origin: Coordinates, destination: Coordinates): Promise<EtaResult> {
    const route = await this.route(origin, destination);
    return {
      durationSeconds: route.durationSeconds,
      durationMinutes: route.durationMinutes,
      distanceKm: route.distanceKm,
      source: route.source,
    };
  }

  async healthCheck(): Promise<boolean> {
    return !!this.accessToken;
  }
}

