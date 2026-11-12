import { IsNotEmpty, Matches, IsEnum, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export enum OtpChannel {
  SMS = 'SMS',
  WHATSAPP = 'WHATSAPP',
}

export class SendOtpDto {
  @ApiProperty({ example: '+212612345678', description: 'Moroccan phone number' })
  @IsNotEmpty({ message: 'رقم الهاتف مطلوب' })
  @Matches(/^\+212[5-7][0-9]{8}$/, {
    message: 'يجب إدخال رقم هاتف مغربي صحيح بالصيغة الدولية (+212XXXXXXXXX)',
  })
  phoneNumber: string;

  @ApiProperty({ enum: OtpChannel, default: OtpChannel.SMS, required: false })
  @IsOptional()
  @IsEnum(OtpChannel)
  channel?: OtpChannel = OtpChannel.SMS;
}

export class VerifyOtpDto {
  @ApiProperty({ example: '+212612345678' })
  @IsNotEmpty()
  @Matches(/^\+212[5-7][0-9]{8}$/)
  phoneNumber: string;

  @ApiProperty({ example: '123456' })
  @IsNotEmpty({ message: 'رمز التحقق مطلوب' })
  @Matches(/^[0-9]{6}$/, { message: 'رمز التحقق يتكون من 6 أرقام' })
  otpCode: string;
}

