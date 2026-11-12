import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

class DriverIncomingRequestModal extends StatelessWidget {
  const DriverIncomingRequestModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: WasslniColors.darkSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: WasslniColors.gold500, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: WasslniColors.emerald800.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WasslniColors.emerald400),
                ),
                child: const Text(
                  'طلب جديد مباشر',
                  style: TextStyle(
                    color: WasslniColors.emerald400,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.timer_outlined, color: WasslniColors.error, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '22 ثانية متبقية',
                    style: TextStyle(
                      color: WasslniColors.error,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Route Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WasslniColors.darkSurfaceRaised,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: Color(0xFF10B981), size: 12),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'عين السبع (حدا مرجان) • 1.1 كم منك (4 دقائق)',
                        style: TextStyle(
                          color: WasslniColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: WasslniColors.darkBorder, height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFFEF4444), size: 14),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'سيدي بليوط (شارع الجيش الملكي)',
                        style: TextStyle(
                          color: WasslniColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Price Tag
          Center(
            child: Column(
              children: [
                const Text(
                  'السعر المقترح من الراكب:',
                  style: TextStyle(color: WasslniColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '35 ',
                        style: TextStyle(
                          color: WasslniColors.gold500,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                      TextSpan(
                        text: 'MAD',
                        style: TextStyle(
                          color: WasslniColors.gold500,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Actions: Accept exact or Negotiate with counter offers
          WasslniButton(
            text: 'قبول بـ 35 MAD فوراً ✅',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم قبول الرحلة بنجاح! توجه للراكب')),
              );
            },
          ),
          const SizedBox(height: 10),

          // Counter Offers Row
          Row(
            children: [
              _buildCounterBtn(context, 'عرض 38 MAD'),
              const SizedBox(width: 8),
              _buildCounterBtn(context, 'عرض 40 MAD'),
              const SizedBox(width: 8),
              _buildCounterBtn(context, 'عرض 45 MAD'),
            ],
          ),
          const SizedBox(height: 10),

          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'تجاهل الطلب',
                style: TextStyle(color: WasslniColors.textTertiary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterBtn(BuildContext context, String text) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: WasslniColors.textPrimary,
          side: const BorderSide(color: WasslniColors.darkBorder),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إرسال $text للراكب')),
          );
        },
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

