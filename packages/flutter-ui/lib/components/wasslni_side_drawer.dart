import 'package:flutter/material.dart';
import '../wasslni_theme.dart';
import '../screens/trip_history_screen.dart';
import '../screens/payment_methods_screen.dart';
import '../screens/support_center_screen.dart';
import '../screens/safety_center_screen.dart';
import '../screens/settings_screen.dart';

/// Interactive slide-out navigation drawer styled with Day Mode Moroccan elegance
class WasslniSideDrawer extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userRole; // 'rider' or 'driver'
  final VoidCallback? onSwitchRole;
  final VoidCallback? onProfileTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onSupportTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const WasslniSideDrawer({
    Key? key,
    this.userName = 'المستخدم الكريم',
    this.userPhone = '+212 6XX-XXXXXX',
    this.userRole = 'rider',
    this.onSwitchRole,
    this.onProfileTap,
    this.onHistoryTap,
    this.onWalletTap,
    this.onSupportTap,
    this.onSettingsTap,
    this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDriver = userRole == 'driver';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // User Header Card (Day Mode Luxury)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasslniColors.emerald800,
                boxShadow: [
                  BoxShadow(
                    color: WasslniColors.emerald900.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: WasslniColors.gold500, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        isDriver ? Icons.drive_eta : Icons.person,
                        color: WasslniColors.gold500,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          userPhone,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: WasslniColors.gold500,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isDriver ? 'كابتن معتمد' : 'راكب موثق',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items with Dedicated Destination Pages
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                children: [
                  // Switch Role Option
                  if (onSwitchRole != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDriver
                              ? [WasslniColors.gold500.withOpacity(0.18), WasslniColors.emerald800.withOpacity(0.08)]
                              : [WasslniColors.emerald800.withOpacity(0.12), WasslniColors.gold500.withOpacity(0.12)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDriver ? WasslniColors.gold500 : WasslniColors.emerald800,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDriver ? WasslniColors.emerald800 : WasslniColors.gold500,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDriver ? Icons.person_pin_circle_rounded : Icons.local_taxi_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          isDriver ? 'التبديل إلى وضع الراكب' : 'التبديل إلى وضع السائق (الكابتن)',
                          style: TextStyle(
                            color: WasslniColors.emerald800,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          isDriver ? 'طلب توصيلة واقتراح الأسعار' : 'استقبال الطلبات وبدء العمل',
                          style: TextStyle(
                            fontSize: 11,
                            color: WasslniColors.textSecondary,
                          ),
                        ),
                        trailing: const Icon(Icons.swap_horiz_rounded, color: WasslniColors.emerald800),
                        onTap: () {
                          Navigator.pop(context);
                          onSwitchRole!();
                        },
                      ),
                    ),
                  _buildDrawerTile(
                    icon: Icons.history,
                    title: 'سجل الرحلات',
                    subtitle: 'جميع طلباتك السابقة وتفاصيلها والفواتير',
                    onTap: () {
                      Navigator.pop(context);
                      if (onHistoryTap != null) {
                        onHistoryTap!();
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const TripHistoryScreen()));
                      }
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: isDriver ? 'محفظة الأرباح وسحب الأموال' : 'طرق الدفع والمحفظة',
                    subtitle: isDriver ? 'الرصيد والحساب البنكي RIB' : 'كاش، بطاقة بنكية، وفاء كاش',
                    onTap: () {
                      Navigator.pop(context);
                      if (onWalletTap != null) {
                        onWalletTap!();
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentMethodsScreen(isDriver: isDriver)));
                      }
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.card_giftcard,
                    title: 'برنامج المكافآت والدعوة',
                    subtitle: 'اربح شهوراً مجانية بمشاركة كودك مع زملائك',
                    onTap: () {
                      Navigator.pop(context);
                      _showRewardDialog(context);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'الدعم والمساعدة 24/7',
                    subtitle: 'تواصل فوري عبر الواتساب أو الهاتف',
                    onTap: () {
                      Navigator.pop(context);
                      if (onSupportTap != null) {
                        onSupportTap!();
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportCenterScreen()));
                      }
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.security,
                    title: 'مركز الأمان وحماية البيانات',
                    subtitle: 'متوافق مع قوانين CNDP المغربية',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyCenterScreen()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.settings_outlined,
                    title: 'إعدادات الحساب',
                    subtitle: 'اللغة، الإشعارات، وتفضيلات الرحلة',
                    onTap: () {
                      Navigator.pop(context);
                      if (onSettingsTap != null) {
                        onSettingsTap!();
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      }
                    },
                  ),
                ],
              ),
            ),

            // Logout & App Version
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: WasslniColors.lightBorder)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: WasslniColors.error),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: WasslniColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    dense: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: onLogoutTap ?? () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'وصّلني المغرب • النسخة الرسمية v1.0.0',
                    style: TextStyle(color: WasslniColors.lightTextTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: WasslniColors.lightSurfaceRaised,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: WasslniColors.lightBorder),
        ),
        child: Icon(icon, color: WasslniColors.emerald800, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: WasslniColors.lightTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: WasslniColors.lightTextSecondary,
          fontSize: 11,
        ),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }

  void _showRewardDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: WasslniColors.gold500.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.card_giftcard, color: WasslniColors.gold500, size: 28),
            ),
            const SizedBox(height: 14),
            const Text(
              'برنامج مكافآت وصّلني',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: WasslniColors.lightTextPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'كودك الترويجي: WASSLNI-CASA\nشارك الكود مع أصدقائك أو زملائك السائقين لتربح شهراً مجانياً بدون عمولة!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: WasslniColors.lightTextSecondary, height: 1.5),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: WasslniColors.emerald800,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('مشاركة الكود الآن', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
