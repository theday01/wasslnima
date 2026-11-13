import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MapsService } from './maps.service';
import { MapsController } from './maps.controller';
import { SelfHostedMapProvider } from './providers/self-hosted-map.provider';
import { OpenRouteServiceMapProvider } from './providers/openrouteservice-map.provider';
import { MapboxMapProvider } from './providers/mapbox-map.provider';
import { PlacesService } from './places.service';
import { MapsCacheService } from './maps.cache';
import { DatabaseModule } from '../../database/database.module';

@Global()
@Module({
  imports: [ConfigModule, DatabaseModule],
  controllers: [MapsController],
  providers: [
    MapsService,
    SelfHostedMapProvider,
    OpenRouteServiceMapProvider,
    MapboxMapProvider,
    PlacesService,
    MapsCacheService,
  ],
  exports: [MapsService, PlacesService, MapsCacheService],
})
export class MapsModule { }

