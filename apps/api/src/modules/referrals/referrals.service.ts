import { Injectable, Logger, BadRequestException, Inject } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../../database/database.module';

@Injectable()
export class ReferralsService {
  private readonly logger = new Logger(ReferralsService.name);

  constructor(@Inject(DATABASE_POOL) private readonly db: Pool) {}

  /**
   * Track driver qualifying completed rides and grant rewards when reaching 5 rides
   */
  async recordDriverCompletedRide(driverId: string) {
    const client = await this.db.connect();
    try {
      await client.query('BEGIN');

      // Check if this driver was referred by someone and not yet rewarded
      const refRes = await client.query(
        `SELECT * FROM driver_referrals 
         WHERE referred_driver_id = $1 AND is_reward_granted = false AND suspected_fraud = false
         FOR UPDATE`,
        [driverId],
      );

      if (refRes.rows.length === 0) {
        await client.query('COMMIT');
        return;
      }

      const referral = refRes.rows[0];
      const newCount = referral.qualifying_rides_completed + 1;

      if (newCount >= referral.qualifying_rides_required) {
        // Milestone reached (5 completed rides)!
        const referrerId = referral.referrer_driver_id;

        // Check referrer's accumulated months limit (Max 6 months)
        const referrerRes = await client.query(
          `SELECT accumulated_free_months_count, free_commission_until 
           FROM drivers WHERE id = $1 FOR UPDATE`,
          [referrerId],
        );

        const referrer = referrerRes.rows[0];
        const currentMonths = referrer.accumulated_free_months_count || 0;

        if (currentMonths < 6) {
          // Grant 1 additional month (30 days) to referrer
          const baseDate =
            referrer.free_commission_until && new Date(referrer.free_commission_until) > new Date()
              ? new Date(referrer.free_commission_until)
              : new Date();

          const newUntil = new Date(baseDate.getTime() + 30 * 24 * 60 * 60 * 1000);

          await client.query(
            `UPDATE drivers
             SET free_commission_until = $1,
                 accumulated_free_months_count = accumulated_free_months_count + 1
             WHERE id = $2`,
            [newUntil, referrerId],
          );
        }

        // Grant 1 additional week (7 days) to referee
        const refereeRes = await client.query(
          `SELECT free_commission_until FROM drivers WHERE id = $1 FOR UPDATE`,
          [driverId],
        );
        const refBaseDate =
          refereeRes.rows[0]?.free_commission_until &&
          new Date(refereeRes.rows[0].free_commission_until) > new Date()
            ? new Date(refereeRes.rows[0].free_commission_until)
            : new Date();

        const refNewUntil = new Date(refBaseDate.getTime() + 7 * 24 * 60 * 60 * 1000);
        await client.query(
          `UPDATE drivers SET free_commission_until = $1 WHERE id = $2`,
          [refNewUntil, driverId],
        );

        // Mark referral rewarded
        await client.query(
          `UPDATE driver_referrals 
           SET qualifying_rides_completed = $1,
               is_reward_granted = true,
               reward_granted_at = CURRENT_TIMESTAMP
           WHERE id = $2`,
          [newCount, referral.id],
        );

        this.logger.log(
          `Referral milestone achieved! Referrer: ${referrerId} (+30d), Referee: ${driverId} (+7d)`,
        );
      } else {
        // Increment progress towards 5 rides
        await client.query(
          `UPDATE driver_referrals SET qualifying_rides_completed = $1 WHERE id = $2`,
          [newCount, referral.id],
        );
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

