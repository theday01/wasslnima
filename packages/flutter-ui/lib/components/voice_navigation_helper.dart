import 'package:flutter/material.dart';

/// Wasslni Voice Navigation Launcher
/// Triggers Native Deep Links for Turn-by-Turn Voice Navigation:
/// - Waze (Moroccan drivers' top choice for radar & traffic)
/// - Google Maps (Default Android standard)
class VoiceNavigationHelper {
  /// Builds deep-link URI for Waze navigation
  static String buildWazeUri(double lat, double lon) {
    return 'waze://?ll=$lat,$lon&navigate=yes';
  }

  /// Builds deep-link URI for Google Maps voice turn-by-turn navigation
  static String buildGoogleMapsUri(double lat, double lon) {
    return 'google.navigation:q=$lat,$lon&mode=d';
  }

  /// Builds universal fallback web URL
  static String buildWebNavigationUrl(double lat, double lon) {
    return 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon';
  }

  /// Show quick modal for driver to pick Waze or Google Maps
  static void showNavigationSelector({
    required BuildContext context,
    required double destinationLat,
    required double destinationLon,
    required String destinationName,
    required Function(String uri) onLaunch,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'اختر تطبيق الملاحة الصوتية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3D2E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'الوجهة: $destinationName',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 18),

                // Option 1: Waze
                InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    onLaunch(buildWazeUri(destinationLat, destinationLon));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F9F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0B3D2E).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF33CCFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.navigation, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تطبيق Waze (تنبيهات الرادار والزحام)',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'مفضل لدى أغلب السائقين المغاربة',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Option 2: Google Maps
                InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    onLaunch(buildGoogleMapsUri(destinationLat, destinationLon));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4285F4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.map, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Google Maps (الملاحة الافتراضية)',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'خرائط جوجل الرسمية مع التوجيه الصوتي بالعربية',
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
