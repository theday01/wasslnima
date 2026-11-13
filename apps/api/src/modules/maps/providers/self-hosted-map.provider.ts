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
export class SelfHostedMapProvider implements MapProvider {
  readonly providerName = 'self-hosted-osrm-photon';
  private readonly logger = new Logger(SelfHostedMapProvider.name);

  private readonly osrmUrl: string;
  private readonly photonUrl: string;

  constructor(private readonly config: ConfigService) {
    this.osrmUrl = this.config.get<string>('OSRM_URL', 'http://osrm:5000');
    this.photonUrl = this.config.get<string>('PHOTON_URL', 'http://photon:2322');
  }

  async search(query: string, options?: GeocodeOptions): Promise<GeocodeResult[]> {
    try {
      const url = new URL(`${this.photonUrl}/api`);
      url.searchParams.set('q', query);
      url.searchParams.set('limit', String(options?.limit || 8));
      url.searchParams.set('lang', options?.language || 'ar');

      // Bias towards Morocco or proximity
      if (options?.proximity) {
        url.searchParams.set('lat', String(options.proximity.lat));
        url.searchParams.set('lon', String(options.proximity.lon));
      } else {
        // Center of Morocco
        url.searchParams.set('lat', '31.7917');
        url.searchParams.set('lon', '-7.0926');
      }

      // Filter Morocco bbox
      url.searchParams.set('bbox', '-13.2,27.6,-0.9,35.9');

      const response = await fetch(url.toString(), { signal: AbortSignal.timeout(1500) });
      if (!response.ok) {
        throw new Error(`Photon responded with status ${response.status}`);
      }

      const data = await response.json();
      const features = data.features || [];

      return features.map((feat: any, idx: number) => {
        const coords = feat.geometry?.coordinates || [0, 0];
        const props = feat.properties || {};
        const name = props.name || props.street || query;
        const city = props.city || props.county || props.state || '';
        const labelParts = [name, props.street, city, 'المغرب'].filter(Boolean);

        return {
          id: `photon-${props.osm_id || idx}`,
          name,
          label: labelParts.join('، '),
          coordinates: { lat: coords[1], lon: coords[0] },
          city,
          postcode: props.postcode,
          country: 'Morocco',
          source: 'photon',
          category: props.osm_value,
        } as GeocodeResult;
      });
    } catch (err: any) {
      this.logger.warn(`Photon search failed: ${err.message}`);
      return [];
    }
  }

  async reverse(lat: number, lon: number): Promise<ReverseGeocodeResult> {
    try {
      const url = `${this.photonUrl}/reverse?lat=${lat}&lon=${lon}`;
      const response = await fetch(url, { signal: AbortSignal.timeout(1500) });
      if (!response.ok) {
        throw new Error(`Photon reverse status ${response.status}`);
      }

      const data = await response.json();
      const first = data.features?.[0];
      const props = first?.properties || {};

      const name = props.name || props.street || 'شارع بدون تسمية';
      const city = props.city || props.state || 'المغرب';
      const district = props.district || props.suburb;

      return {
        formattedAddress: [name, district, city].filter(Boolean).join('، '),
        street: props.street || props.name,
        district,
        city,
        coordinates: { lat, lon },
        country: 'Morocco',
        source: 'photon',
      };
    } catch (err: any) {
      this.logger.warn(`Photon reverse failed: ${err.message}`);
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
    try {
      // OSRM coordinates order is {lon},{lat}
      const coordsString = `${origin.lon},${origin.lat};${destination.lon},${destination.lat}`;
      const url = `${this.osrmUrl}/route/v1/driving/${coordsString}?overview=full&geometries=geojson&steps=true`;

      const response = await fetch(url, { signal: AbortSignal.timeout(1500) });
      if (!response.ok) {
        throw new Error(`OSRM responded with status ${response.status}`);
      }

      const data = await response.json();
      const routeData = data.routes?.[0];
      if (!routeData) {
        throw new Error('No route found in OSRM response');
      }

      const distanceMeters = Math.round(routeData.distance);
      const durationSeconds = Math.round(routeData.duration);

      const steps = (routeData.legs?.[0]?.steps || []).map((s: any) => ({
        instruction: s.maneuver?.type ? `${s.maneuver.type} ${s.name || ''}`.trim() : s.name || '',
        distanceMeters: Math.round(s.distance),
        durationSeconds: Math.round(s.duration),
        name: s.name,
      }));

      return {
        distanceMeters,
        distanceKm: Math.round((distanceMeters / 1000) * 10) / 10,
        durationSeconds,
        durationMinutes: Math.max(1, Math.round(durationSeconds / 60)),
        geometryGeoJson: routeData.geometry,
        steps,
        source: 'self-hosted-osrm',
      };
    } catch (err: any) {
      this.logger.warn(`OSRM routing failed: ${err.message}. Using Haversine approximation.`);
      return this.fallbackHaversineRoute(origin, destination);
    }
  }

  async matrix(origins: Coordinates[], destinations: Coordinates[]): Promise<MatrixResult> {
    try {
      const allCoords = [...origins, ...destinations];
      const coordsString = allCoords.map((c) => `${c.lon},${c.lat}`).join(';');
      const sourcesParam = origins.map((_, i) => i).join(';');
      const destinationsParam = destinations.map((_, i) => origins.length + i).join(';');

      const url = `${this.osrmUrl}/table/v1/driving/${coordsString}?sources=${sourcesParam}&destinations=${destinationsParam}&annotations=duration,distance`;
      const response = await fetch(url, { signal: AbortSignal.timeout(1500) });

      if (!response.ok) throw new Error(`OSRM table error status ${response.status}`);
      const data = await response.json();

      return {
        durationsSeconds: data.durations || [],
        distancesMeters: data.distances || [],
        source: 'self-hosted-osrm',
      };
    } catch (err: any) {
      this.logger.warn(`OSRM matrix failed: ${err.message}`);
      return {
        durationsSeconds: [],
        distancesMeters: [],
        source: 'fallback',
      };
    }
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
    try {
      const res = await fetch(`${this.osrmUrl}/nearest/v1/driving/-7.6320,33.5885`, {
        signal: AbortSignal.timeout(2000),
      });
      return res.ok;
    } catch {
      return false;
    }
  }

  private fallbackHaversineRoute(origin: Coordinates, dest: Coordinates): RouteResult {
    const R = 6371; // km
    const dLat = ((dest.lat - origin.lat) * Math.PI) / 180;
    const dLon = ((dest.lon - origin.lon) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((origin.lat * Math.PI) / 180) *
        Math.cos((dest.lat * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distanceKm = Math.round(R * c * 1.25 * 10) / 10; // 1.25 urban winding factor
    const durationMinutes = Math.max(3, Math.round((distanceKm / 28) * 60 + 2));

    return {
      distanceMeters: Math.round(distanceKm * 1000),
      distanceKm,
      durationSeconds: durationMinutes * 60,
      durationMinutes,
      geometryGeoJson: {
        type: 'LineString',
        coordinates: [
          [origin.lon, origin.lat],
          [dest.lon, dest.lat],
        ],
      },
      source: 'haversine-fallback',
    };
  }
}

