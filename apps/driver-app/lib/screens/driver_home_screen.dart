import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'driver_incoming_request_modal.dart';
import 'driver_wallet_screen.dart';
import 'driver_referral_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      body: Stack(
        children: [
          // Simulated Heatmap Background (Casa Demand Hotspots)
          Container(
            color: const Color(0xFF0D1411),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: WasslniColors.warning.withOpacity(0.5),
                    size: 72,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'الخريطة الحرارية لمناطق الطلب العالي',
                    style: TextStyle(
                      color: WasslniColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'المعاريف • سيدي معروف • مارينا الدار البيضاء',
                    style: TextStyle(
                      color: WasslniColors.gold500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Header & Free Commission Badge
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderBtn(Icons.menu, () {}),
                      // 0% Commission Badge Counter
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const DriverWalletScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: WasslniColors.darkSurface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: WasslniColors.gold500),
                            boxShadow: [
                              BoxShadow(
                                color: WasslniColors.gold500.withOpacity(0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text('🎉', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 6),
                              Text(
                                'باقي 48 يوماً (0% عمولة)',
                                style: TextStyle(
                                  color: WasslniColors.gold500,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildHeaderBtn(Icons.card_giftcard, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DriverReferralScreen()),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Cockpit Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasslniColors.darkSurface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: WasslniColors.gold500.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Daily Stats Row (Fresh Active Driver State)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('أرباح اليوم', '0.00 MAD', WasslniColors.gold500),
                      _buildStatItem('الرحلات', '0', WasslniColors.textPrimary),
                      _buildStatItem('التقييم', 'جديد ⭐ 5.0', WasslniColors.success),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Simulated Incoming Request Test Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: WasslniColors.gold500,
                      side: const BorderSide(color: WasslniColors.gold500),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.bolt, size: 18),
                    label: const Text('محاكاة وصول طلب جديد'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const DriverIncomingRequestModal(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Online / Offline Switch
                  InkWell(
                    onTap: () => setState(() => _isOnline = !_isOnline),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: _isOnline ? WasslniColors.emerald800 : WasslniColors.darkSurfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isOnline ? WasslniColors.emerald500 : WasslniColors.darkBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isOnline ? Icons.power_settings_new : Icons.circle_outlined,
                            color: _isOnline ? Colors.white : WasslniColors.textTertiary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _isOnline ? 'أنت متصل الآن (جاهز لتلقي الطلبات)' : 'أنت غير متصل (انقر للبدء)',
                            style: TextStyle(
                              color: _isOnline ? Colors.white : WasslniColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: WasslniColors.darkSurface.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: WasslniColors.darkBorder),
        ),
        child: Icon(icon, color: WasslniColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: WasslniColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

