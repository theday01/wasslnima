import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UsePipes,
  ValidationPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { MapsService } from './maps.service';
import { SearchPlacesQueryDto, ReverseGeocodeQueryDto } from './dto/geocode.dto';
import { CalculateRouteDto } from './dto/route.dto';

@ApiTags('Maps & Routing (محرك الخرائط والملاحة)')
@Controller('maps')
export class MapsController {
  constructor(private readonly mapsService: MapsService) { }

  @Get('search')
  @ApiOperation({ summary: 'البحث عن الأماكن والعناوين والمعالم (Search Places & Addresses)' })
  @ApiResponse({ status: 200, description: 'قائمة الأماكن المطابقة مرتبة حسب الأهمية والقرب' })
  async search(@Query() query: SearchPlacesQueryDto) {
    const proximity =
      query.lat !== undefined && query.lon !== undefined
        ? { lat: query.lat, lon: query.lon }
        : undefined;

    const results = await this.mapsService.search(query.q, {
      proximity,
      limit: query.limit || 8,
      language: 'ar',
      countryCode: 'ma',
    });

    return {
      status: 'success',
      count: results.length,
      provider: this.mapsService.getActiveProviderName(),
      data: results,
    };
  }

  @Get('reverse')
  @ApiOperation({ summary: 'الترميز العكسي للإحداثيات إلى عنوان شارع (Reverse Geocoding)' })
  async reverse(@Query() query: ReverseGeocodeQueryDto) {
    const address = await this.mapsService.reverse(query.lat, query.lon);
    return {
      status: 'success',
      data: address,
    };
  }

  @Post('route')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'حساب المسار والمسافة وزمن الرحلة الدقيق (Calculate Route & Polyline)' })
  async calculateRoute(@Body() dto: CalculateRouteDto) {
    const route = await this.mapsService.route(
      { lat: dto.originLat, lon: dto.originLon },
      { lat: dto.destLat, lon: dto.destLon },
      dto.profile || 'driving-car',
    );

    return {
      status: 'success',
      data: route,
    };
  }

  @Get('eta')
  @ApiOperation({ summary: 'حساب زمن ومسافة الوصول التقديري (Estimate Time of Arrival)' })
  async getEta(
    @Query('originLat') oLat: number,
    @Query('originLon') oLon: number,
    @Query('destLat') dLat: number,
    @Query('destLon') dLon: number,
  ) {
    const eta = await this.mapsService.eta(
      { lat: Number(oLat), lon: Number(oLon) },
      { lat: Number(dLat), lon: Number(dLon) },
    );

    return {
      status: 'success',
      data: eta,
    };
  }

  @Get('provider/status')
  @ApiOperation({ summary: 'معاينة حالة المزود النشط ومحركات الخرائط (Active Provider Status)' })
  getProviderStatus() {
    return {
      status: 'operational',
      activeProvider: this.mapsService.getActiveProviderName(),
      supportedProviders: ['self-hosted', 'openrouteservice', 'mapbox'],
      caching: 'Redis + In-Memory Tiered Cache',
      primarySearch: 'PostGIS Places Spatial Table (Morocco POIs)',
    };
  }

  @Post('provider/switch')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'تبديل مزود الخرائط ديناميكياً (Switch Map Provider)' })
  switchProvider(@Body('provider') provider: 'self-hosted' | 'openrouteservice' | 'mapbox') {
    this.mapsService.setProvider(provider);
    return {
      status: 'success',
      message: `تم تحويل مزود الخرائط بنجاح إلى: ${provider}`,
      activeProvider: this.mapsService.getActiveProviderName(),
    };
  }
}

