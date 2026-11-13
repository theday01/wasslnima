import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'rider/home_map_screen.dart';
import 'driver/driver_home_screen.dart';
import 'driver/driver_onboarding_docs_screen.dart';

enum UserRole { rider, driver }

class RoleSelectionScreen extends StatefulWidget {
  final String? initialPhone;
  const RoleSelectionScreen({Key? key, this.initialPhone}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.rider;

  void _proceedToSelectedRole() {
    if (_selectedRole == UserRole.rider) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeMapScreen()),
      );
    } else {
      // Driver flow
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Header brand
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: WasslniColors.emerald800,
                    shape: BoxShape.circle,
                    border: Border.all(color: WasslniColors.gold500, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: WasslniColors.emerald800.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    color: WasslniColors.gold500,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'مرحباً بك في وصّلني 🇲🇦',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WasslniColors.emerald800,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'اختر كيف تفضل استخدام التطبيق اليوم:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WasslniColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              // Option 1: Rider
              _buildRoleCard(
                role: UserRole.rider,
                title: 'أنا راكب (محتاج توصيلة)',
                subtitle: 'اقترح سعرك بنفسك، اختر السائق المناسب، وتنقل بحرية وأمان في جميع مدن المغرب.',
                icon: Icons.person_pin_circle_rounded,
                badge: 'السعر باختيارك ⚡',
              ),

              const SizedBox(height: 16),

              // Option 2: Driver
              _buildRoleCard(
                role: UserRole.driver,
                title: 'أنا سائق (كابتن وصّلني)',
                subtitle: 'حرية كاملة في قبول الرحلات، 0% عمولة لأول شهرين، ودخل يومي مضمون.',
                icon: Icons.local_taxi_rounded,
                badge: '0% عمولة ترويجية 🎁',
              ),

              const Spacer(),

              // Confirmation button
              ElevatedButton(
                onPressed: _proceedToSelectedRole,
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasslniColors.emerald800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _selectedRole == UserRole.rider ? 'المتابعة كراكب ➔' : 'المتابعة ككابتن سائق ➔',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'يمكنك التبديل بين الراكب والسائق في أي وقت من القائمة الجانبية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: WasslniColors.textSecondary.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
  }) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () {
        setState(() => _selectedRole = role);
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : WasslniColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? WasslniColors.emerald800 : WasslniColors.lightBorder,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: WasslniColors.emerald800.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? WasslniColors.emerald800 : WasslniColors.emerald800.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? WasslniColors.gold500 : WasslniColors.emerald800,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? WasslniColors.emerald800 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: WasslniColors.gold200.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: WasslniColors.gold900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: WasslniColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? WasslniColors.emerald800 : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? WasslniColors.emerald800 : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
