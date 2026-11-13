import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'driver_home_screen.dart';

class DriverOnboardingDocsScreen extends StatefulWidget {
  const DriverOnboardingDocsScreen({Key? key}) : super(key: key);

  @override
  State<DriverOnboardingDocsScreen> createState() => _DriverOnboardingDocsScreenState();
}

class _DriverOnboardingDocsScreenState extends State<DriverOnboardingDocsScreen> {
  // Documents status flags - starts completely fresh for new driver
  bool _cinUploaded = false;
  bool _licenseUploaded = false;
  bool _carteProUploaded = false;
  bool _carteGriseUploaded = false;
  bool _insuranceUploaded = false;
  bool _selfieUploaded = false;

  int get _uploadedCount {
    int count = 0;
    if (_cinUploaded) count++;
    if (_licenseUploaded) count++;
    if (_carteProUploaded) count++;
    if (_carteGriseUploaded) count++;
    if (_insuranceUploaded) count++;
    if (_selfieUploaded) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _uploadedCount / 6.0;

    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WasslniColors.lightTextPrimary,
        elevation: 0.5,
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
                  Text(
                    'الوثائق المرفوعة: $_uploadedCount من 6',
                    style: const TextStyle(
                      color: WasslniColors.emerald800,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}% مكتمل',
                    style: const TextStyle(
                      color: WasslniColors.lightTextSecondary,
                      fontWeight: FontWeight.w600,
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
                  value: progress > 0 ? progress : 0.05,
                  backgroundColor: WasslniColors.lightSurfaceRaised,
                  valueColor: const AlwaysStoppedAnimation<Color>(WasslniColors.emerald800),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'الوثائق المطلوبة للتفعيل:',
                style: TextStyle(
                  color: WasslniColors.lightTextPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'جميع الوثائق مشفرة ومحمية وفق متطلبات CNDP وقانون 09-08',
                style: TextStyle(
                  color: WasslniColors.lightTextTertiary,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 16),

              // Documents List
              Expanded(
                child: ListView(
                  children: [
                    _buildDocItem('بطاقة التعريف الوطنية (CIN)', _cinUploaded, () {
                      setState(() => _cinUploaded = !_cinUploaded);
                    }),
                    _buildDocItem('رخصة السياقة المغربية (Permis)', _licenseUploaded, () {
                      setState(() => _licenseUploaded = !_licenseUploaded);
                    }),
                    _buildDocItem('البطاقة المهنية (Carte Professionnelle)', _carteProUploaded, () {
                      setState(() => _carteProUploaded = !_carteProUploaded);
                    }),
                    _buildDocItem('البطاقة الرمادية للسيارة (Carte Grise)', _carteGriseUploaded, () {
                      setState(() => _carteGriseUploaded = !_carteGriseUploaded);
                    }),
                    _buildDocItem('شهادة التأمين والفحص التقني', _insuranceUploaded, () {
                      setState(() => _insuranceUploaded = !_insuranceUploaded);
                    }),
                    _buildDocItem('صورة سيلفي مباشرة (Face Match)', _selfieUploaded, () {
                      setState(() => _selfieUploaded = !_selfieUploaded);
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? WasslniColors.success : WasslniColors.lightBorder,
          width: isDone ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.upload_file_rounded,
            color: isDone ? WasslniColors.success : WasslniColors.emerald800,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: WasslniColors.lightTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isDone)
            const Text(
              'مرفوعة بنجاح',
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
                'رفع الوثيقة',
                style: TextStyle(
                  color: WasslniColors.gold900,
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
