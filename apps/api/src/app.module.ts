import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { RidersModule } from './modules/riders/riders.module';
import { DriversModule } from './modules/drivers/drivers.module';
import { RidesModule } from './modules/rides/rides.module';
import { PricingModule } from './modules/pricing/pricing.module';
import { WalletsModule } from './modules/wallets/wallets.module';
import { ReferralsModule } from './modules/referrals/referrals.module';
import { EventsModule } from './modules/events/events.module';
import { SafetyModule } from './modules/safety/safety.module';
import { MapsModule } from './modules/maps/maps.module';
import { DatabaseModule } from './database/database.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    DatabaseModule,
    MapsModule,
    AuthModule,
    UsersModule,
    RidersModule,
    DriversModule,
    RidesModule,
    PricingModule,
    WalletsModule,
    ReferralsModule,
    EventsModule,
    SafetyModule,
  ],
})
export class AppModule {}

