import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
            // Brand Logo container with Moroccan Emerald & Gold
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
                    blurRadius: 28,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                color: WasslniColors.gold500,
                size: 50,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'وصّلني',
              style: TextStyle(
                color: WasslniColors.emerald800,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: WasslniColors.gold200.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: WasslniColors.gold500.withOpacity(0.4)),
              ),
              child: const Text(
                'WASSLNI • النقل المغربي الحر',
                style: TextStyle(
                  color: WasslniColors.gold900,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
