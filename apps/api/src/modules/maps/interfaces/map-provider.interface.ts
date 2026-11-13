import {
  Coordinates,
  GeocodeOptions,
  GeocodeResult,
  ReverseGeocodeResult,
  RouteResult,
  MatrixResult,
  EtaResult,
} from './map-results.interface';

export const MAP_PROVIDER_TOKEN = 'MAP_PROVIDER_TOKEN';

export interface MapProvider {
  readonly providerName: string;

  /**
   * Forward Geocoding: Search street, address or landmark by text
   */
  search(query: string, options?: GeocodeOptions): Promise<GeocodeResult[]>;

  /**
   * Reverse Geocoding: Convert coordinates to street address
   */
  reverse(lat: number, lon: number): Promise<ReverseGeocodeResult>;

  /**
   * Routing: Compute driving route between origin and destination
   */
  route(
    origin: Coordinates,
    destination: Coordinates,
    profile?: 'driving-car' | 'motorcycle',
  ): Promise<RouteResult>;

  /**
   * Distance Matrix: Compute distances and durations for N origins to M destinations
   */
  matrix(
    origins: Coordinates[],
    destinations: Coordinates[],
  ): Promise<MatrixResult>;

  /**
   * Estimate travel time and distance
   */
  eta(origin: Coordinates, destination: Coordinates): Promise<EtaResult>;

  /**
   * Health check to ensure service is responding
   */
  healthCheck(): Promise<boolean>;
}

