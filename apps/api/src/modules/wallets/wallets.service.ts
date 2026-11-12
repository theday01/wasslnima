import { Injectable, Logger, Inject } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../../database/database.module';

@Injectable()
export class WalletsService {
  private readonly logger = new Logger(WalletsService.name);

  constructor(@Inject(DATABASE_POOL) private readonly db: Pool) {}

  /**
   * Get driver free commission days and accumulated months status
   */
  async getDriverCommissionStatus(driverId: string) {
    const client = await this.db.connect();
    try {
      const res = await client.query(
        `SELECT d.first_completed_ride_at, d.free_commission_until,
                d.accumulated_free_months_count, d.debt_limit_mad,
                w.balance_mad
         FROM drivers d
         JOIN wallets w ON w.user_id = d.id
         WHERE d.id = $1`,
        [driverId],
      );

      if (res.rows.length === 0) {
        return {
          isFreeCommissionActive: true,
          daysRemaining: 60,
          accumulatedMonths: 0,
          maxAllowedMonths: 6,
          walletBalanceMad: 0.0,
        };
      }

      const driver = res.rows[0];
      const now = new Date();
      let isFree = false;
      let daysRemaining = 0;

      if (!driver.first_completed_ride_at) {
        // Driver has not completed first ride yet -> 60 full days ready
        isFree = true;
        daysRemaining = 60;
      } else if (driver.free_commission_until && new Date(driver.free_commission_until) > now) {
        isFree = true;
        const diffMs = new Date(driver.free_commission_until).getTime() - now.getTime();
        daysRemaining = Math.max(0, Math.ceil(diffMs / (1000 * 60 * 60 * 24)));
      }

      return {
        isFreeCommissionActive: isFree,
        daysRemaining,
        accumulatedMonths: driver.accumulated_free_months_count || 0,
        maxAllowedMonths: 6,
        walletBalanceMad: Number(driver.balance_mad),
        debtLimitMad: Number(driver.debt_limit_mad),
      };
    } finally {
      client.release();
    }
  }

  /**
   * Called automatically when a driver completes a ride.
   * If driver completed first ride, activate 60 days countdown.
   */
  async onDriverRideCompleted(driverId: string, ridePriceMad: number) {
    const client = await this.db.connect();
    try {
      await client.query('BEGIN');

      const driverRes = await client.query(
        `SELECT first_completed_ride_at, free_commission_until, accumulated_free_months_count
         FROM drivers WHERE id = $1 FOR UPDATE`,
        [driverId],
      );

      const driver = driverRes.rows[0];
      if (!driver) return;

      const now = new Date();

      if (!driver.first_completed_ride_at) {
        // Start 60 days free commission timer from first completed ride!
        const freeUntil = new Date(now.getTime() + 60 * 24 * 60 * 60 * 1000);
        await client.query(
          `UPDATE drivers
           SET first_completed_ride_at = $1,
               free_commission_until = $2,
               accumulated_free_months_count = 2
           WHERE id = $3`,
          [now, freeUntil, driverId],
        );
        this.logger.log(`Activated 60 days 0% commission for driver: ${driverId}`);
      }

      await client.query('COMMIT');
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  }
}

