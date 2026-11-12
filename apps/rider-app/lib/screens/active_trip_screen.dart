import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

class ActiveTripScreen extends StatelessWidget {
  final String driverName;
  final String vehicleInfo;
  final int agreedPriceMad;

  const ActiveTripScreen({
    Key? key,
    required this.driverName,
    required this.vehicleInfo,
    required this.agreedPriceMad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      body: Stack(
        children: [
          // Live Navigation Vector Map
          const RealisticVectorMapView(
            isDriverHeatmap: false,
            centerTitle: 'الكابتن في طريقه إليك (2 دقيقة)',
          ),

          // Top Safety Bar with SOS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SosAlertButton(
                    onTrigger: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: WasslniColors.darkSurface,
                          title: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: WasslniColors.error),
                              SizedBox(width: 8),
                              Text('إنذار الطوارئ SOS', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          content: const Text(
                            'هل تريد الاتصال بالشرطة (19) ومشاركة موقعك المباشر مع جهات اتصالك الموثوقة؟',
                            style: TextStyle(color: WasslniColors.textSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('إلغاء'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WasslniColors.error,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('اتصال فوري (19)'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: WasslniColors.darkSurface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: WasslniColors.darkBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield, color: WasslniColors.emerald400, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'رحلة محمية بالـ GPS',
                          style: TextStyle(
                            color: WasslniColors.emerald400,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Active Driver Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasslniColors.darkSurface.withOpacity(0.96),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: WasslniColors.gold500.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: WasslniColors.emerald800.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: WasslniColors.gold500),
                        ),
                        child: const Icon(Icons.person, color: WasslniColors.gold500, size: 28),
                      ),
                      const SizedBox(width: 14),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$agreedPriceMad MAD',
                            style: const TextStyle(
                              color: WasslniColors.gold500,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'السعر المتفق عليه',
                            style: TextStyle(
                              color: WasslniColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: WasslniColors.darkBorder),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WasslniColors.emerald400,
                            side: const BorderSide(color: WasslniColors.emerald500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.call, size: 18),
                          label: const Text('اتصال بالسائق'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('جاري الاتصال المشفر بالكابتن...')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WasslniColors.gold500,
                            side: const BorderSide(color: WasslniColors.gold500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('مراسلة مباشرة'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('فتح شات المحادثة مع السائق...')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
