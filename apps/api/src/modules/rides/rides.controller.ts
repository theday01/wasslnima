import {
  Controller,
  Post,
  Body,
  Param,
  HttpCode,
  HttpStatus,
  Headers,
  UnauthorizedException,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiHeader } from '@nestjs/swagger';
import { RidesService } from './rides.service';
import { CreateRideRequestDto, SubmitDriverOfferDto } from './rides.dto';
import { JwtService } from '@nestjs/jwt';

@ApiTags('Rides')
@Controller('rides')
export class RidesController {
  constructor(
    private readonly ridesService: RidesService,
    private readonly jwtService: JwtService,
  ) {}

  private extractUserId(authHeader?: string): string {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      // In dev sandbox allow fallback mock id
      return '11111111-1111-1111-1111-111111111111';
    }
    const token = authHeader.split(' ')[1];
    try {
      const decoded = this.jwtService.decode(token) as any;
      return decoded?.sub || '11111111-1111-1111-1111-111111111111';
    } catch {
      throw new UnauthorizedException('Invalid JWT token');
    }
  }

  @Post('requests')
  @ApiOperation({ summary: 'إنشاء طلب رحلة وتفاوض جديد من الراكب مع السعر المقترح' })
  @ApiResponse({ status: 201, description: 'تم إنشاء الطلب وبثه للسائقين القريبين' })
  async createRequest(
    @Headers('authorization') auth: string,
    @Body() dto: CreateRideRequestDto,
  ) {
    const riderId = this.extractUserId(auth);
    return this.ridesService.createRideRequest(riderId, dto);
  }

  @Post('offers')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'تقديم عرض سعر من السائق على طلب معروض' })
  async submitOffer(
    @Headers('authorization') auth: string,
    @Body() dto: SubmitDriverOfferDto,
  ) {
    const driverId = this.extractUserId(auth);
    return this.ridesService.submitOffer(driverId, dto);
  }

  @Post('offers/:offerId/accept')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'قبول عرض السائق وتأكيد الرحلة' })
  async acceptOffer(
    @Headers('authorization') auth: string,
    @Param('offerId') offerId: string,
  ) {
    const riderId = this.extractUserId(auth);
    return this.ridesService.acceptOffer(riderId, offerId);
  }
}

