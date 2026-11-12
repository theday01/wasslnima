import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'active_trip_screen.dart';

class LiveOffersScreen extends StatefulWidget {
  final int suggestedPriceMad;
  final String pickupLocation;
  final String destinationLocation;
  final String? landmarkNote;
  final String category;

  const LiveOffersScreen({
    Key? key,
    required this.suggestedPriceMad,
    required this.pickupLocation,
    required this.destinationLocation,
    this.landmarkNote,
    this.category = 'ECO',
  }) : super(key: key);

  @override
  State<LiveOffersScreen> createState() => _LiveOffersScreenState();
}

class _LiveOffersScreenState extends State<LiveOffersScreen> {
  late int _currentPrice;
  final List<Map<String, dynamic>> _bids = [];
  bool _isSearching = true;

  @override
  void initState() {
    super.initState();
    _currentPrice = widget.suggestedPriceMad;

    // Simulate real nearby drivers discovering the live request after 2 seconds
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _bids.add({
            'driverName': 'كريم التازي',
            'vehicle': 'داسيا لوغان (رمادية) • 26-أ-7721',
            'rating': 4.94,
            'trips': 1120,
            'price': _currentPrice,
            'etaMinutes': 3,
            'acceptedExact': true,
          });
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        setState(() {
          _bids.add({
            'driverName': 'أمين الصقلي',
            'vehicle': 'رونو كليو 5 (بيضاء) • 6-ب-3180',
            'rating': 4.88,
            'trips': 820,
            'price': _currentPrice + 4,
            'etaMinutes': 5,
            'acceptedExact': false,
          });
        });
      }
    });
  }

  void _increasePrice() {
    setState(() {
      _currentPrice += 3;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم رفع السعر إلى $_currentPrice MAD لجذب المزيد من السائقين'),
        backgroundColor: WasslniColors.emerald800,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: WasslniColors.darkSurface,
        elevation: 0,
        title: const Text(
          'رادار العروض الحية',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User's Real Requested Trip Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WasslniColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.navigation, color: WasslniColors.emerald400, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${widget.pickupLocation} ➔ ${widget.destinationLocation}',
                            style: const TextStyle(
                              color: WasslniColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (widget.landmarkNote != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'معلم: ${widget.landmarkNote}',
                        style: const TextStyle(
                          color: WasslniColors.gold500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Broadcast Status & Price Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WasslniColors.emerald800.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WasslniColors.emerald500.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(WasslniColors.emerald400),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سعرك المعروض: $_currentPrice MAD',
                            style: const TextStyle(
                              color: WasslniColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'يتم بث طلبك الآن للكباتن القريبين منك...',
                            style: TextStyle(
                              color: WasslniColors.emerald400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WasslniColors.gold500,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _increasePrice,
                      child: const Text(
                        '+3 MAD',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                _bids.isEmpty
                  ? 'جاري فحص العروض...'
                  : 'عروض الكباتن المتاحة (${_bids.length}):',
                style: const TextStyle(
                  color: WasslniColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // Real Incoming Bids List
              Expanded(
                child: _bids.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.radar,
                            size: 64,
                            color: WasslniColors.emerald400.withOpacity(0.4),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'في انتظار رد السائقين القريبين...',
                            style: TextStyle(
                              color: WasslniColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'يمكنك رفع سعرك قليلاً لتسريع قبول الرحلة',
                            style: TextStyle(
                              color: WasslniColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _bids.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final bid = _bids[index];
                        return DriverBidCard(
                          driverName: bid['driverName'],
                          vehicleInfo: bid['vehicle'],
                          rating: bid['rating'],
                          totalTrips: bid['trips'],
                          offeredPriceMad: bid['price'],
                          arrivalMinutes: bid['etaMinutes'],
                          onAccept: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => ActiveTripScreen(
                                  driverName: bid['driverName'],
                                  vehicleInfo: bid['vehicle'],
                                  agreedPriceMad: bid['price'],
                                ),
                              ),
                            );
                          },
                          onReject: () {
                            setState(() {
                              _bids.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
