import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../data/mock_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    _FilieresTab(),
    _RapportTab(),
    _ProfilTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LeWayColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LeWayColors.white,
          border: Border(
            top: BorderSide(color: LeWayColors.slate200, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.grid_view_rounded, 'Accueil'),
                _navItem(1, Icons.school_rounded, 'Filières'),
                _navItem(2, Icons.bar_chart_rounded, 'Résultats'),
                _navItem(3, Icons.person_rounded, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? LeWayColors.primary50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? LeWayColors.primary900 : LeWayColors.slate400,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? LeWayColors.primary900 : LeWayColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== ONGLET ACCUEIL ====================
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final savedFilieres = filieres
        .where((f) => user.filieresauvegardees.contains(f.id))
        .toList();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LeWayColors.headerGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${user.prenom} ! 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFormattedDate(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      user.avatar,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Stats cards 2x2
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _statCard(
                    '${user.progression}%',
                    'Progression',
                    'Questionnaire rempli',
                    Icons.compass_calibration_rounded,
                    LeWayColors.primary50,
                    LeWayColors.primary900,
                  ),
                  _statCard(
                    '${user.filieresauvegardees.length}',
                    'Filières sauvées',
                    'Dans vos favoris',
                    Icons.bookmark_rounded,
                    LeWayColors.amber50,
                    LeWayColors.amber600,
                  ),
                  _statCard(
                    '${user.scoreGlobal}/100',
                    'Score global',
                    'Profil psychométrique',
                    Icons.trending_up_rounded,
                    LeWayColors.green50,
                    LeWayColors.green600,
                  ),
                  _statCard(
                    '15 avr.',
                    'Prochain RDV',
                    'Dr. Agbossou — 10h00',
                    Icons.calendar_today_rounded,
                    const Color(0xFFF3E8FF),
                    const Color(0xFF7C3AED),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progression questionnaire
              Container(
                decoration: BoxDecoration(
                  color: LeWayColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: LeWayColors.slate100),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progression du questionnaire',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: LeWayColors.primary900,
                          ),
                        ),
                        Text(
                          '${user.progression}%',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: LeWayColors.primary900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: user.progression / 100,
                        backgroundColor: LeWayColors.slate100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            LeWayColors.primary900),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(user.progression * 0.3).round()} questions répondues',
                          style: const TextStyle(
                            fontSize: 12,
                            color: LeWayColors.slate400,
                          ),
                        ),
                        Text(
                          '${(30 - (user.progression * 0.3).round())} restantes',
                          style: const TextStyle(
                            fontSize: 12,
                            color: LeWayColors.slate400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/questionnaire'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LeWayColors.primary900,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continuer le questionnaire',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Filières sauvegardées
              Container(
                decoration: BoxDecoration(
                  color: LeWayColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: LeWayColors.slate100),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filières sauvegardées',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: LeWayColors.primary900,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Voir tout',
                            style: TextStyle(
                              fontSize: 13,
                              color: LeWayColors.primary900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...savedFilieres.map((f) => _filiereItem(context, f)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Activité récente
              Container(
                decoration: BoxDecoration(
                  color: LeWayColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: LeWayColors.slate100),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activité récente',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: LeWayColors.primary900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...activitesRecentes.map((act) => _activityItem(act)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bannière RDV conseiller
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            color: Color(0xFFFBBF24), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Prendre RDV avec un conseiller',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Dr. Emmanuel Agbossou disponible vendredi 15 avril à 10h00',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Réserver maintenant',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label, String sub, IconData icon,
      Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: LeWayColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LeWayColors.slate100),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: LeWayColors.primary900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: LeWayColors.slate400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filiereItem(BuildContext context, filiere) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LeWayColors.slate100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: LeWayColors.primary100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school_rounded,
                  size: 18, color: LeWayColors.primary700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filiere.nom,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: LeWayColors.slate800,
                    ),
                  ),
                  Text(
                    '${filiere.tauxInsertion}% insertion · ${(filiere.salaireMedian / 1000).round()}k FCFA',
                    style: const TextStyle(
                      fontSize: 11,
                      color: LeWayColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: LeWayColors.slate400),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(Map<String, dynamic> act) {
    IconData icon;
    Color color;
    switch (act['icon']) {
      case 'check':
        icon = Icons.check_circle_rounded;
        color = LeWayColors.green600;
        break;
      case 'bookmark':
        icon = Icons.bookmark_rounded;
        color = LeWayColors.primary700;
        break;
      case 'calendar':
        icon = Icons.calendar_today_rounded;
        color = LeWayColors.amber600;
        break;
      default:
        icon = Icons.trending_up_rounded;
        color = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: LeWayColors.slate100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act['action'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: LeWayColors.slate700,
                  ),
                ),
                Text(
                  act['time'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: LeWayColors.slate400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const jours = [
      'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'
    ];
    const mois = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${jours[now.weekday - 1]} ${now.day} ${mois[now.month - 1]} ${now.year}';
  }
}

// ==================== ONGLET FILIÈRES (placeholder) ====================
class _FilieresTab extends StatelessWidget {
  const _FilieresTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: LeWayColors.background,
      body: Center(
        child: Text(
          'Filières — bientôt',
          style: TextStyle(color: LeWayColors.slate500),
        ),
      ),
    );
  }
}

// ==================== ONGLET RAPPORT (placeholder) ====================
class _RapportTab extends StatelessWidget {
  const _RapportTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: LeWayColors.background,
      body: Center(
        child: Text(
          'Résultats — bientôt',
          style: TextStyle(color: LeWayColors.slate500),
        ),
      ),
    );
  }
}

// ==================== ONGLET PROFIL (placeholder) ====================
class _ProfilTab extends StatelessWidget {
  const _ProfilTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: LeWayColors.background,
      body: Center(
        child: Text(
          'Profil — bientôt',
          style: TextStyle(color: LeWayColors.slate500),
        ),
      ),
    );
  }
}