import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        title: const Text('مركز المساعدة والدعم 24/7', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Instant WhatsApp Support Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF25D366).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'محادثة مباشرة عبر واتساب',
                          style: TextStyle(
                            color: WasslniColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'فريق الدعم المغربي متاح 24 ساعة للرد في أقل من دقيقة',
                          style: TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency SOS Call
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WasslniColors.lightBorder),
              ),
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: WasslniColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_in_talk, color: WasslniColors.error, size: 22),
                ),
                title: const Text('طوارئ النجدة والشرطة (19)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: const Text('اتصال مباشر ومجاني مع الأمن الوطني في الحالات الطارئة', style: TextStyle(fontSize: 12)),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('طلب اتصال الطوارئ 19...')),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // FAQ Items
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'الأسئلة الشائعة:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: WasslniColors.lightTextPrimary),
              ),
            ),
            _buildFaqItem('كيف أقترح سعراً مناسباً للرحلة؟', 'يقترح عليك التطبيق سعراً مرجعياً، ولديك كامل الحرية لزيادته أو إنقاصه بحسب المسافة وساعة الذروة.'),
            _buildFaqItem('هل يوجد اقتطاع عمولة في أول شهرين؟', 'لا، وصّلني تقدم 0% عمولة للسائقين خلال أول 60 يوماً من الانطلاق تشجيعاً للمجتمع.'),
            _buildFaqItem('كيف أبلغ عن شيء نسيته في السيارة؟', 'من خلال الضغط على زر الدعم أو تحديد الرحلة من سجل الرحلات والتواصل مباشرة مع السائق أو فريقنا.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WasslniColors.lightBorder),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: WasslniColors.lightTextPrimary)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(answer, style: const TextStyle(fontSize: 12, color: WasslniColors.lightTextSecondary, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
