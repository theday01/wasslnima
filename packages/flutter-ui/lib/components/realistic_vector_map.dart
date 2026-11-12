import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';

/// An ultra-realistic vector map canvas replicating dark-mode Moroccan city maps
/// (Casablanca / Rabat / Marrakech) with authentic streets, arterial boulevards,
/// landmark labels, animated radar pulses, and GPS navigation pins.
class RealisticVectorMapView extends StatefulWidget {
  final bool isDriverHeatmap;
  final String centerTitle;
  final VoidCallback? onCenterTap;

  const RealisticVectorMapView({
    Key? key,
    this.isDriverHeatmap = false,
    this.centerTitle = 'الدار البيضاء • أنفا',
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
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _MapGridPainter(
            pulseValue: _pulseController.value,
            isHeatmap: widget.isDriverHeatmap,
          ),
          child: child,
        );
      },
      child: Stack(
        children: [
          // Casablanca Boulevard Labels
          Positioned(
            top: 140,
            left: 30,
            child: _buildStreetLabel('Bd d\'Anfa • شارع أنفا'),
          ),
          Positioned(
            top: 260,
            right: 40,
            child: _buildStreetLabel('Bd Zerktouni • شارع الزرقطوني'),
          ),
          Positioned(
            top: 380,
            left: 50,
            child: _buildStreetLabel('Maârif • حي المعاريف'),
          ),
          Positioned(
            bottom: 220,
            right: 30,
            child: _buildStreetLabel('Sidi Maarouf • سيدي معروف (Casanearshore)'),
          ),

          // Central GPS User Pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: WasslniColors.darkSurface.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isDriverHeatmap
                          ? WasslniColors.warning
                          : WasslniColors.gold500,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
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
                            : WasslniColors.emerald400,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.centerTitle,
                        style: const TextStyle(
                          color: WasslniColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.isDriverHeatmap
                        ? WasslniColors.warning
                        : WasslniColors.gold500,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isDriverHeatmap
                                ? WasslniColors.warning
                                : WasslniColors.gold500)
                            .withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // Heatmap hotspot badge if in driver mode
          if (widget.isDriverHeatmap)
            Positioned(
              top: 190,
              right: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: WasslniColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: WasslniColors.warning),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: WasslniColors.warning, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'طلب مرتفع +20%',
                      style: TextStyle(
                        color: WasslniColors.warning,
                        fontSize: 10,
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

  Widget _buildStreetLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A15).withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.55),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final double pulseValue;
  final bool isHeatmap;

  _MapGridPainter({required this.pulseValue, required this.isHeatmap});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Basemap Background
    final bgPaint = Paint()..color = const Color(0xFF0A100D);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City Blocks (Dark Poly shapes)
    final blockPaint = Paint()
      ..color = const Color(0xFF0E1814)
      ..style = PaintingStyle.fill;

    final blockBorder = Paint()
      ..color = const Color(0xFF162520)
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

    // 3. Secondary Streets
    final streetPaint = Paint()
      ..color = const Color(0xFF1E332B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (double y = 40; y < size.height; y += 110) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }
    for (double x = 10; x < size.width; x += 130) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    // 4. Primary Arterials / Boulevards (Diagonal & Golden glow)
    final boulevardPaint = Paint()
      ..color = const Color(0xFF2C4C3E)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final boulevardCenter = Paint()
      ..color = const Color(0xFF3E6B57)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Bd d'Anfa diagonal
    canvas.drawLine(
      Offset(-20, size.height * 0.25),
      Offset(size.width + 20, size.height * 0.55),
      boulevardPaint,
    );
    canvas.drawLine(
      Offset(-20, size.height * 0.25),
      Offset(size.width + 20, size.height * 0.55),
      boulevardCenter,
    );

    // Bd Zerktouni cross diagonal
    canvas.drawLine(
      Offset(size.width * 0.2, -20),
      Offset(size.width * 0.85, size.height + 20),
      boulevardPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, -20),
      Offset(size.width * 0.85, size.height + 20),
      boulevardCenter,
    );

    // 5. Heatmap hotspots or Radar Pulses
    final center = Offset(size.width / 2, size.height / 2 - 20);

    if (isHeatmap) {
      // Heatmap glow zones
      final heatPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            WasslniColors.warning.withOpacity(0.35),
            WasslniColors.error.withOpacity(0.15),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 120));
      canvas.drawCircle(center, 120, heatPaint);

      final secondHotspot = Offset(size.width * 0.75, size.height * 0.32);
      final heatPaint2 = Paint()
        ..shader = RadialGradient(
          colors: [
            WasslniColors.warning.withOpacity(0.4),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: secondHotspot, radius: 80));
      canvas.drawCircle(secondHotspot, 80, heatPaint2);
    } else {
      // Radar Wave expanding outward from user
      final radarRadius = 40.0 + (pulseValue * 100.0);
      final radarAlpha = (1.0 - pulseValue).clamp(0.0, 1.0);
      final pulsePaint = Paint()
        ..color = WasslniColors.emerald400.withOpacity(radarAlpha * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radarRadius, pulsePaint);

      final pulsePaint2 = Paint()
        ..color = WasslniColors.emerald400.withOpacity(radarAlpha * 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radarRadius, pulsePaint2);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.isHeatmap != isHeatmap;
  }
}
