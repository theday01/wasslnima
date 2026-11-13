export interface Coordinates {
  lat: number;
  lon: number;
}

export interface GeocodeResult {
  id: string;
  name: string;
  label: string;
  coordinates: Coordinates;
  city?: string;
  postcode?: string;
  country: string;
  source: 'postgis_places' | 'photon' | 'openrouteservice' | 'mapbox';
  category?: string;
  score?: number;
}

export interface ReverseGeocodeResult {
  formattedAddress: string;
  street?: string;
  district?: string;
  city: string;
  coordinates: Coordinates;
  country: string;
  source: string;
}

export interface RouteStep {
  instruction: string;
  distanceMeters: number;
  durationSeconds: number;
  name?: string;
}

export interface RouteResult {
  distanceMeters: number;
  distanceKm: number;
  durationSeconds: number;
  durationMinutes: number;
  geometryGeoJson?: any;
  encodedPolyline?: string;
  steps?: RouteStep[];
  source: string;
}

export interface MatrixResult {
  durationsSeconds: number[][];
  distancesMeters: number[][];
  source: string;
}

export interface EtaResult {
  durationSeconds: number;
  durationMinutes: number;
  distanceKm: number;
  source: string;
}

export interface GeocodeOptions {
  proximity?: Coordinates;
  bbox?: [number, number, number, number]; // [minLon, minLat, maxLon, maxLat]
  limit?: number;
  language?: string;
  countryCode?: string; // Default: 'ma'
}

