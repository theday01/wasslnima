import { PricingService } from './pricing.service';

describe('PricingService - Moroccan inDrive Negotiation Logic', () => {
  let pricingService: PricingService;

  beforeEach(() => {
    pricingService = new PricingService();
  });

  it('should accurately calculate Haversine spherical distance between Casablanca points', () => {
    // Twin Center Casa (33.5898, -7.6038) to Morocco Mall (33.5731, -7.5898)
    const distance = pricingService.calculateHaversineDistance(
      33.5898,
      -7.6038,
      33.5731,
      -7.5898,
    );

    expect(distance).toBeGreaterThan(2);
    expect(distance).toBeLessThan(5);
  });

  it('should enforce minimum fare in Moroccan Dirhams', () => {
    const estimate = pricingService.calculateTripEstimate({
      distanceKm: 0.5,
      durationMinutes: 2,
      baseFareMad: 7.0,
      perKmRateMad: 3.5,
      perMinuteRateMad: 0.5,
      minimumFareMad: 12.0,
    });

    expect(estimate.referencePriceMad).toBeGreaterThanOrEqual(12.0);
    expect(estimate.minSuggestedPriceMad).toBeGreaterThanOrEqual(12.0);
  });

  it('should calculate realistic negotiation bounds (-30% min, +100% max)', () => {
    const estimate = pricingService.calculateTripEstimate({
      distanceKm: 8.0,
      durationMinutes: 18,
      baseFareMad: 7.0,
      perKmRateMad: 3.5,
      perMinuteRateMad: 0.5,
      minimumFareMad: 12.0,
    });

    // Baseline: 7 + (8*3.5) + (18*0.5) = 7 + 28 + 9 = 44 MAD
    expect(estimate.referencePriceMad).toBeCloseTo(44, 0);
    expect(estimate.minSuggestedPriceMad).toBeLessThan(estimate.referencePriceMad);
    expect(estimate.maxSuggestedPriceMad).toBeGreaterThan(estimate.referencePriceMad);
    expect(estimate.minSuggestedPriceMad).toBeCloseTo(44 * 0.7, 0);
  });

  it('should apply +20% night surge correctly', () => {
    const dayEstimate = pricingService.calculateTripEstimate({
      distanceKm: 10,
      durationMinutes: 20,
      baseFareMad: 7.0,
      perKmRateMad: 3.5,
      perMinuteRateMad: 0.5,
      minimumFareMad: 12.0,
      isNight: false,
    });

    const nightEstimate = pricingService.calculateTripEstimate({
      distanceKm: 10,
      durationMinutes: 20,
      baseFareMad: 7.0,
      perKmRateMad: 3.5,
      perMinuteRateMad: 0.5,
      minimumFareMad: 12.0,
      isNight: true,
    });

    expect(nightEstimate.referencePriceMad).toBeGreaterThan(
      dayEstimate.referencePriceMad,
    );
    expect(nightEstimate.isNightFareApplied).toBe(true);
  });
});

