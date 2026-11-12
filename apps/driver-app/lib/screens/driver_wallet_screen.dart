import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

class DriverWalletScreen extends StatelessWidget {
  const DriverWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: WasslniColors.darkSurface,
        elevation: 0,
        title: const Text(
          'محفظة الكابتن والأرباح',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Master Wallet Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [WasslniColors.emerald700, WasslniColors.emerald900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: WasslniColors.gold500),
                  boxShadow: [
                    BoxShadow(
                      color: WasslniColors.emerald800.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'رصيد الأرباح القابل للسحب',
                      style: TextStyle(color: WasslniColors.gold200, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'MAD',
                          style: TextStyle(
                            color: WasslniColors.gold500,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'العمولة المستحقة: 0.00 MAD (مجاناً)',
                          style: TextStyle(color: WasslniColors.emerald400, fontSize: 12),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WasslniColors.gold500,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'طلب سحب (RIB)',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Free Commission Tracker Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: WasslniColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.verified, color: WasslniColors.gold500, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'حالة العرض الترويجي (0% عمولة)',
                          style: TextStyle(
                            color: WasslniColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'أنت تستفيد من 0% عمولة لمدة شهرين تبدأ من تاريخ أول رحلة مكتملة. جميع أرباحك لك بنسبة 100%!',
                      style: TextStyle(color: WasslniColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.8, // 48 days remaining out of 60
                        backgroundColor: WasslniColors.darkSurfaceRaised,
                        valueColor: AlwaysStoppedAnimation<Color>(WasslniColors.gold500),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('باقي 48 يوماً', style: TextStyle(color: WasslniColors.gold500, fontSize: 12, fontWeight: FontWeight.w700)),
                        Text('الإجمالي 60 يوماً', style: TextStyle(color: WasslniColors.textTertiary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'سجل المعاملات الأخيرة:',
                style: TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              _buildTxItem('رحلة: المعاريف ↔ موروكو مول', '+ 35.00 MAD', 'اليوم 14:20', true),
              _buildTxItem('رحلة: سيدي معروف ↔ كازا بورت', '+ 42.00 MAD', 'اليوم 11:45', true),
              _buildTxItem('سحب بنكي إلى الحساب البنكي', '- 500.00 MAD', 'أمس 18:00', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTxItem(String title, String amount, String date, bool isPositive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: WasslniColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WasslniColors.darkBorderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(date, style: const TextStyle(color: WasslniColors.textTertiary, fontSize: 11)),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              color: isPositive ? WasslniColors.success : WasslniColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

