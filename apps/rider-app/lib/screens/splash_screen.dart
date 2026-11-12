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
    Future.delayed(const Duration(seconds: 2), () {
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
      backgroundColor: WasslniColors.darkCanvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand Logo container with Moroccan Emerald & Gold
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: WasslniColors.emerald800,
                shape: BoxShape.circle,
                border: Border.all(color: WasslniColors.gold500, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: WasslniColors.emerald800.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                color: WasslniColors.gold500,
                size: 46,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'وصّلني',
              style: TextStyle(
                color: WasslniColors.textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'WASSLNI • النقل المغربي الحر',
              style: TextStyle(
                color: WasslniColors.gold500,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

