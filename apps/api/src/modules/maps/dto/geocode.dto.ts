import { IsString, IsNotEmpty, IsOptional, IsNumber, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class SearchPlacesQueryDto {
  @ApiProperty({ description: 'نص البحث بالدارجة، العربية، أو الفرنسية', example: 'موروكو مول' })
  @IsString()
  @IsNotEmpty()
  q: string;

  @ApiPropertyOptional({ description: 'خط العرض لقرب نقطة البحث', example: 33.5885 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  lat?: number;

  @ApiPropertyOptional({ description: 'خط الطول لقرب نقطة البحث', example: -7.6320 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  lon?: number;

  @ApiPropertyOptional({ description: 'الحد الأقصى لعدد النتائج', default: 8 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  limit?: number = 8;
}

export class ReverseGeocodeQueryDto {
  @ApiProperty({ description: 'خط العرض', example: 33.5885 })
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  lat: number;

  @ApiProperty({ description: 'خط الطول', example: -7.6320 })
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  lon: number;
}

