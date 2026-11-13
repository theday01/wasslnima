import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class SafetyCenterScreen extends StatelessWidget {
  const SafetyCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        title: const Text('مركز الأمان وحماية الخصوصية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // CNDP Compliance Badge
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: WasslniColors.emerald800.withOpacity(0.06),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: WasslniColors.emerald800.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: WasslniColors.emerald800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.verified_user, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معتمد ومطابق لقانون CNDP رقم 09-08',
                          style: TextStyle(
                            color: WasslniColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'بياناتك الشخصية وأرقام هواتفك مشفرة ومحمية ولا يتم كشفها لأي طرف خارجي.',
                          style: TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSafetyPillar(
              icon: Icons.share_location,
              title: 'مشاركة المسار المباشر (Live Track)',
              subtitle: 'يمكنك إرسال رابط تتبع رحلتك عبر الواتساب لأفراد عائلتك ليروا مسارك دقيقة بدقيقة.',
            ),
            const SizedBox(height: 12),

            _buildSafetyPillar(
              icon: Icons.shield,
              title: 'التحقق الصارم من هوية السائقين',
              subtitle: 'فحص البطاقة الوطنية، رخصة السياقة، التأمين، وسجل السوابق القضائية قبل تفعيل أي سائق.',
            ),
            const SizedBox(height: 12),

            _buildSafetyPillar(
              icon: Icons.emergency,
              title: 'زر الاستغاثة السريع (SOS)',
              subtitle: 'متاح طيلة الرحلة بنقرة واحدة للربط المباشر مع المصالح الأمنية في المملكة.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyPillar({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WasslniColors.lightBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: WasslniColors.lightSurfaceRaised,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: WasslniColors.emerald800, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: WasslniColors.lightTextPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
