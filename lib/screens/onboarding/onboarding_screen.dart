import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.psychology_rounded,
      'title': 'Découvre ton profil',
      'title_en': 'Discover your profile',
      'subtitle':
          'Réponds à 28 questions et identifie tes forces naturelles grâce au test RIASEC',
      'subtitle_en':
          'Answer 28 questions and identify your natural strengths with the RIASEC test',
      'color': Color(0xFF2D4EC8),
    },
    {
      'icon': Icons.school_rounded,
      'title': 'Explore les filières',
      'title_en': 'Explore fields of study',
      'subtitle':
          'Accède aux données réelles des universités béninoises : salaires, taux d\'insertion, durée',
      'subtitle_en':
          'Access real data from Beninese universities: salaries, insertion rates, duration',
      'color': Color(0xFF1A2F9C),
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'Reçois ta recommandation',
      'title_en': 'Get your recommendation',
      'subtitle':
          'Notre IA analyse ton profil et te propose les filières qui correspondent le mieux à toi',
      'subtitle_en':
          'Our AI analyzes your profile and suggests the fields that suit you best',
      'color': Color(0xFF0D1F6E),
    },
  ];

  bool _isFrench = true;

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _buildPage(page);
            },
          ),

          // Header : Skip + Langue
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Switch langue
                  GestureDetector(
                    onTap: () => setState(() => _isFrench = !_isFrench),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.4), width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'FR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _isFrench
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                              width: 1,
                              height: 12,
                              color: Colors.white.withOpacity(0.4)),
                          const SizedBox(width: 6),
                          Text(
                            'EN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: !_isFrench
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Skip
                  GestureDetector(
                    onTap: _skip,
                    child: Text(
                      _isFrench ? 'Passer' : 'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom : dots + bouton
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Bouton suivant
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: LeWayColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? (_isFrench ? 'Commencer' : 'Get started')
                              : (_isFrench ? 'Suivant' : 'Next'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Déjà un compte
                    GestureDetector(
                      onTap: _skip,
                      child: Text(
                        _isFrench
                            ? 'J\'ai déjà un compte'
                            : 'I already have an account',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            page['color'] as Color,
            (page['color'] as Color).withOpacity(0.85),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              // Icône
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 0.5),
                ),
                child: Icon(
                  page['icon'] as IconData,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              // Titre
              Text(
                _isFrench ? page['title'] : page['title_en'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              // Sous-titre
              Text(
                _isFrench ? page['subtitle'] : page['subtitle_en'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}