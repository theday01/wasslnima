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
    Future.delayed(const Duration(milliseconds: 1800), () {
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: WasslniColors.emerald800,
                shape: BoxShape.circle,
                border: Border.all(color: WasslniColors.gold500, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: WasslniColors.emerald800.withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_motorsports_rounded,
                color: WasslniColors.gold500,
                size: 50,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'وصّلني كابتن',
              style: TextStyle(
                color: WasslniColors.emerald800,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: WasslniColors.gold200.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: WasslniColors.gold500.withOpacity(0.4)),
              ),
              child: const Text(
                'شريك النجاح • 0% عمولة أول شهرين',
                style: TextStyle(
                  color: WasslniColors.gold900,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
