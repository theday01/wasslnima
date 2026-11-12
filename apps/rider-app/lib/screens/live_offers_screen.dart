import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'active_trip_screen.dart';

class LiveOffersScreen extends StatelessWidget {
  final int suggestedPriceMad;

  const LiveOffersScreen({Key? key, required this.suggestedPriceMad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: WasslniColors.darkSurface,
        elevation: 0,
        title: const Text(
          'عروض السائقين الحية',
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
              // Broadcast Status Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WasslniColors.emerald800.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WasslniColors.emerald500.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(WasslniColors.emerald400),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سعرك المقترح: $suggestedPriceMad MAD',
                            style: const TextStyle(
                              color: WasslniColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'جاري استقبال العروض من السائقين القريبين منك...',
                            style: TextStyle(
                              color: WasslniColors.emerald400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Text(
                'العروض الواردة الآن:',
                style: TextStyle(
                  color: WasslniColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Simulated Incoming Bids
              Expanded(
                child: ListView(
                  children: [
                    DriverBidCard(
                      driverName: 'ياسين العلمي',
                      vehicleInfo: 'داسيا لوغان (رمادية) • 26-أ-9841',
                      rating: 4.95,
                      totalTrips: 1420,
                      offeredPriceMad: suggestedPriceMad, // Accepted exact price
                      arrivalMinutes: 3,
                      onAccept: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ActiveTripScreen(
                              driverName: 'ياسين العلمي',
                              vehicleInfo: 'داسيا لوغان (رمادية) • 26-أ-9841',
                              agreedPriceMad: suggestedPriceMad,
                            ),
                          ),
                        );
                      },
                      onReject: () {},
                    ),
                    const SizedBox(height: 12),
                    DriverBidCard(
                      driverName: 'عمر الشرايبي',
                      vehicleInfo: 'رونو كليو 5 (سوداء) • 6-ب-4410',
                      rating: 4.88,
                      totalTrips: 850,
                      offeredPriceMad: suggestedPriceMad + 4, // Counter offer
                      arrivalMinutes: 5,
                      onAccept: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ActiveTripScreen(
                              driverName: 'عمر الشرايبي',
                              vehicleInfo: 'رونو كليو 5 (سوداء) • 6-ب-4410',
                              agreedPriceMad: suggestedPriceMad + 4,
                            ),
                          ),
                        );
                      },
                      onReject: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

