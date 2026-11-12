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
        color: WasslniColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WasslniColors.darkBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: WasslniColors.emerald800.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: WasslniColors.gold500),
                ),
                child: const Icon(Icons.person, color: WasslniColors.gold500, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(
                        color: WasslniColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicleInfo,
                      style: const TextStyle(
                        color: WasslniColors.textSecondary,
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
                      color: WasslniColors.gold500,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'يصل في $arrivalMinutes دقائق',
                    style: const TextStyle(
                      color: WasslniColors.emerald400,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Actions
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: WasslniColors.textTertiary,
                      side: const BorderSide(color: WasslniColors.darkBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onReject,
                    child: const Text('تخطي'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: WasslniButton(
                  text: 'قبول بـ $offeredPriceMad MAD',
                  onPressed: onAccept,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

