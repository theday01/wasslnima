import {
  IsNotEmpty,
  IsNumber,
  IsString,
  IsOptional,
  Min,
  Max,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateRideRequestDto {
  @ApiProperty({ example: 'CASABLANCA' })
  @IsNotEmpty()
  @IsString()
  cityId: string;

  @ApiProperty({ example: 'ECO' })
  @IsNotEmpty()
  @IsString()
  categoryId: string;

  @ApiProperty({ example: 33.5898 })
  @IsNumber()
  pickupLat: number;

  @ApiProperty({ example: -7.6038 })
  @IsNumber()
  pickupLng: number;

  @ApiProperty({ example: 'شارع الزرقطوني، المعاريف، الدار البيضاء' })
  @IsNotEmpty()
  @IsString()
  pickupAddress: string;

  @ApiProperty({
    example: 'قبالة البنك الشعبي، حدا الصيدلية',
    description: 'Moroccan landmark description',
  })
  @IsOptional()
  @IsString()
  pickupLandmark?: string;

  @ApiProperty({ example: 33.5731 })
  @IsNumber()
  dropoffLat: number;

  @ApiProperty({ example: -7.5898 })
  @IsNumber()
  dropoffLng: number;

  @ApiProperty({ example: 'موروكو مول، عين الذياب، الدار البيضاء' })
  @IsNotEmpty()
  @IsString()
  dropoffAddress: string;

  @ApiProperty({ example: 30.0, description: 'Rider proposed price in MAD' })
  @IsNumber()
  @Min(10, { message: 'أقل سعر للرحلة هو 10 دراهم' })
  riderSuggestedPriceMad: number;
}

export class SubmitDriverOfferDto {
  @ApiProperty({ example: 'd3b07384-d113-469b-9c74-29724be79121' })
  @IsNotEmpty()
  @IsString()
  requestId: string;

  @ApiProperty({ example: 32.0, description: 'Driver bid price in MAD' })
  @IsNumber()
  @Min(10)
  offeredPriceMad: number;

  @ApiProperty({ example: 4, description: 'Estimated arrival minutes' })
  @IsNumber()
  @Min(1)
  @Max(60)
  estimatedArrivalMinutes: number;
}

