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
          // Simulated Live Trip Map
          Container(
            color: const Color(0xFF0D1411),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigation, color: WasslniColors.emerald400, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'مسار الرحلة المباشر',
                    style: TextStyle(color: WasslniColors.textSecondary),
                  ),
                ],
              ),
            ),
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
                          title: const Text('🚨 إنذار الطوارئ SOS'),
                          content: const Text(
                            'هل تريد الاتصال بالشرطة (19) ومشاركة موقعك المباشر مع جهات اتصالك الموثوقة؟',
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
                          'رحلة محمية',
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

          // Bottom Trip Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasslniColors.darkSurface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: WasslniColors.gold500.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Driver Info Header
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: WasslniColors.emerald800.withOpacity(0.4),
                          shape: BoxShape.circle,
                          border: Border.all(color: WasslniColors.gold500),
                        ),
                        child: const Icon(Icons.person, color: WasslniColors.gold500, size: 30),
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
                                fontSize: 17,
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
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'نقداً كاش',
                            style: TextStyle(
                              color: WasslniColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: WasslniColors.darkSurfaceRaised,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '⏱️ وقت الوصول المقدر:',
                          style: TextStyle(color: WasslniColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          '3 دقائق (800 متر)',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Actions: Call, WhatsApp Share
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WasslniColors.darkSurfaceRaised,
                              foregroundColor: WasslniColors.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: WasslniColors.darkBorder),
                              ),
                            ),
                            icon: const Icon(Icons.call, size: 18),
                            label: const Text('اتصال مقنع'),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.share, size: 18),
                            label: const Text('مشاركة واتساب'),
                            onPressed: () {},
                          ),
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

