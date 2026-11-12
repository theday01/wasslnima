import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'ride_request_screen.dart';

class HomeMapScreen extends StatelessWidget {
  const HomeMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      body: Stack(
        children: [
          // Simulated Dark Map Background
          Container(
            color: const Color(0xFF0D1411),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: WasslniColors.emerald800.withOpacity(0.4),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'خريطة الدار البيضاء الحية',
                    style: TextStyle(
                      color: WasslniColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Top App Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  _buildCircleBtn(Icons.menu, () {}),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: WasslniColors.darkSurface.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: WasslniColors.gold500.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Text('🇲🇦', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6),
                        Text(
                          'وصّلني كازا',
                          style: TextStyle(
                            color: WasslniColors.gold500,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCircleBtn(Icons.notifications_none, () {}),
                ],
              ),
            ),
          ),

          // Floating Bottom Booking Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasslniColors.darkSurface.withOpacity(0.92),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بك، فين غادي اليوم؟',
                    style: TextStyle(
                      color: WasslniColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                        color: WasslniColors.darkSurfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: WasslniColors.darkBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: WasslniColors.gold500),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'إلى أين وجهتك؟ (حدد أو اكتب)',
                              style: TextStyle(
                                color: WasslniColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.mic, color: WasslniColors.emerald400),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  // Saved places chips
                  Row(
                    children: [
                      _buildPlaceChip('🏠 الدار (المعاريف)', () {}),
                      const SizedBox(width: 8),
                      _buildPlaceChip('💼 الخدمة (سيدي معروف)', () {}),
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
          color: WasslniColors.darkSurface.withOpacity(0.85),
          shape: BoxShape.circle,
          border: Border.all(color: WasslniColors.darkBorder),
        ),
        child: Icon(icon, color: WasslniColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _buildPlaceChip(String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: WasslniColors.darkSurfaceRaised,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WasslniColors.darkBorderSubtle),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: WasslniColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

