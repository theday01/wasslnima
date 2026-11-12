import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'driver_onboarding_docs_screen.dart';

class DriverSplashScreen extends StatefulWidget {
  const DriverSplashScreen({Key? key}) : super(key: key);

  @override
  State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}

class _DriverSplashScreenState extends State<DriverSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DriverOnboardingDocsScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: WasslniColors.emerald800,
                shape: BoxShape.circle,
                border: Border.all(color: WasslniColors.gold500, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: WasslniColors.emerald800.withOpacity(0.6),
                    blurRadius: 32,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_motorsports_rounded,
                color: WasslniColors.gold500,
                size: 48,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'وصّلني كابتن',
              style: TextStyle(
                color: WasslniColors.textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'شريك النجاح • 0% عمولة أول شهرين',
              style: TextStyle(
                color: WasslniColors.gold500,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

