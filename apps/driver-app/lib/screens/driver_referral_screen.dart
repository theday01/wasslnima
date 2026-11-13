import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

class DriverReferralScreen extends StatelessWidget {
  const DriverReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String referralCode = 'CAPTAIN-MAROC';

    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WasslniColors.lightTextPrimary,
        elevation: 0.5,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.card_giftcard_rounded, color: WasslniColors.emerald800, size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ادعُ زملاءك السائقين واربح أشهراً مجانية!',
                            style: TextStyle(
                              color: WasslniColors.emerald800,
                              fontSize: 16,
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
                        color: WasslniColors.lightTextSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Code Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: WasslniColors.emerald50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: WasslniColors.emerald800.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            referralCode,
                            style: TextStyle(
                              color: WasslniColors.emerald800,
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
                                Icon(Icons.copy_rounded, color: WasslniColors.emerald800, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'نسخ',
                                  style: TextStyle(
                                    color: WasslniColors.emerald800,
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
                  _buildStatCard('السائقون المسجلون', '0', Icons.people_outline_rounded),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: WasslniColors.emerald800, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: WasslniColors.emerald800,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: WasslniColors.lightTextSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
