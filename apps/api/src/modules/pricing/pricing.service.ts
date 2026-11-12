import { Injectable } from '@nestjs/common';

export interface PricingParameters {
  distanceKm: number;
  durationMinutes: number;
  baseFareMad: number;
  perKmRateMad: number;
  perMinuteRateMad: number;
  minimumFareMad: number;
  surgeMultiplier?: number;
  isNight?: boolean;
}

@Injectable()
export class PricingService {
  /**
   * Calculate reference baseline price and negotiation bounds for a ride
   */
  calculateTripEstimate(params: PricingParameters) {
    const surge = params.surgeMultiplier || 1.0;
    const nightSurge = params.isNight ? 1.2 : 1.0; // +20% night rate (22:00 to 06:00)

    const rawFare =
      params.baseFareMad +
      params.distanceKm * params.perKmRateMad +
      params.durationMinutes * params.perMinuteRateMad;

    // Apply surges
    const calculatedFare = rawFare * surge * nightSurge;

    // Ensure minimum fare threshold
    const referencePriceMad = Math.max(
      params.minimumFareMad,
      Math.round(calculatedFare * 10) / 10,
    );

    // Negotiation Bounds (inDrive model: Rider can propose between -30% to +100%)
    const minSuggestedPriceMad = Math.max(
      params.minimumFareMad,
      Math.round(referencePriceMad * 0.7),
    );
    const maxSuggestedPriceMad = Math.round(referencePriceMad * 2.0);

    return {
      distanceKm: Math.round(params.distanceKm * 10) / 10,
      durationMinutes: Math.round(params.durationMinutes),
      referencePriceMad,
      minSuggestedPriceMad,
      maxSuggestedPriceMad,
      isNightFareApplied: !!params.isNight,
    };
  }

  /**
   * Helper to compute spherical distance between two WGS84 coordinates in kilometers (Haversine Formula)
   */
  calculateHaversineDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number,
  ): number {
    const R = 6371; // Earth radius in km
    const dLat = this.deg2rad(lat2 - lat1);
    const dLon = this.deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.deg2rad(lat1)) *
        Math.cos(this.deg2rad(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private deg2rad(deg: number): number {
    return deg * (Math.PI / 180);
  }
}

