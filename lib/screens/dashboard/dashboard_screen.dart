import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../data/mock_data.dart';
import '../filieres/filieres_screen.dart';
import '../rapport/rapport_screen.dart';
import '../profil/profil_screen.dart';
import '../../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    _HomeTab(),
    _FilieresTab(),
    _RapportTab(),
    _ProfilTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

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
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      _userData = user;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: LeWayColors.background,
        body: Center(
          child: CircularProgressIndicator(color: LeWayColors.primary900),
        ),
      );
    }

    final prenom = _userData?['prenom'] ?? 'Bachelier';
    final nom = _userData?['nom'] ?? '';
    final avatar = '${prenom.isNotEmpty ? prenom[0] : 'B'}${nom.isNotEmpty ? nom[0] : ''}';
    final savedFilieres = filieres
        .where((f) => currentUser.filieresauvegardees.contains(f.idFiliere))
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
                      'Bonjour, $prenom ! 👋',
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/notifications'),
                      child: Stack(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          avatar,
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
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _statCard(
                    '${currentUser.progression}%',
                    'Progression',
                    'Questionnaire rempli',
                    Icons.compass_calibration_rounded,
                    LeWayColors.primary50,
                    LeWayColors.primary900,
                  ),
                  _statCard(
                    '${currentUser.filieresauvegardees.length}',
                    'Filières sauvées',
                    'Dans vos favoris',
                    Icons.bookmark_rounded,
                    LeWayColors.amber50,
                    LeWayColors.amber600,
                  ),
                  _statCard(
                    '${currentUser.scoreGlobal}/100',
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
                          '${currentUser.progression}%',
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
                        value: currentUser.progression / 100,
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
                          '${(currentUser.progression * 0.3).round()} questions répondues',
                          style: const TextStyle(
                            fontSize: 12,
                            color: LeWayColors.slate400,
                          ),
                        ),
                        Text(
                          '${(30 - (currentUser.progression * 0.3).round())} restantes',
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
                        onPressed: () =>
                            Navigator.pushNamed(context, '/questionnaire'),
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
                        onPressed: () =>
                            Navigator.pushNamed(context, '/conseiller'),
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
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _FiliereDetailBottomSheet(filiere: filiere),
        );
      },
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

// ==================== ONGLET FILIÈRES ====================
class _FilieresTab extends StatelessWidget {
  const _FilieresTab();

  @override
  Widget build(BuildContext context) {
    return const FilieresScreen();
  }
}

// ==================== ONGLET RAPPORT ====================
class _RapportTab extends StatelessWidget {
  const _RapportTab();

  @override
  Widget build(BuildContext context) {
    return const RapportScreen();
  }
}

// ==================== ONGLET PROFIL ====================
class _ProfilTab extends StatelessWidget {
  const _ProfilTab();

  @override
  Widget build(BuildContext context) {
    return const ProfilScreen();
  }
}

// ==================== DETAIL FILIÈRE BOTTOM SHEET ====================
class _FiliereDetailBottomSheet extends StatelessWidget {
  final dynamic filiere;
  const _FiliereDetailBottomSheet({required this.filiere});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: LeWayColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LeWayColors.slate200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: LeWayColors.primary100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(filiere.domaine,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: LeWayColors.primary900)),
                  ),
                  ...filiere.tags.map<Widget>((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: LeWayColors.slate100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag,
                            style: const TextStyle(
                                fontSize: 11,
                                color: LeWayColors.slate500)),
                      )),
                ],
              ),
              const SizedBox(height: 12),
              Text(filiere.nom,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: LeWayColors.primary900)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 14, color: LeWayColors.slate400),
                  const SizedBox(width: 4),
                  Text(filiere.duree,
                      style: const TextStyle(
                          fontSize: 12, color: LeWayColors.slate500)),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: LeWayColors.slate400),
                  const SizedBox(width: 4),
                  Text(filiere.ville,
                      style: const TextStyle(
                          fontSize: 12, color: LeWayColors.slate500)),
                  const SizedBox(width: 12),
                  const Icon(Icons.trending_up_rounded,
                      size: 14, color: LeWayColors.green600),
                  const SizedBox(width: 4),
                  Text('${filiere.tauxInsertion}% insertion',
                      style: const TextStyle(
                          fontSize: 12,
                          color: LeWayColors.green600,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _bigStatCard(
                          '${(filiere.salaireMedian / 1000).round()}k FCFA',
                          'Salaire médian',
                          LeWayColors.primary900)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _bigStatCard('${filiere.tauxInsertion}%',
                          'Taux d\'insertion', LeWayColors.green600)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _bigStatCard('${filiere.scoreMarche2030}/100',
                          'Score 2030', LeWayColors.amber600)),
                ],
              ),
              const SizedBox(height: 16),
              _sectionTitle('Description'),
              const SizedBox(height: 8),
              Text(filiere.description,
                  style: const TextStyle(
                      fontSize: 13,
                      color: LeWayColors.slate600,
                      height: 1.6)),
              const SizedBox(height: 16),
              _sectionTitle('Compétences requises'),
              const SizedBox(height: 8),
              ...filiere.competences.map<Widget>((comp) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: LeWayColors.slate100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 16, color: LeWayColors.green600),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(comp,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: LeWayColors.slate700))),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              _sectionTitle('Universités disponibles'),
              const SizedBox(height: 8),
              ...filiere.universites.map<Widget>((u) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: LeWayColors.primary50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school_rounded,
                              size: 16, color: LeWayColors.primary700),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(u,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: LeWayColors.slate700))),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              _sectionTitle('Débouchés professionnels'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filiere.debouches
                    .map<Widget>((d) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: LeWayColors.primary50,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: LeWayColors.primary100),
                          ),
                          child: Text(d,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: LeWayColors.primary900,
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: const Text('Partager'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: LeWayColors.slate600,
                        side:
                            const BorderSide(color: LeWayColors.slate200),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.bookmark_add_rounded,
                          size: 16),
                      label: const Text('Sauvegarder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LeWayColors.primary900,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _bigStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LeWayColors.slate100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, color: LeWayColors.slate500)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: LeWayColors.primary900));
  }
}