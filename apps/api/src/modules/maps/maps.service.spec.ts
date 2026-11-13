import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { MapsService } from './maps.service';
import { PlacesService } from './places.service';
import { MapsCacheService } from './maps.cache';
import { SelfHostedMapProvider } from './providers/self-hosted-map.provider';
import { OpenRouteServiceMapProvider } from './providers/openrouteservice-map.provider';
import { MapboxMapProvider } from './providers/mapbox-map.provider';
import { DATABASE_POOL } from '../../database/database.module';

describe('MapsService & MapProvider Architecture', () => {
  jest.setTimeout(25000);
  let service: MapsService;
  let placesService: PlacesService;
  let cacheService: MapsCacheService;

  const mockDbPool = {
    query: jest.fn().mockResolvedValue({ rows: [] }),
  };

  const mockConfigService = {
    get: jest.fn((key: string, defaultVal: string) => {
      if (key === 'MAP_PROVIDER') return 'self-hosted';
      return defaultVal;
    }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MapsService,
        SelfHostedMapProvider,
        OpenRouteServiceMapProvider,
        MapboxMapProvider,
        PlacesService,
        MapsCacheService,
        {
          provide: ConfigService,
          useValue: mockConfigService,
        },
        {
          provide: DATABASE_POOL,
          useValue: mockDbPool,
        },
      ],
    }).compile();

    service = module.get<MapsService>(MapsService);
    placesService = module.get<PlacesService>(PlacesService);
    cacheService = module.get<MapsCacheService>(MapsCacheService);
  });

  it('should be defined with active provider self-hosted-osrm-photon', () => {
    expect(service).toBeDefined();
    expect(service.getActiveProviderName()).toBe('self-hosted-osrm-photon');
  });

  it('should search places catalog first for Casablanca Airport (CMN)', async () => {
    const results = await service.search('مطار محمد الخامس');
    expect(results.length).toBeGreaterThan(0);
    expect(results[0].name).toContain('مطار محمد الخامس');
    expect(results[0].coordinates.lat).toBeCloseTo(33.3675, 2);
    expect(results[0].coordinates.lon).toBeCloseTo(-7.5899, 2);
    expect(results[0].source).toBe('postgis_places');
  });

  it('should search places catalog for Casa-Port and Morocco Mall', async () => {
    const portResults = await service.search('كازا بورت');
    expect(portResults.length).toBeGreaterThan(0);
    expect(portResults[0].coordinates.lat).toBeCloseTo(33.6015, 2);

    const mallResults = await service.search('Morocco Mall');
    expect(mallResults.length).toBeGreaterThan(0);
    expect(mallResults[0].coordinates.lat).toBeCloseTo(33.5780, 2);
  });

  it('should calculate resilient route and ETA between Casablanca Maarif and Morocco Mall', async () => {
    const route = await service.route(
      { lat: 33.5885, lon: -7.6320 }, // Maarif
      { lat: 33.5780, lon: -7.6980 }, // Morocco Mall
    );

    expect(route).toBeDefined();
    expect(route.distanceKm).toBeGreaterThan(5);
    expect(route.distanceKm).toBeLessThan(15);
    expect(route.durationMinutes).toBeGreaterThan(10);
    expect(route.durationMinutes).toBeLessThan(45);
  });

  it('should allow runtime switching of provider to OpenRouteService and Mapbox', () => {
    service.setProvider('openrouteservice');
    expect(service.getActiveProviderName()).toBe('openrouteservice');

    service.setProvider('mapbox');
    expect(service.getActiveProviderName()).toBe('mapbox-fallback');

    service.setProvider('self-hosted');
    expect(service.getActiveProviderName()).toBe('self-hosted-osrm-photon');
  });

  afterAll(async () => {
    await cacheService.onModuleDestroy();
  });
});

