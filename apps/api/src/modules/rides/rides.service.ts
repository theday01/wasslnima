import {
  Injectable,
  Logger,
  NotFoundException,
  BadRequestException,
  Inject,
} from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../../database/database.module';
import { PricingService } from '../pricing/pricing.service';
import { EventsGateway } from '../events/events.gateway';
import { MapsService } from '../maps/maps.service';
import { CreateRideRequestDto, SubmitDriverOfferDto } from './rides.dto';

@Injectable()
export class RidesService {
  private readonly logger = new Logger(RidesService.name);

  constructor(
    @Inject(DATABASE_POOL) private readonly db: Pool,
    private readonly pricingService: PricingService,
    private readonly eventsGateway: EventsGateway,
    private readonly mapsService: MapsService,
  ) {}

  /**
   * Rider creates a new ride request with negotiated suggested price
   */
  async createRideRequest(riderId: string, dto: CreateRideRequestDto) {
    // 1. Calculate trip distance and duration via backend MapProvider once
    let distanceKm = 0;
    let durationMinutes = 0;
    let routeGeoJson: any = null;

    try {
      const routeResult = await this.mapsService.route(
        { lat: dto.pickupLat, lon: dto.pickupLng },
        { lat: dto.dropoffLat, lon: dto.dropoffLng },
        'driving-car',
      );
      distanceKm = routeResult.distanceKm;
      durationMinutes = routeResult.durationMinutes;
      routeGeoJson = routeResult.geometryGeoJson;
    } catch {
      distanceKm = this.pricingService.calculateHaversineDistance(
        dto.pickupLat,
        dto.pickupLng,
        dto.dropoffLat,
        dto.dropoffLng,
      );
      durationMinutes = Math.max(5, Math.round((distanceKm / 25) * 60 + 3));
    }

    // 2. Fetch or compute reference price
    const estimate = this.pricingService.calculateTripEstimate({
      distanceKm,
      durationMinutes,
      baseFareMad: 7.0, // Casa baseline
      perKmRateMad: 3.5,
      perMinuteRateMad: 0.5,
      minimumFareMad: 12.0,
    });

    if (dto.riderSuggestedPriceMad < estimate.minSuggestedPriceMad) {
      throw new BadRequestException(
        `السعر المقترح منخفض جداً. الحد الأدنى المقبول لهذه المسافة هو ${estimate.minSuggestedPriceMad} درهم`,
      );
    }

    const expiresAt = new Date(Date.now() + 2 * 60 * 1000); // 2 minutes bidding window

    // 3. Insert into Database
    const client = await this.db.connect();
    try {
      const res = await client.query(
        `INSERT INTO ride_requests (
          rider_id, city_id, category_id,
          pickup_location, pickup_address_text, pickup_landmark_description,
          dropoff_location, dropoff_address_text,
          estimated_distance_km, estimated_duration_minutes,
          calculated_reference_price_mad, rider_suggested_price_mad,
          status, expires_at
        ) VALUES (
          $1, $2, $3,
          ST_SetSRID(ST_MakePoint($4, $5), 4326), $6, $7,
          ST_SetSRID(ST_MakePoint($8, $9), 4326), $10,
          $11, $12, $13, $14, 'REQUESTED', $15
        ) RETURNING id, created_at, status`,
        [
          riderId,
          dto.cityId,
          dto.categoryId,
          dto.pickupLng,
          dto.pickupLat,
          dto.pickupAddress,
          dto.pickupLandmark,
          dto.dropoffLng,
          dto.dropoffLat,
          dto.dropoffAddress,
          estimate.distanceKm,
          estimate.durationMinutes,
          estimate.referencePriceMad,
          dto.riderSuggestedPriceMad,
          expiresAt,
        ],
      );

      const created = res.rows[0];

      // 4. Broadcast via WebSocket to nearby drivers in city room
      this.eventsGateway.broadcastRideRequest(dto.cityId, {
        id: created.id,
        cityId: dto.cityId,
        pickupAddress: dto.pickupAddress,
        pickupLandmark: dto.pickupLandmark,
        dropoffAddress: dto.dropoffAddress,
        distanceKm: estimate.distanceKm,
        durationMinutes: estimate.durationMinutes,
        riderSuggestedPriceMad: dto.riderSuggestedPriceMad,
        referencePriceMad: estimate.referencePriceMad,
        expiresAt,
      });

      return {
        success: true,
        data: {
          requestId: created.id,
          distanceKm: estimate.distanceKm,
          durationMinutes: estimate.durationMinutes,
          referencePriceMad: estimate.referencePriceMad,
          riderSuggestedPriceMad: dto.riderSuggestedPriceMad,
          expiresAt,
        },
      };
    } finally {
      client.release();
    }
  }

  /**
   * Driver submits a bid offer for an active request
   */
  async submitOffer(driverId: string, dto: SubmitDriverOfferDto) {
    const client = await this.db.connect();
    try {
      // Check request validity
      const reqRes = await client.query(
        `SELECT r.*, u.phone_number 
         FROM ride_requests r
         JOIN riders rd ON r.rider_id = rd.id
         JOIN users u ON rd.id = u.id
         WHERE r.id = $1 AND r.status IN ('REQUESTED', 'OFFERS_RECEIVED')`,
        [dto.requestId],
      );

      if (reqRes.rows.length === 0) {
        throw new NotFoundException('طلب الرحلة غير متوفر أو تم إلغاؤه');
      }

      const rideReq = reqRes.rows[0];
      const expiresAt = new Date(Date.now() + 60 * 1000); // 1 min offer TTL

      // Insert offer
      const offerRes = await client.query(
        `INSERT INTO ride_offers (
          request_id, driver_id, offered_price_mad, estimated_arrival_minutes, expires_at
        ) VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (request_id, driver_id) DO UPDATE SET
          offered_price_mad = EXCLUDED.offered_price_mad,
          estimated_arrival_minutes = EXCLUDED.estimated_arrival_minutes,
          status = 'PENDING',
          expires_at = EXCLUDED.expires_at
        RETURNING id`,
        [dto.requestId, driverId, dto.offeredPriceMad, dto.estimatedArrivalMinutes, expiresAt],
      );

      // Fetch driver info for rider push
      const driverRes = await client.query(
        `SELECT d.*, u.full_name, u.avatar_url, v.make, v.model, v.license_plate
         FROM drivers d
         JOIN users u ON d.id = u.id
         LEFT JOIN vehicles v ON v.driver_id = d.id AND v.is_active = true
         WHERE d.id = $1`,
        [driverId],
      );

      const driver = driverRes.rows[0];

      // Push offer to rider via WebSocket
      this.eventsGateway.pushOfferToRider(rideReq.rider_id, {
        offerId: offerRes.rows[0].id,
        requestId: dto.requestId,
        driver: {
          id: driver.id,
          name: driver.full_name || 'سائق وصّلني',
          avatarUrl: driver.avatar_url,
          rating: Number(driver.rating_avg),
          vehicle: `${driver.make || 'Dacia'} ${driver.model || 'Logan'} (${driver.license_plate || 'مغرب'})`,
        },
        offeredPriceMad: dto.offeredPriceMad,
        estimatedArrivalMinutes: dto.estimatedArrivalMinutes,
        expiresAt,
      });

      return {
        success: true,
        message: 'تم إرسال عرضك بنجاح للراكب',
      };
    } finally {
      client.release();
    }
  }

  /**
   * Rider accepts a driver's bid offer -> Converts request to active Ride
   */
  async acceptOffer(riderId: string, offerId: string) {
    const client = await this.db.connect();
    try {
      await client.query('BEGIN');

      // Fetch offer and request
      const offerRes = await client.query(
        `SELECT o.*, req.city_id, req.category_id, req.pickup_location, req.pickup_address_text,
                req.pickup_landmark_description, req.dropoff_location, req.dropoff_address_text,
                req.estimated_distance_km, req.estimated_duration_minutes, req.rider_id
         FROM ride_offers o
         JOIN ride_requests req ON o.request_id = req.id
         WHERE o.id = $1 AND o.status = 'PENDING' AND req.rider_id = $2
         FOR UPDATE`,
        [offerId, riderId],
      );

      if (offerRes.rows.length === 0) {
        throw new NotFoundException('العرض غير متاح أو تم قبوله مسبقاً');
      }

      const offer = offerRes.rows[0];

      // Fetch driver's active vehicle
      const vehicleRes = await client.query(
        `SELECT id FROM vehicles WHERE driver_id = $1 AND is_active = true LIMIT 1`,
        [offer.driver_id],
      );

      const vehicleId = vehicleRes.rows[0]?.id;

      // Create Ride
      const rideRes = await client.query(
        `INSERT INTO rides (
          request_id, rider_id, driver_id, vehicle_id, city_id, category_id,
          pickup_location, pickup_address_text, pickup_landmark_description,
          dropoff_location, dropoff_address_text,
          agreed_price_mad, total_amount_mad, payment_method, status
        ) VALUES (
          $1, $2, $3, $4, $5, $6,
          $7, $8, $9,
          $10, $11,
          $12, $12, 'CASH', 'MATCHED'
        ) RETURNING id, status, agreed_price_mad, matched_at`,
        [
          offer.request_id,
          riderId,
          offer.driver_id,
          vehicleId,
          offer.city_id,
          offer.category_id,
          offer.pickup_location,
          offer.pickup_address_text,
          offer.pickup_landmark_description,
          offer.dropoff_location,
          offer.dropoff_address_text,
          offer.offered_price_mad,
        ],
      );

      const ride = rideRes.rows[0];

      // Update offer status
      await client.query(`UPDATE ride_offers SET status = 'ACCEPTED' WHERE id = $1`, [offerId]);
      // Update request status
      await client.query(`UPDATE ride_requests SET status = 'MATCHED' WHERE id = $1`, [
        offer.request_id,
      ]);
      // Reject other pending offers
      await client.query(
        `UPDATE ride_offers SET status = 'REJECTED' WHERE request_id = $1 AND id != $2`,
        [offer.request_id, offerId],
      );

      await client.query('COMMIT');

      // Notify driver via WebSocket
      this.eventsGateway.notifyDriverOfferAccepted(offer.driver_id, {
        rideId: ride.id,
        pickupAddress: offer.pickup_address_text,
        pickupLandmark: offer.pickup_landmark_description,
        dropoffAddress: offer.dropoff_address_text,
        agreedPriceMad: ride.agreed_price_mad,
      });

      return {
        success: true,
        message: 'تم قبول العرض وتأكيد الرحلة بنجاح!',
        data: {
          rideId: ride.id,
          status: ride.status,
          agreedPriceMad: ride.agreed_price_mad,
        },
      };
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  }
}

