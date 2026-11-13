import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

/// Ultra-realistic OpenStreetMap tile rendering widget with authentic Moroccan city layout
/// Automatically supports Day Mode (Crisp White/Pastel Street layout) and Night Mode.
/// Pulls live real OpenStreetMap standard tiles seamlessly with offline visual fallback.
class RealisticVectorMapView extends StatefulWidget {
  final bool isDriverHeatmap;
  final String centerTitle;
  final bool isNightMode;
  final VoidCallback? onCenterTap;

  const RealisticVectorMapView({
    Key? key,
    this.isDriverHeatmap = false,
    this.centerTitle = 'الدار البيضاء • أنفا',
    this.isNightMode = false,
    this.onCenterTap,
  }) : super(key: key);

  @override
  State<RealisticVectorMapView> createState() => _RealisticVectorMapViewState();
}

class _RealisticVectorMapViewState extends State<RealisticVectorMapView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Casablanca center coordinates approx: 33.5892° N, 7.6038° W
    // OpenStreetMap standard tile URL pattern:
    // https://tile.openstreetmap.org/{z}/{x}/{y}.png
    // Using zoom level 14 around Casablanca center
    const int z = 14;
    const int x = 8295;
    const int y = 6605;
    final osmTileUrl = 'https://tile.openstreetmap.org/$z/$x/$y.png';

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: [
            // 1. Live Web Map Tile Layer from OpenStreetMap (Free, Legal, Open API)
            Positioned.fill(
              child: Image.network(
                osmTileUrl,
                fit: BoxFit.cover,
                headers: const {
                  'User-Agent': 'Wasslni-Morocco-App/1.0 (ma.wasslni.rider_app)',
                },
                errorBuilder: (context, error, stackTrace) {
                  // Elegant vector fallback if offline or no network
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _MapGridPainter(
                      pulseValue: _pulseController.value,
                      isHeatmap: widget.isDriverHeatmap,
                      isNightMode: widget.isNightMode,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        child,
                        // Light subtle overlay to blend with Wasslni Moroccan brand
                        Container(
                          color: widget.isNightMode
                              ? const Color(0xFF070D0B).withOpacity(0.65)
                              : Colors.white.withOpacity(0.12),
                        ),
                      ],
                    );
                  }
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _MapGridPainter(
                      pulseValue: _pulseController.value,
                      isHeatmap: widget.isDriverHeatmap,
                      isNightMode: widget.isNightMode,
                    ),
                  );
                },
              ),
            ),

            // 2. Vector Dynamic Overlay (Heatmap + Pulses)
            Positioned.fill(
              child: CustomPaint(
                painter: _OverlayPainter(
                  pulseValue: _pulseController.value,
                  isHeatmap: widget.isDriverHeatmap,
                ),
              ),
            ),

            // 3. Child Controls & Pins
            if (child != null) child,
          ],
        );
      },
      child: Stack(
        children: [
          // Casablanca Boulevard Interactive Road Badges
          Positioned(
            top: 140,
            left: 24,
            child: _buildStreetLabel('Bd d\'Anfa • شارع أنفا', widget.isNightMode),
          ),
          Positioned(
            top: 250,
            right: 28,
            child: _buildStreetLabel('Bd Zerktouni • شارع الزرقطوني', widget.isNightMode),
          ),
          Positioned(
            top: 370,
            left: 36,
            child: _buildStreetLabel('Maârif • حي المعاريف', widget.isNightMode),
          ),
          Positioned(
            bottom: 230,
            right: 24,
            child: _buildStreetLabel('Sidi Maarouf • سيدي معروف', widget.isNightMode),
          ),

          // Central GPS User Location Marker
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: widget.isNightMode ? WasslniColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.isDriverHeatmap
                          ? WasslniColors.warning
                          : WasslniColors.gold500,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isDriverHeatmap
                            ? Icons.local_fire_department
                            : Icons.my_location,
                        color: widget.isDriverHeatmap
                            ? WasslniColors.warning
                            : WasslniColors.emerald800,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.centerTitle,
                        style: TextStyle(
                          color: widget.isNightMode ? Colors.white : WasslniColors.lightTextPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: widget.isDriverHeatmap
                        ? WasslniColors.warning
                        : WasslniColors.emerald800,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.5),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isDriverHeatmap
                                ? WasslniColors.warning
                                : WasslniColors.emerald800)
                            .withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: WasslniColors.gold500,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // High demand indicator badge in Driver Mode
          if (widget.isDriverHeatmap)
            Positioned(
              top: 190,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: WasslniColors.warning.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.black, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'منطقة طلب عالي +25%',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
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

  Widget _buildStreetLabel(String label, bool isNight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isNight ? const Color(0xFF101B16).withOpacity(0.9) : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNight ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isNight ? Colors.white.withOpacity(0.7) : const Color(0xFF2C3E35),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double pulseValue;
  final bool isHeatmap;

  _OverlayPainter({required this.pulseValue, required this.isHeatmap});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 20);

    if (isHeatmap) {
      final heatPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            WasslniColors.warning.withOpacity(0.38),
            WasslniColors.error.withOpacity(0.16),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 130));
      canvas.drawCircle(center, 130, heatPaint);

      final secondHotspot = Offset(size.width * 0.72, size.height * 0.35);
      final heatPaint2 = Paint()
        ..shader = RadialGradient(
          colors: [
            WasslniColors.warning.withOpacity(0.42),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: secondHotspot, radius: 85));
      canvas.drawCircle(secondHotspot, 85, heatPaint2);
    } else {
      final radarRadius = 35.0 + (pulseValue * 110.0);
      final radarAlpha = (1.0 - pulseValue).clamp(0.0, 1.0);
      final pulsePaint = Paint()
        ..color = WasslniColors.emerald800.withOpacity(radarAlpha * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      canvas.drawCircle(center, radarRadius, pulsePaint);

      final fillPaint = Paint()
        ..color = WasslniColors.emerald800.withOpacity(radarAlpha * 0.12)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radarRadius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.isHeatmap != isHeatmap;
  }
}

class _MapGridPainter extends CustomPainter {
  final double pulseValue;
  final bool isHeatmap;
  final bool isNightMode;

  _MapGridPainter({
    required this.pulseValue,
    required this.isHeatmap,
    required this.isNightMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isNightMode ? const Color(0xFF0B1410) : const Color(0xFFF3F5F4);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final blockPaint = Paint()
      ..color = isNightMode ? const Color(0xFF101C17) : const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    final blockBorder = Paint()
      ..color = isNightMode ? const Color(0xFF1B2D25) : const Color(0xFFE4E9E6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double y = 60; y < size.height; y += 110) {
      for (double x = 20; x < size.width; x += 130) {
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, 105, 85),
          const Radius.circular(8),
        );
        canvas.drawRRect(rrect, blockPaint);
        canvas.drawRRect(rrect, blockBorder);
      }
    }

    final streetPaint = Paint()
      ..color = isNightMode ? const Color(0xFF1E332B) : const Color(0xFFE5ECE8)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (double y = 40; y < size.height; y += 110) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }
    for (double x = 10; x < size.width; x += 130) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    final boulevardPaint = Paint()
      ..color = isNightMode ? const Color(0xFF2C4C3E) : const Color(0xFFCBDCD3)
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(-20, size.height * 0.25),
      Offset(size.width + 20, size.height * 0.55),
      boulevardPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, -20),
      Offset(size.width * 0.85, size.height + 20),
      boulevardPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.isNightMode != isNightMode;
  }
}
