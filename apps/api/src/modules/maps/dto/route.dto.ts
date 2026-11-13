import { IsNumber, Min, Max, IsOptional, IsIn } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CalculateRouteDto {
  @ApiProperty({ description: 'خط عرض نقطة الانطلاق', example: 33.5885 })
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  originLat: number;

  @ApiProperty({ description: 'خط طول نقطة الانطلاق', example: -7.6320 })
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  originLon: number;

  @ApiProperty({ description: 'خط عرض نقطة الوصول', example: 33.5780 })
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  destLat: number;

  @ApiProperty({ description: 'خط طول نقطة الوصول', example: -7.6980 })
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  destLon: number;

  @ApiPropertyOptional({ description: 'نوع المركبة', enum: ['driving-car', 'motorcycle'], default: 'driving-car' })
  @IsOptional()
  @IsIn(['driving-car', 'motorcycle'])
  profile?: 'driving-car' | 'motorcycle' = 'driving-car';
}

