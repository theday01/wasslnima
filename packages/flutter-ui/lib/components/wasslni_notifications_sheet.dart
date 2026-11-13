import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

/// Interactive modal sheet displaying in-app notifications in Day Mode
class WasslniNotificationsSheet extends StatelessWidget {
  final bool isDriver;

  const WasslniNotificationsSheet({
    Key? key,
    this.isDriver = false,
  }) : super(key: key);

  static void show(BuildContext context, {bool isDriver = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WasslniNotificationsSheet(isDriver: isDriver),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = isDriver
        ? [
            {
              'title': 'عرض ترويجي: 0% عمولة مفعلة',
              'body': 'أنت الآن تستفيد من 60 يوماً بدون أي اقتطاعات عمولة في جميع رحلاتك.',
              'time': 'منذ 5 دقائق',
              'icon': Icons.local_offer,
              'color': WasslniColors.emerald800,
            },
            {
              'title': 'طلب مرتفع في المعاريف وسيدي معروف',
              'body': 'ساعات الذروة الحالية: زيادة ملحوظة في طلبات الركاب الراغبين في التفاوض.',
              'time': 'منذ 20 دقيقة',
              'icon': Icons.trending_up,
              'color': WasslniColors.warning,
            },
            {
              'title': 'إشعار أمان للسائقين',
              'body': 'تأكد دائماً من مطابقة اسم الراكب ورقم الرحلة قبل بدء الانطلاق.',
              'time': 'منذ ساعتين',
              'icon': Icons.security,
              'color': WasslniColors.emerald500,
            },
          ]
        : [
            {
              'title': 'مرحباً بك في وصّلني!',
              'body': 'يمكنك الآن اقتراح سعرك الخاص بكل حرية والتفاوض مباشرة مع السائقين القريبين.',
              'time': 'منذ 10 دقائق',
              'icon': Icons.celebration,
              'color': WasslniColors.emerald800,
            },
            {
              'title': 'سائقون متوفرون حولك',
              'body': 'يوجد أكثر من 15 كابتن نشط في منطقتك بالدار البيضاء حالياً.',
              'time': 'منذ 35 دقيقة',
              'icon': Icons.directions_car,
              'color': WasslniColors.emerald500,
            },
            {
              'title': 'نصيحة أمان',
              'body': 'زر SOS متاح في كل رحلة لمشاركة موقعك المباشر فوراً مع الطوارئ (19).',
              'time': 'منذ 3 ساعات',
              'icon': Icons.shield,
              'color': WasslniColors.warning,
            },
          ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: WasslniColors.emerald800.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_active, color: WasslniColors.emerald800, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'مركز الإشعارات والتنبيهات',
                    style: TextStyle(
                      color: WasslniColors.lightTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: WasslniColors.lightTextSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: WasslniColors.lightBorder),
          const SizedBox(height: 8),

          // Notifications List
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: WasslniColors.lightSurfaceRaised,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WasslniColors.lightBorderSubtle),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: const TextStyle(
                                      color: WasslniColors.lightTextPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  item['time'] as String,
                                  style: const TextStyle(
                                    color: WasslniColors.lightTextTertiary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item['body'] as String,
                              style: const TextStyle(
                                color: WasslniColors.lightTextSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
