import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// Launch Google Maps directly
  static Future<bool> launchGoogleMaps(double lat, double lon) async {
    final nativeUri = Uri.parse(buildGoogleMapsUri(lat, lon));
    try {
      if (await canLaunchUrl(nativeUri)) {
        return await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    // Fallback to Web URL
    final webUri = Uri.parse(buildWebNavigationUrl(lat, lon));
    return await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  /// Launch Waze directly
  static Future<bool> launchWaze(double lat, double lon) async {
    final nativeUri = Uri.parse(buildWazeUri(lat, lon));
    try {
      if (await canLaunchUrl(nativeUri)) {
        return await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    // Fallback to Google Maps if Waze not installed
    return await launchGoogleMaps(lat, lon);
  }

  /// Show quick modal for driver to pick Waze or Google Maps
  static void showNavigationSelector({
    required BuildContext context,
    required double destinationLat,
    required double destinationLon,
    required String destinationName,
    Function(String uri)? onLaunch,
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.navigation, color: Color(0xFF0B3D2E), size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'بدء الملاحة الصوتية المباشرة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF141F1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'الوجهة: $destinationName',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Option 1: Waze
                InkWell(
                  onTap: () async {
                    Navigator.pop(ctx);
                    await launchWaze(destinationLat, destinationLon);
                    if (onLaunch != null) {
                      onLaunch(buildWazeUri(destinationLat, destinationLon));
                    }
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF33CCFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(Icons.alt_route, color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تطبيق Waze (الخيار المفضل للسائقين)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF0B3D2E),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'تنبيهات الرادار، كاميرات السرعة، والازدحام اللحظي',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF0B3D2E)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Option 2: Google Maps
                InkWell(
                  onTap: () async {
                    Navigator.pop(ctx);
                    await launchGoogleMaps(destinationLat, destinationLon);
                    if (onLaunch != null) {
                      onLaunch(buildGoogleMapsUri(destinationLat, destinationLon));
                    }
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4285F4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(Icons.map, color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تطبيق خرائط Google Maps',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'الملاحة بالصوت المباشر والمسار الأقصر القياسي',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
