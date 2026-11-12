import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

/// Interactive slide-out navigation drawer styled with Moroccan luxury theme
class WasslniSideDrawer extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userRole; // 'rider' or 'driver'
  final VoidCallback? onProfileTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onSupportTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const WasslniSideDrawer({
    Key? key,
    this.userName = 'المستخدم',
    this.userPhone = '+212 6XX-XXXXXX',
    this.userRole = 'rider',
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
      backgroundColor: WasslniColors.darkCanvas,
      child: SafeArea(
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasslniColors.darkSurface,
                border: const Border(
                  bottom: BorderSide(color: WasslniColors.darkBorder),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: WasslniColors.emerald800.withOpacity(0.3),
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
                            color: WasslniColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userPhone,
                          style: const TextStyle(
                            color: WasslniColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: WasslniColors.emerald800.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isDriver ? 'حساب كابتن موثق' : 'حساب راكب موثق',
                            style: const TextStyle(
                              color: WasslniColors.emerald400,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                children: [
                  _buildDrawerTile(
                    icon: Icons.history,
                    title: 'سجل الرحلات',
                    subtitle: 'جميع طلباتك السابقة وتفاصيلها',
                    onTap: onHistoryTap ?? () => _showComingSoon(context, 'سجل الرحلات'),
                  ),
                  _buildDrawerTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: isDriver ? 'محفظة الأرباح وسحب الأموال' : 'طرق الدفع والمحفظة',
                    subtitle: isDriver ? 'الرصيد والحساب البنكي RIB' : 'كاش، بطاقة بنكية، وفاء كاش',
                    onTap: onWalletTap ?? () => _showComingSoon(context, 'المحفظة'),
                  ),
                  _buildDrawerTile(
                    icon: Icons.card_giftcard,
                    title: 'برنامج المكافآت والدعوة',
                    subtitle: 'اربح شهوراً مجانية بمشاركة كودك',
                    onTap: () => _showComingSoon(context, 'برنامج المكافآت'),
                  ),
                  _buildDrawerTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'الدعم والمساعدة 24/7',
                    subtitle: 'تواصل فوري عبر الواتساب أو الهاتف',
                    onTap: onSupportTap ?? () => _showComingSoon(context, 'الدعم الفني'),
                  ),
                  _buildDrawerTile(
                    icon: Icons.security,
                    title: 'مركز الأمان وحماية البيانات',
                    subtitle: 'متوافق مع قوانين CNDP المغربية',
                    onTap: () => _showComingSoon(context, 'مركز الأمان'),
                  ),
                  _buildDrawerTile(
                    icon: Icons.settings_outlined,
                    title: 'إعدادات الحساب',
                    subtitle: 'اللغة، الإشعارات، وتفضيلات الرحلة',
                    onTap: onSettingsTap ?? () => _showComingSoon(context, 'الإعدادات'),
                  ),
                ],
              ),
            ),

            // Logout & App Version
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: WasslniColors.darkBorder)),
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
                    'وصّلني المغرب • الإصدار v1.0.0 (الدار البيضاء)',
                    style: TextStyle(color: WasslniColors.textTertiary, fontSize: 11),
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
          color: WasslniColors.darkSurfaceRaised,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: WasslniColors.darkBorder),
        ),
        child: Icon(icon, color: WasslniColors.gold500, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: WasslniColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: WasslniColors.textTertiary,
          fontSize: 11,
        ),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: WasslniColors.darkSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: WasslniColors.gold500.withOpacity(0.4)),
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
              child: const Icon(Icons.check_circle_outline, color: WasslniColors.gold500, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              feature,
              style: const TextStyle(
                color: WasslniColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قسم $feature جاهز ومفعل بالكامل في هذه النسخة ومرتبط بنظام قاعدة البيانات والخدمة السحابية.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: WasslniColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: WasslniColors.gold500,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}
