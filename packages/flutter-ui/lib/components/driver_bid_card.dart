import 'package:flutter/material.dart';
import '../wasslni_theme.dart';
import 'wasslni_button.dart';

class DriverBidCard extends StatelessWidget {
  final String driverName;
  final String vehicleInfo;
  final double rating;
  final int totalTrips;
  final int offeredPriceMad;
  final int arrivalMinutes;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const DriverBidCard({
    Key? key,
    required this.driverName,
    required this.vehicleInfo,
    required this.rating,
    required this.totalTrips,
    required this.offeredPriceMad,
    required this.arrivalMinutes,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Driver Profile Row
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: WasslniColors.emerald50,
                  shape: BoxShape.circle,
                  border: Border.all(color: WasslniColors.emerald800.withOpacity(0.4)),
                ),
                child: const Icon(Icons.person, color: WasslniColors.emerald800, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(
                        color: WasslniColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicleInfo,
                      style: const TextStyle(
                        color: WasslniColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Offered Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$offeredPriceMad MAD',
                    style: const TextStyle(
                      color: WasslniColors.emerald800,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 12, color: WasslniColors.emerald700),
                      const SizedBox(width: 3),
                      Text(
                        'يصل في $arrivalMinutes دقائق',
                        style: const TextStyle(
                          color: WasslniColors.emerald700,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rating and stats badge row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WasslniColors.gold200.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: WasslniColors.gold900, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        color: WasslniColors.gold900,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($totalTrips رحلة ناجحة)',
                style: const TextStyle(
                  color: WasslniColors.lightTextTertiary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: WasslniColors.emerald50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: WasslniColors.emerald800, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'سائق معتمد',
                      style: TextStyle(
                        color: WasslniColors.emerald800,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons: Accept / Reject
          Row(
            children: [
              Expanded(
                flex: 3,
                child: WasslniButton(
                  text: 'قبول العرض ($offeredPriceMad MAD)',
                  onPressed: onAccept,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: WasslniColors.lightTextSecondary,
                    side: const BorderSide(color: WasslniColors.lightBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onReject,
                  child: const Text(
                    'رفض',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
