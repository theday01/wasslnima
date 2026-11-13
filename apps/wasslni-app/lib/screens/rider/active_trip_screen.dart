import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'package:latlong2/latlong.dart';

class ActiveTripScreen extends StatefulWidget {
  final String driverName;
  final String vehicleInfo;
  final int agreedPriceMad;
  final String pickupLocation;
  final String destinationLocation;

  const ActiveTripScreen({
    Key? key,
    required this.driverName,
    required this.vehicleInfo,
    required this.agreedPriceMad,
    this.pickupLocation = 'المعاريف • شارع المسيرة',
    this.destinationLocation = 'موروكو مول • عين الذياب',
  }) : super(key: key);

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  List<LatLng> _routePoints = [];
  LatLng? _driverCurrentPoint;
  LatLng? _destinationPoint;
  double _distanceKm = 0.0;
  int _etaMinutes = 2;
  bool _isLoadingRoute = true;
  Timer? _carMovementTimer;
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLiveRoadRoute();
  }

  @override
  void dispose() {
    _carMovementTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLiveRoadRoute() async {
    // 1. Resolve Pickup and Destination Coordinates
    LatLng origin = await WasslniRoutingService.geocodeLocation(widget.pickupLocation) ??
        const LatLng(33.5885, -7.6320); // Maarif default
    LatLng dest = await WasslniRoutingService.geocodeLocation(widget.destinationLocation) ??
        const LatLng(33.5762, -7.7003); // Morocco Mall default

    // 2. Fetch True Street Route using OSRM / Spatial Hub
    final routeResult = await WasslniRoutingService.getDrivingRoute(
      origin: origin,
      destination: dest,
    );

    if (mounted) {
      if (routeResult != null && routeResult.points.isNotEmpty) {
        setState(() {
          _routePoints = routeResult.points;
          _distanceKm = routeResult.distanceKm;
          _etaMinutes = routeResult.durationMinutes;
          _destinationPoint = dest;
          _driverCurrentPoint = routeResult.points.first;
          _isLoadingRoute = false;
        });

        // 3. Start Smooth Vehicle Driving Animation along Real Streets
        _startSmoothVehicleTracking();
      } else {
        setState(() {
          _isLoadingRoute = false;
          _destinationPoint = dest;
        });
      }
    }
  }

  void _startSmoothVehicleTracking() {
    if (_routePoints.isEmpty) return;

    // Advance driver along true road coordinates smoothly every 1.5 seconds
    _carMovementTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentStepIndex < _routePoints.length - 1) {
        setState(() {
          _currentStepIndex++;
          _driverCurrentPoint = _routePoints[_currentStepIndex];
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      body: Stack(
        children: [
          // 1. Live Navigation Vector Map with Real Street Geometry & Moving Driver Car
          RealisticVectorMapView(
            isDriverHeatmap: false,
            centerTitle: 'الكابتن ${widget.driverName} في طريقه إليك',
            routePoints: _routePoints,
            destinationPoint: _destinationPoint,
            destinationTitle: widget.destinationLocation,
            liveDrivers: _driverCurrentPoint != null
                ? [
                    {
                      'name': widget.driverName,
                      'car': widget.vehicleInfo,
                      'point': _driverCurrentPoint!,
                      'eta': '$_etaMinutes د',
                      'angle': 45.0,
                    }
                  ]
                : null,
          ),

          // 2. Top Safety Bar with SOS & Encryption Badge
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SosAlertButton(
                    onTrigger: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: WasslniColors.error),
                              SizedBox(width: 8),
                              Text('إنذار الطوارئ SOS', style: TextStyle(color: WasslniColors.lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          content: const Text(
                            'هل تريد الاتصال بالشرطة (19) ومشاركة موقعك المباشر مع جهات اتصالك الموثوقة؟',
                            style: TextStyle(color: WasslniColors.lightTextSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('إلغاء', style: TextStyle(color: WasslniColors.lightTextSecondary)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WasslniColors.error,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('اتصال فوري (19)'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: WasslniColors.lightBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: WasslniColors.emerald800, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _isLoadingRoute ? 'جاري رسم المسار...' : '$_distanceKm كم • $_etaMinutes دقيقة',
                          style: const TextStyle(
                            color: WasslniColors.emerald800,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                    child: IconButton(
                      icon: const Icon(Icons.share_location_rounded, color: WasslniColors.emerald800, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم نسخ رابط التتبع المباشر للرحلة للمشاركة عبر الواتساب'),
                            backgroundColor: WasslniColors.emerald800,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Sliding Sheet with Real Driver Details and Navigation Actions
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Driver Header Card
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: WasslniColors.emerald800,
                            shape: BoxShape.circle,
                            border: Border.all(color: WasslniColors.gold500, width: 2),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: WasslniColors.gold500, size: 30),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.driverName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: WasslniColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.vehicleInfo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: WasslniColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: WasslniColors.emerald800.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: WasslniColors.emerald800.withOpacity(0.2)),
                          ),
                          child: Text(
                            '${widget.agreedPriceMad} MAD',
                            style: const TextStyle(
                              color: WasslniColors.emerald800,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Navigation to External Google Maps / Waze Button
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: WasslniColors.emerald800,
                              side: const BorderSide(color: WasslniColors.emerald800),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.navigation_rounded, size: 18),
                            label: const Text('فتح في Google Maps', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            onPressed: () {
                              if (_destinationPoint != null) {
                                VoiceNavigationHelper.launchGoogleMaps(
                                  _destinationPoint!.latitude,
                                  _destinationPoint!.longitude,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF33CCFF),
                              side: const BorderSide(color: Color(0xFF33CCFF)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.explore_rounded, size: 18),
                            label: const Text('فتح في Waze', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            onPressed: () {
                              if (_destinationPoint != null) {
                                VoiceNavigationHelper.launchWaze(
                                  _destinationPoint!.latitude,
                                  _destinationPoint!.longitude,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
