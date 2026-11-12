import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'screens/driver_splash_screen.dart';

void main() {
  runApp(const WasslniDriverApp());
}

class WasslniDriverApp extends StatelessWidget {
  const WasslniDriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وصّلني كابتن | Wasslni Captain',
      debugShowCheckedModeBanner: false,
      theme: WasslniThemeData.darkTheme,
      locale: const Locale('ar', 'MA'), // Moroccan Arabic RTL default
      supportedLocales: const [
        Locale('ar', 'MA'), // Moroccan Darija
        Locale('fr', 'FR'), // French
        Locale('ar', 'SA'), // Standard Arabic
        Locale('ber', 'MA'), // Tamazight
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const DriverSplashScreen(),
    );
  }
}

