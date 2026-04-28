import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() {
  runApp(const LeWayApp());
}

class LeWayApp extends StatelessWidget {
  const LeWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LÉWAY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2D4EC8),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      },
    );
  }
}