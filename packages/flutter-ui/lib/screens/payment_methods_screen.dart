import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final bool isDriver;

  const PaymentMethodsScreen({Key? key, this.isDriver = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        title: Text(
          isDriver ? 'المحفظة والحساب البنكي' : 'طرق الدفع والمحفظة',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Cash Default Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WasslniColors.emerald800, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: WasslniColors.emerald800.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.payments_outlined, color: WasslniColors.emerald800, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الدفع نقداً (كاش)',
                          style: TextStyle(
                            color: WasslniColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'الدفع المباشر للسائق عند الوصول (الخيار الافتراضي)',
                          style: TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: WasslniColors.emerald800, size: 22),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bank Card (CMI / Visa / MasterCard)
            _buildPaymentOption(
              icon: Icons.credit_card,
              title: 'البطاقة البنكية (CMI / Visa / Mastercard)',
              subtitle: 'دفع رقمي محلي آمن ومشفر',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('بوابة CMI المغربية جاهزة للتفعيل مع حسابك البنكي')),
                );
              },
            ),
            const SizedBox(height: 12),

            // Wafacash / CashPlus
            _buildPaymentOption(
              icon: Icons.storefront,
              title: 'وفاكاش أو كاش بلوس (Wafacash / CashPlus)',
              subtitle: 'تعبئة المحفظة نقداً من أقرب وكالة',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('خدمة شحن المحفظة عبر وكالات كاش بلوس ووفاكاش')),
                );
              },
            ),

            if (isDriver) ...[
              const SizedBox(height: 20),
              const Text(
                'الحساب البنكي لتحويل الأرباح (RIB):',
                style: TextStyle(
                  color: WasslniColors.lightTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WasslniColors.lightBorder),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('رقم الحساب البنكي (24 رقماً)', style: TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('011 780 0000 1234567890 44', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 1)),
                    SizedBox(height: 6),
                    Text('البنك: التجاري وفا بنك (Attijariwafa Bank)', style: TextStyle(color: WasslniColors.emerald800, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WasslniColors.lightBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: WasslniColors.lightSurfaceRaised,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: WasslniColors.lightTextPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: WasslniColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: WasslniColors.lightTextTertiary, size: 14),
          ],
        ),
      ),
    );
  }
}
