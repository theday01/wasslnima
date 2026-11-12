import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

class DriverReferralScreen extends StatelessWidget {
  const DriverReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String referralCode = 'YASSINE-WSL7';

    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: WasslniColors.darkSurface,
        elevation: 0,
        title: const Text(
          'برنامج أبطال وصّلني (دعوة السائقين)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner with Professional Vector Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WasslniColors.gold500.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.card_giftcard, color: WasslniColors.gold500, size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ادعُ زملاءك السائقين واربح أشهراً مجانية!',
                            style: TextStyle(
                              color: WasslniColors.gold500,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'عند تسجيل أي سائق بكودك وإكماله 5 رحلات فعلية:\n• أنت تحصل على شهر إضافي بدون عمولة (0% عمولة).\n• السائق المدعو يحصل على أسبوع إضافي مجاني.\n(الحد الأقصى المتراكم: 6 أشهر مجانية)',
                      style: TextStyle(
                        color: WasslniColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Code Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: WasslniColors.darkSurfaceRaised,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: WasslniColors.gold500),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            referralCode,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم نسخ كود الدعوة بنجاح!')),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.copy, color: WasslniColors.gold500, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'نسخ',
                                  style: TextStyle(
                                    color: WasslniColors.gold500,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: [
                  _buildStatCard('السائقون المسجلون', '0', Icons.people_outline),
                  const SizedBox(width: 10),
                  _buildStatCard('الأشهر المكتسبة', '0 أشهر', Icons.calendar_today_outlined),
                ],
              ),

              const SizedBox(height: 24),

              WasslniButton(
                text: 'مشاركة الكود عبر الواتساب',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('مشاركة رابط الدعوة مع الكباتن...')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WasslniColors.darkSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: WasslniColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: WasslniColors.emerald400, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: WasslniColors.gold500,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: WasslniColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
