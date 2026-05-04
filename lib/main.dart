import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/questionnaire/questionnaire_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

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
        colorSchemeSeed: const Color(0xFF1E3A8A),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/dashboard',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp': (context) => const OtpScreen(),
        '/questionnaire': (context) => const QuestionnaireScreen(),
        '/rapport': (context) => const Scaffold(
              body: Center(child: Text('Rapport — bientôt')),
            ),
        '/dashboard': (context) => const DashboardScreen(),
        '/filieres': (context) => const Scaffold(
              body: Center(child: Text('Filières — bientôt')),
            ),
        '/profil': (context) => const Scaffold(
              body: Center(child: Text('Profil — bientôt')),
            ),
        '/home': (context) => const DevNavigator(),
      },
    );
  }
}

class DevNavigator extends StatelessWidget {
  const DevNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('LÉWAY — Dev Navigator'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Écrans disponibles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            _navButton(context, '🚀 Splash Screen', '/'),
            _navButton(context, '👋 Onboarding', '/onboarding'),
            _navButton(context, '🔐 Login', '/login'),
            _navButton(context, '📝 Register', '/register'),
            _navButton(context, '🔢 OTP', '/otp'),
            _navButton(context, '📋 Questionnaire', '/questionnaire'),
            _navButton(context, '🏠 Dashboard', '/dashboard'),
            _navButton(context, '🎓 Filières', '/filieres'),
            _navButton(context, '📊 Rapport', '/rapport'),
            _navButton(context, '👤 Profil', '/profil'),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, route),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}