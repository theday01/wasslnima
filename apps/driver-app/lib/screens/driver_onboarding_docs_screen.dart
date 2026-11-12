import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'driver_home_screen.dart';

class DriverOnboardingDocsScreen extends StatefulWidget {
  const DriverOnboardingDocsScreen({Key? key}) : super(key: key);

  @override
  State<DriverOnboardingDocsScreen> createState() => _DriverOnboardingDocsScreenState();
}

class _DriverOnboardingDocsScreenState extends State<DriverOnboardingDocsScreen> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  // Documents status flags
  bool _cinUploaded = true;
  bool _licenseUploaded = true;
  bool _carteProUploaded = true;
  bool _carteGriseUploaded = true;
  bool _insuranceUploaded = false;
  bool _selfieUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: WasslniColors.darkSurface,
        elevation: 0,
        title: const Text(
          'ملف التحقق القانوني للسائق',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الخطوة 4 من 5: رفع الوثائق',
                    style: TextStyle(
                      color: WasslniColors.gold500,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '80% مكتمل',
                    style: TextStyle(
                      color: WasslniColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.8,
                  backgroundColor: WasslniColors.darkSurfaceRaised,
                  valueColor: const AlwaysStoppedAnimation<Color>(WasslniColors.gold500),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'الوثائق المطلوبة للتفعيل:',
                style: TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'جميع الوثائق مشفرة ومحمية وفق متطلبات CNDP وقانون 09-08',
                style: TextStyle(
                  color: WasslniColors.textTertiary,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),

              // Documents List
              Expanded(
                child: ListView(
                  children: [
                    _buildDocItem('بطاقة التعريف الوطنية (CIN)', _cinUploaded, () {}),
                    _buildDocItem('رخصة السياقة المغربية (Permis)', _licenseUploaded, () {}),
                    _buildDocItem('البطاقة المهنية (Carte Professionnelle)', _carteProUploaded, () {}),
                    _buildDocItem('البطاقة الرمادية للسيارة (Carte Grise)', _carteGriseUploaded, () {}),
                    _buildDocItem('شهادة التأمين والفحص التقني', _insuranceUploaded, () {
                      setState(() => _insuranceUploaded = true);
                    }),
                    _buildDocItem('صورة سيلفي مباشرة (Face Match)', _selfieUploaded, () {
                      setState(() => _selfieUploaded = true);
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              WasslniButton(
                text: 'إرسال الملف وتفعيل الحساب',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocItem(String title, bool isDone, VoidCallback onUpload) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: WasslniColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? WasslniColors.emerald500.withOpacity(0.4) : WasslniColors.darkBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.upload_file_rounded,
            color: isDone ? WasslniColors.success : WasslniColors.gold500,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: WasslniColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isDone)
            const Text(
              'مرفوعة ✅',
              style: TextStyle(
                color: WasslniColors.success,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            TextButton(
              onPressed: onUpload,
              child: const Text(
                'رفع الآن',
                style: TextStyle(
                  color: WasslniColors.gold500,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

