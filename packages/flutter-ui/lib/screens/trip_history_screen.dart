import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        title: const Text('سجل الرحلات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: WasslniColors.emerald800.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history, color: WasslniColors.emerald800, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا توجد رحلات سابقة بعد',
                style: TextStyle(
                  color: WasslniColors.lightTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'عندما تطلب أول رحلة لك وتكتمل بنجاح، ستظهر هنا جميع التفاصيل والفاتورة ومسار الرحلة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WasslniColors.lightTextSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
