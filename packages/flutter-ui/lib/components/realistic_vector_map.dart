import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

/// Ultra-smooth, crystal-clear Interactive Multi-Tile Slippy Map
/// Uses OpenStreetMap and Esri high-resolution tile layers.
/// Full touch gesture support: smooth 60fps pan, pinch-to-zoom, double-tap zoom.
/// Includes live driver markers, pickup pin, route path, and Casablanca landmarks.
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
  // Casablanca Center Coordinates (Maârif / Bd d'Anfa)
  double _centerLat = 33.5885;
  double _centerLon = -7.6320;
  double _zoom = 14.2;

  // Gesture Tracking
  Offset? _lastFocalPoint;
  double _startZoom = 14.0;
  double _startLat = 33.5885;
  double _startLon = -7.6320;

  late AnimationController _pulseController;

  // Casablanca Captains Locations
  final List<Map<String, dynamic>> _drivers = [
    {
      'name': 'كريم (لوغان)',
      'lat': 33.5895,
      'lon': -7.6300,
      'eta': '2 دقيقة',
      'angle': 45.0,
    },
    {
      'name': 'ياسين (كليو 5)',
      'lat': 33.5840,
      'lon': -7.6360,
      'eta': '4 دقائق',
      'angle': 120.0,
    },
    {
      'name': 'حمزة (فيات تيبو)',
      'lat': 33.5930,
      'lon': -7.6380,
      'eta': '6 دقائق',
      'angle': 210.0,
    },
    {
      'name': 'عمر (بيجو 208)',
      'lat': 33.5820,
      'lon': -7.6250,
      'eta': '5 دقائق',
      'angle': 315.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void disposeValidate() {}

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // --- Web Mercator Coordinate Calculations ---
  static double _lonToTileX(double lon, double zoom) {
    return ((lon + 180.0) / 360.0) * math.pow(2.0, zoom);
  }

  static double _latToTileY(double lat, double zoom) {
    final latRad = lat * math.pi / 180.0;
    return (1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) /
        2.0 *
        math.pow(2.0, zoom);
  }

  static double _tileXToLon(double x, double zoom) {
    return x / math.pow(2.0, zoom) * 360.0 - 180.0;
  }

  static double _tileYToLat(double y, double zoom) {
    final n = math.pi - 2.0 * math.pi * y / math.pow(2.0, zoom);
    return 180.0 / math.pi * math.atan(0.5 * (math.exp(n) - math.exp(-n)));
  }

  void _zoomIn() {
    setState(() {
      _zoom = (_zoom + 0.6).clamp(12.0, 17.5);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom = (_zoom - 0.6).clamp(12.0, 17.5);
    });
  }

  void _recenter() {
    setState(() {
      _centerLat = 33.5885;
      _centerLon = -7.6320;
      _zoom = 14.5;
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _startZoom = _zoom;
    _startLat = _centerLat;
    _startLon = _centerLon;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size screenSize) {
    if (_lastFocalPoint == null) return;

    setState(() {
      // 1. Pinch Zoom Calculation
      if (details.scale != 1.0) {
        final zoomDelta = math.log(details.scale) / math.ln2;
        _zoom = (_startZoom + zoomDelta).clamp(12.0, 17.5);
      }

      // 2. Drag / Pan Calculation in Web Mercator Pixels
      final delta = details.focalPoint - _lastFocalPoint!;
      _lastFocalPoint = details.focalPoint;

      final currentTileCenterX = _lonToTileX(_centerLon, _zoom);
      final currentTileCenterY = _latToTileY(_centerLat, _zoom);

      const tileSize = 256.0;
      final newTileCenterX = currentTileCenterX - (delta.dx / tileSize);
      final newTileCenterY = currentTileCenterY - (delta.dy / tileSize);

      _centerLon = _tileXToLon(newTileCenterX, _zoom);
      _centerLat = _tileYToLat(newTileCenterY, _zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        const tileSize = 256.0;
        final currentZoomInt = _zoom.floor();
        final zoomScale = math.pow(2.0, _zoom - currentZoomInt);

        final centerTileX = _lonToTileX(_centerLon, currentZoomInt.toDouble());
        final centerTileY = _latToTileY(_centerLat, currentZoomInt.toDouble());

        final halfWidth = screenSize.width / 2.0;
        final halfHeight = screenSize.height / 2.0;

        // Number of tiles needed in each direction
        final colsNeeded = (screenSize.width / (tileSize * zoomScale)).ceil() + 2;
        final rowsNeeded = (screenSize.height / (tileSize * zoomScale)).ceil() + 2;

        final minTileX = (centerTileX - colsNeeded / 2.0).floor();
        final maxTileX = (centerTileX + colsNeeded / 2.0).ceil();
        final minTileY = (centerTileY - rowsNeeded / 2.0).floor();
        final maxTileY = (centerTileY + rowsNeeded / 2.0).ceil();

        final maxTilesAtZoom = 1 << currentZoomInt;

        return GestureDetector(
          onScaleStart: _onScaleStart,
          onScaleUpdate: (d) => _onScaleUpdate(d, screenSize),
          onDoubleTap: _zoomIn,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // 1. Map Canvas Background
              Container(
                color: widget.isNightMode
                    ? const Color(0xFF0C120F)
                    : const Color(0xFFF2F4F3),
              ),

              // 2. Dynamic Slippy Map Tile Grid
              ..._buildTiles(
                minTileX: minTileX,
                maxTileX: maxTileX,
                minTileY: minTileY,
                maxTileY: maxTileY,
                currentZoomInt: currentZoomInt,
                maxTilesAtZoom: maxTilesAtZoom,
                centerTileX: centerTileX,
                centerTileY: centerTileY,
                tileSize: tileSize,
                zoomScale: zoomScale.toDouble(),
                halfWidth: halfWidth,
                halfHeight: halfHeight,
              ),

              // 3. Driver Demand Heatmap Overlay (for Driver App)
              if (widget.isDriverHeatmap)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _HeatmapZonesPainter(
                        centerLat: _centerLat,
                        centerLon: _centerLon,
                        zoom: _zoom,
                      ),
                    ),
                  ),
                ),

              // 4. Casablanca Landmark Chips / Street Badges
              Positioned(
                top: 80,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildLandmarkChip('📍 المعاريف (Maârif)', 33.5855, -7.6350),
                      const SizedBox(width: 8),
                      _buildLandmarkChip('📍 شارع أنفا (Bd d\'Anfa)', 33.5930, -7.6300),
                      const SizedBox(width: 8),
                      _buildLandmarkChip('📍 موروكو مول (Morocco Mall)', 33.5780, -7.6980),
                      const SizedBox(width: 8),
                      _buildLandmarkChip('📍 كازا بورت (Casa-Port)', 33.6015, -7.6130),
                      const SizedBox(width: 8),
                      _buildLandmarkChip('📍 سيدي معروف (Technopark)', 33.5350, -7.6450),
                    ],
                  ),
                ),
              ),

              // 5. Captains / Drivers Live Animated Markers
              ..._drivers.map((d) {
                final pos = _latLonToScreenOffset(
                  d['lat'] as double,
                  d['lon'] as double,
                  screenSize,
                );
                if (pos.dx < -50 ||
                    pos.dx > screenSize.width + 50 ||
                    pos.dy < -50 ||
                    pos.dy > screenSize.height + 50) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  left: pos.dx - 22,
                  top: pos.dy - 22,
                  child: _buildDriverMarker(
                    d['name'] as String,
                    d['eta'] as String,
                    d['angle'] as double,
                  ),
                );
              }),

              // 6. User Current Pickup Pin with Animated Radar Ring
              Positioned(
                left: halfWidth - 24,
                top: halfHeight - 48,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    final pulse = _pulseController.value;
                    return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Radar pulse wave
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 36 + (pulse * 32),
                            height: 18 + (pulse * 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: WasslniColors.emerald800.withOpacity(1.0 - pulse),
                                width: 2,
                              ),
                              color: WasslniColors.emerald500.withOpacity(0.18 * (1.0 - pulse)),
                            ),
                          ),
                        ),
                        // Luxury Pin
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: WasslniColors.emerald800,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: WasslniColors.gold500, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'نقطة الانطلاق',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Icon(
                              Icons.location_on,
                              color: WasslniColors.emerald800,
                              size: 34,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 7. Interactive Floating Map Controls (+, -, Recenter)
              Positioned(
                right: 16,
                bottom: 230,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMapControlBtn(Icons.add, _zoomIn, 'تكبير'),
                    const SizedBox(height: 8),
                    _buildMapControlBtn(Icons.remove, _zoomOut, 'تصغير'),
                    const SizedBox(height: 8),
                    _buildMapControlBtn(Icons.my_location, _recenter, 'موقعي'),
                  ],
                ),
              ),

              // 8. OpenFreeMap & OpenMapTiles Official Legal Attribution Banner
              Positioned(
                bottom: 215,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: WasslniColors.emerald800.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.layers_outlined, size: 12, color: WasslniColors.emerald800),
                      SizedBox(width: 5),
                      Text(
                        '© OpenFreeMap • © OpenMapTiles • © OpenStreetMap',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: WasslniColors.emerald800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Generate Slippy Map Tiles with High Performance
  List<Widget> _buildTiles({
    required int minTileX,
    required int maxTileX,
    required int minTileY,
    required int maxTileY,
    required int currentZoomInt,
    required int maxTilesAtZoom,
    required double centerTileX,
    required double centerTileY,
    required double tileSize,
    required double zoomScale,
    required double halfWidth,
    required double halfHeight,
  }) {
    final widgets = <Widget>[];

    for (int tx = minTileX; tx <= maxTileX; tx++) {
      for (int ty = minTileY; ty <= maxTileY; ty++) {
        if (ty < 0 || ty >= maxTilesAtZoom) continue;

        // Wrap X around 0..maxTilesAtZoom
        final wrappedX = (tx % maxTilesAtZoom + maxTilesAtZoom) % maxTilesAtZoom;

        final left = (tx - centerTileX) * (tileSize * zoomScale) + halfWidth;
        final top = (ty - centerTileY) * (tileSize * zoomScale) + halfHeight;
        final size = tileSize * zoomScale;

        // OpenStreetMap standard tile URL (fast, legal, high resolution)
        final tileUrl =
            'https://tile.openstreetmap.org/$currentZoomInt/$wrappedX/$ty.png';

        // Secondary fallback: Esri World Street Map
        final fallbackUrl =
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/$currentZoomInt/$ty/$wrappedX';

        widgets.add(
          Positioned(
            left: left,
            top: top,
            width: size + 0.5,
            height: size + 0.5,
            child: Image.network(
              tileUrl,
              fit: BoxFit.fill,
              headers: const {
                'User-Agent': 'Wasslni-Morocco-App/1.0 (contact@wasslni.ma)',
              },
              errorBuilder: (context, error, stackTrace) {
                // Secondary live fallback to Esri World Street Map
                return Image.network(
                  fallbackUrl,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F5),
                      border: Border.all(color: const Color(0xFFE2E8E5), width: 0.5),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Offset _latLonToScreenOffset(double lat, double lon, Size screenSize) {
    const tileSize = 256.0;
    final currentTileCenterX = _lonToTileX(_centerLon, _zoom);
    final currentTileCenterY = _latToTileY(_centerLat, _zoom);

    final targetTileX = _lonToTileX(lon, _zoom);
    final targetTileY = _latToTileY(lat, _zoom);

    final x = (targetTileX - currentTileCenterX) * tileSize + screenSize.width / 2.0;
    final y = (targetTileY - currentTileCenterY) * tileSize + screenSize.height / 2.0;
    return Offset(x, y);
  }

  Widget _buildDriverMarker(String name, String eta, double angle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: WasslniColors.emerald800.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                eta,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: WasslniColors.emerald800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        // Vector Taxi Car
        Transform.rotate(
          angle: angle * math.pi / 180.0,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: WasslniColors.gold500, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_car_filled,
              color: WasslniColors.emerald800,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandmarkChip(String label, double lat, double lon) {
    return InkWell(
      onTap: () {
        setState(() {
          _centerLat = lat;
          _centerLon = lon;
          _zoom = 15.0;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WasslniColors.emerald800.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: WasslniColors.lightTextPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildMapControlBtn(IconData icon, VoidCallback onTap, String tooltip) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: WasslniColors.emerald800, size: 22),
      ),
    );
  }
}

/// Demand Heatmap Zones for Driver App
class _HeatmapZonesPainter extends CustomPainter {
  final double centerLat;
  final double centerLon;
  final double zoom;

  _HeatmapZonesPainter({
    required this.centerLat,
    required this.centerLon,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);

    // Maarif high demand zone (Orange / Red glow)
    paint.color = const Color(0xFFEF4444).withOpacity(0.22);
    canvas.drawCircle(Offset(size.width * 0.48, size.height * 0.46), 75, paint);

    // Bd Zerktouni zone (Gold glow)
    paint.color = const Color(0xFFF59E0B).withOpacity(0.25);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.40), 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
