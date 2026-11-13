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
export class OpenRouteServiceMapProvider implements MapProvider {
  readonly providerName = 'openrouteservice';
  private readonly logger = new Logger(OpenRouteServiceMapProvider.name);

  private readonly apiKey: string;
  private readonly baseUrl = 'https://api.openrouteservice.org';

  constructor(private readonly config: ConfigService) {
    this.apiKey = this.config.get<string>('ORS_API_KEY', '');
  }

  async search(query: string, options?: GeocodeOptions): Promise<GeocodeResult[]> {
    if (!this.apiKey) {
      this.logger.debug('ORS_API_KEY is not configured.');
      return [];
    }

    try {
      const url = new URL(`${this.baseUrl}/geocode/search`);
      url.searchParams.set('api_key', this.apiKey);
      url.searchParams.set('text', query);
      url.searchParams.set('size', String(options?.limit || 8));
      url.searchParams.set('boundary.country', 'MAR'); // Morocco only

      if (options?.proximity) {
        url.searchParams.set('focus.point.lat', String(options.proximity.lat));
        url.searchParams.set('focus.point.lon', String(options.proximity.lon));
      }

      const response = await fetch(url.toString(), { signal: AbortSignal.timeout(4000) });
      if (!response.ok) throw new Error(`ORS Geocode status ${response.status}`);

      const data = await response.json();
      const features = data.features || [];

      return features.map((feat: any, idx: number) => {
        const coords = feat.geometry?.coordinates || [0, 0];
        const props = feat.properties || {};

        return {
          id: `ors-${props.id || idx}`,
          name: props.name || query,
          label: props.label || props.name,
          coordinates: { lat: coords[1], lon: coords[0] },
          city: props.locality || props.county,
          postcode: props.postalcode,
          country: 'Morocco',
          source: 'openrouteservice',
          category: props.category,
        } as GeocodeResult;
      });
    } catch (err: any) {
      this.logger.warn(`ORS search failed: ${err.message}`);
      return [];
    }
  }

  async reverse(lat: number, lon: number): Promise<ReverseGeocodeResult> {
    if (!this.apiKey) {
      return {
        formattedAddress: `${lat.toFixed(4)}, ${lon.toFixed(4)}`,
        city: 'المغرب',
        coordinates: { lat, lon },
        country: 'Morocco',
        source: 'ors-unconfigured',
      };
    }

    try {
      const url = `${this.baseUrl}/geocode/reverse?api_key=${this.apiKey}&point.lat=${lat}&point.lon=${lon}&size=1`;
      const response = await fetch(url, { signal: AbortSignal.timeout(4000) });
      if (!response.ok) throw new Error(`ORS Reverse status ${response.status}`);

      const data = await response.json();
      const first = data.features?.[0];
      const props = first?.properties || {};

      return {
        formattedAddress: props.label || `${props.name || ''}, ${props.locality || 'المغرب'}`,
        street: props.street || props.name,
        district: props.neighbourhood,
        city: props.locality || props.county || 'المغرب',
        coordinates: { lat, lon },
        country: 'Morocco',
        source: 'openrouteservice',
      };
    } catch (err: any) {
      this.logger.warn(`ORS reverse failed: ${err.message}`);
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
    if (!this.apiKey) {
      throw new Error('ORS_API_KEY missing');
    }

    const orsProfile = profile === 'motorcycle' ? 'driving-car' : 'driving-car';
    const url = `${this.baseUrl}/v2/directions/${orsProfile}/geojson`;

    const body = {
      coordinates: [
        [origin.lon, origin.lat],
        [destination.lon, destination.lat],
      ],
      instructions: true,
      geometry: true,
    };

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: this.apiKey,
      },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(5000),
    });

    if (!response.ok) {
      throw new Error(`ORS Directions error ${response.status}`);
    }

    const data = await response.json();
    const feat = data.features?.[0];
    const summary = feat?.properties?.summary;

    if (!summary) throw new Error('No summary in ORS response');

    const distanceMeters = Math.round(summary.distance);
    const durationSeconds = Math.round(summary.duration);

    return {
      distanceMeters,
      distanceKm: Math.round((distanceMeters / 1000) * 10) / 10,
      durationSeconds,
      durationMinutes: Math.max(1, Math.round(durationSeconds / 60)),
      geometryGeoJson: feat.geometry,
      source: 'openrouteservice',
    };
  }

  async matrix(origins: Coordinates[], destinations: Coordinates[]): Promise<MatrixResult> {
    if (!this.apiKey) throw new Error('ORS_API_KEY missing');

    const allCoords = [...origins, ...destinations];
    const url = `${this.baseUrl}/v2/matrix/driving-car`;

    const body = {
      locations: allCoords.map((c) => [c.lon, c.lat]),
      sources: origins.map((_, i) => i),
      destinations: destinations.map((_, i) => origins.length + i),
      metrics: ['distance', 'duration'],
    };

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: this.apiKey,
      },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(5000),
    });

    if (!response.ok) throw new Error(`ORS Matrix status ${response.status}`);
    const data = await response.json();

    return {
      durationsSeconds: data.durations || [],
      distancesMeters: data.distances || [],
      source: 'openrouteservice',
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
    return !!this.apiKey;
  }
}

