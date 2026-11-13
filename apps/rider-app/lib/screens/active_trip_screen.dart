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
      backgroundColor: WasslniColors.lightCanvas,
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
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: WasslniColors.error),
                              SizedBox(width: 8),
                              Text('إنذار الطوارئ SOS', style: TextStyle(color: WasslniColors.lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          content: const Text(
                            'هل تريد الاتصال بالشرطة (19) ومشاركة موقعك المباشر مع جهات اتصالك الموثوقة؟',
                            style: TextStyle(color: WasslniColors.lightTextSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('إلغاء', style: TextStyle(color: WasslniColors.lightTextSecondary)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WasslniColors.error,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: WasslniColors.lightBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_rounded, color: WasslniColors.emerald800, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'رحلة محمية بالـ GPS',
                          style: TextStyle(
                            color: WasslniColors.emerald800,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: WasslniColors.emerald50,
                          shape: BoxShape.circle,
                          border: Border.all(color: WasslniColors.emerald800.withOpacity(0.4)),
                        ),
                        child: const Icon(Icons.person, color: WasslniColors.emerald800, size: 30),
                      ),
                      const SizedBox(width: 14),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$agreedPriceMad MAD',
                            style: const TextStyle(
                              color: WasslniColors.emerald800,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'السعر المتفق عليه',
                            style: TextStyle(
                              color: WasslniColors.lightTextTertiary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: WasslniColors.lightBorder),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WasslniColors.emerald800,
                            side: const BorderSide(color: WasslniColors.emerald800, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.call_rounded, size: 18),
                          label: const Text('اتصال بالسائق', style: TextStyle(fontWeight: FontWeight.w700)),
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
                            foregroundColor: WasslniColors.gold900,
                            side: const BorderSide(color: WasslniColors.gold500, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                          label: const Text('مراسلة مباشرة', style: TextStyle(fontWeight: FontWeight.w700)),
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
