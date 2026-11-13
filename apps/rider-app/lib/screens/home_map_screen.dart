import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'ride_request_screen.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({Key? key}) : super(key: key);

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WasslniColors.lightCanvas,
      drawer: const WasslniSideDrawer(
        userName: 'الراكب الكريم',
        userPhone: '+212 6XX-XXXXXX',
        userRole: 'rider',
      ),
      body: Stack(
        children: [
          // Authentic OpenStreetMap Real Tile Map with Casablanca Layout in Day Mode
          const RealisticVectorMapView(
            isDriverHeatmap: false,
            centerTitle: 'الدار البيضاء • أنفا',
            isNightMode: false,
          ),

          // Floating Top App Bar (Day Mode)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleBtn(Icons.menu, () {
                    _scaffoldKey.currentState?.openDrawer();
                  }),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: WasslniColors.lightBorder),
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
                        Icon(Icons.location_on, color: WasslniColors.emerald800, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'وصّلني كازابلانكا',
                          style: TextStyle(
                            color: WasslniColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCircleBtn(Icons.notifications_none, () {
                    WasslniNotificationsSheet.show(context, isDriver: false);
                  }),
                ],
              ),
            ),
          ),

          // Floating Bottom Booking Sheet (Day Mode)
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
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بك، فين غادي اليوم؟',
                    style: TextStyle(
                      color: WasslniColors.lightTextPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Destination Input Trigger
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RideRequestScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: WasslniColors.lightSurfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: WasslniColors.lightBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: WasslniColors.emerald800),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'إلى أين وجهتك؟ (حدد أو اكتب)',
                              style: TextStyle(
                                color: WasslniColors.lightTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.mic_none, color: WasslniColors.emerald800),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  // Saved places chips in Day Mode
                  Row(
                    children: [
                      _buildPlaceChip(Icons.home, 'الدار (المعاريف)', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RideRequestScreen()),
                        );
                      }),
                      const SizedBox(width: 8),
                      _buildPlaceChip(Icons.work, 'الخدمة (سيدي معروف)', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RideRequestScreen()),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
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

  Widget _buildPlaceChip(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: WasslniColors.lightSurfaceRaised,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WasslniColors.lightBorderSubtle),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: WasslniColors.emerald800, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: WasslniColors.lightTextPrimary,
                    fontSize: 12,
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
}
