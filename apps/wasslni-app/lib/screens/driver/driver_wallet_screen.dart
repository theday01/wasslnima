import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

class DriverWalletScreen extends StatelessWidget {
  const DriverWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WasslniColors.lightTextPrimary,
        elevation: 0.5,
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
                  border: Border.all(color: WasslniColors.gold500.withOpacity(0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: WasslniColors.emerald800.withOpacity(0.25),
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
                      style: TextStyle(color: WasslniColors.gold200, fontSize: 13, fontWeight: FontWeight.w500),
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
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'MAD',
                          style: TextStyle(
                            color: WasslniColors.gold500,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
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
                          style: TextStyle(color: WasslniColors.emerald400, fontSize: 12, fontWeight: FontWeight.w600),
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('الحد الأدنى لطلب التحويل البنكي (RIB) هو 50 MAD')),
                            );
                          },
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
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.verified_rounded, color: WasslniColors.emerald800, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'حالة العرض الترويجي (0% عمولة)',
                          style: TextStyle(
                            color: WasslniColors.lightTextPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'أنت تستفيد من 0% عمولة لمدة شهرين تبدأ من تاريخ أول رحلة مكتملة. جميع أرباحك لك بنسبة 100%!',
                      style: TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 1.0, // Full 60 days
                        backgroundColor: WasslniColors.lightSurfaceRaised,
                        valueColor: AlwaysStoppedAnimation<Color>(WasslniColors.emerald800),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('60 يوماً متبقية', style: TextStyle(color: WasslniColors.emerald800, fontSize: 12, fontWeight: FontWeight.w700)),
                        Text('العرض ساري', style: TextStyle(color: WasslniColors.lightTextTertiary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'سجل المعاملات الأخيرة:',
                style: TextStyle(
                  color: WasslniColors.lightTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              // Clean Empty State for Real User
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 54,
                      color: WasslniColors.lightTextTertiary.withOpacity(0.4),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'لا توجد معاملات سابقة بعد',
                      style: TextStyle(
                        color: WasslniColors.lightTextPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'ستبدأ أرباح رحلاتك والتحويلات المالية بالظهور هنا فور إتمام أول رحلة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: WasslniColors.lightTextTertiary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
