import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import '../rider/home_map_screen.dart';
import 'driver_incoming_request_modal.dart';
import 'driver_wallet_screen.dart';
import 'driver_referral_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WasslniColors.lightCanvas,
      drawer: WasslniSideDrawer(
        userName: 'كابتن وصّلني',
        userPhone: '+212 6XX-XXXXXX',
        userRole: 'driver',
        onSwitchRole: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeMapScreen()),
          );
        },
        onWalletTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DriverWalletScreen()),
          );
        },
      ),
      body: Stack(
        children: [
          // Realistic Casablanca Demand Heatmap Canvas in Day Mode
          const RealisticVectorMapView(
            isDriverHeatmap: true,
            centerTitle: 'الدار البيضاء • المعاريف (طلب مرتفع)',
            isNightMode: false,
          ),

          // Top Header & Free Commission Badge (Day Mode)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderBtn(Icons.menu, () {
                        _scaffoldKey.currentState?.openDrawer();
                      }),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: WasslniColors.gold500, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.verified, color: WasslniColors.gold500, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'باقي 48 يوماً (0% عمولة)',
                                style: TextStyle(
                                  color: WasslniColors.lightTextPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildHeaderBtn(Icons.notifications_none, () {
                        WasslniNotificationsSheet.show(context, isDriver: true);
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Cockpit Panel (Day Mode)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: WasslniColors.lightBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
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
                      _buildStatItem('أرباح اليوم', '0.00 MAD', WasslniColors.emerald800, Icons.monetization_on_outlined),
                      _buildStatItem('الرحلات', '0', WasslniColors.lightTextPrimary, Icons.directions_car_outlined),
                      _buildStatItem('التقييم', 'جديد 5.0', WasslniColors.success, Icons.star_rate_rounded),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Navigation & Simulated Request Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WasslniColors.emerald800,
                            side: const BorderSide(color: WasslniColors.emerald800),
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.bolt, size: 18),
                          label: const Text('محاكاة طلب جديد'),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const DriverIncomingRequestModal(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B3D2E),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.navigation, size: 18, color: WasslniColors.gold500),
                          label: const Text('الملاحة الصوتية'),
                          onPressed: () {
                            VoiceNavigationHelper.showNavigationSelector(
                              context: context,
                              destinationLat: 33.5992,
                              destinationLon: -7.6114,
                              destinationName: 'الدار البيضاء • كازا بورت',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Online / Offline Switch
                  InkWell(
                    onTap: () => setState(() => _isOnline = !_isOnline),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: _isOnline ? WasslniColors.emerald800 : WasslniColors.lightSurfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isOnline ? WasslniColors.emerald700 : WasslniColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isOnline ? Icons.power_settings_new : Icons.circle_outlined,
                            color: _isOnline ? Colors.white : WasslniColors.lightTextTertiary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _isOnline ? 'أنت متصل الآن (جاهز لتلقي الطلبات)' : 'أنت غير متصل (انقر للبدء)',
                            style: TextStyle(
                              color: _isOnline ? Colors.white : WasslniColors.lightTextSecondary,
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
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: WasslniColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: WasslniColors.lightTextPrimary, size: 20),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valColor, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: WasslniColors.lightTextSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: WasslniColors.lightTextSecondary, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valColor,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
