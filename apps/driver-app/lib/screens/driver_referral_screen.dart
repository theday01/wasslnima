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
              // Hero Banner
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
                        Text('🎁', style: TextStyle(fontSize: 24)),
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
                    const SizedBox(height: 14),

                    // WhatsApp Share
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text(
                          'مشاركة الرابط فوراً عبر واتساب',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: [
                  _buildMetricCard('السائقون المسجلون', '4', WasslniColors.textPrimary),
                  const SizedBox(width: 10),
                  _buildMetricCard('الأشهر المكتسبة', '2 من 6', WasslniColors.gold500),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'حالة السائقين المدعوين:',
                style: TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              _buildInviteeItem('عمر ك. (داسيا لوغان)', 'أكمل 5/5 رحلات ✅', 'مكتسب: شهر مجاني', true),
              _buildInviteeItem('مصطفى ر. (رونو كليو)', 'أكمل 4/5 رحلات (باقي رحلة ⏳)', 'قيد الإنجاز', false),
              _buildInviteeItem('طارق م. (فيات تيبو)', 'أكمل 1/5 رحلات (باقي 4 رحلات)', 'قيد الإنجاز', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WasslniColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WasslniColors.darkBorder),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: WasslniColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteeItem(String name, String progress, String reward, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: WasslniColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? WasslniColors.emerald500.withOpacity(0.4) : WasslniColors.darkBorderSubtle,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(progress, style: TextStyle(color: isDone ? WasslniColors.success : WasslniColors.warning, fontSize: 11)),
            ],
          ),
          Text(
            reward,
            style: TextStyle(
              color: isDone ? WasslniColors.gold500 : WasslniColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

