import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const WasslniRiderApp());
}

class WasslniRiderApp extends StatelessWidget {
  const WasslniRiderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وصّلني | Wasslni',
      debugShowCheckedModeBanner: false,
      theme: WasslniThemeData.darkTheme,
      locale: const Locale('ar', 'MA'), // Moroccan Arabic RTL default
      supportedLocales: const [
        Locale('ar', 'MA'), // Moroccan Darija
        Locale('fr', 'FR'), // French
        Locale('ar', 'SA'), // Standard Arabic
        Locale('ber', 'MA'), // Tamazight Tifinagh
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}

