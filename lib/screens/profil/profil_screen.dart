import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../data/mock_data.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _editing = false;
  bool _isFrench = true;
  bool _loading = true;
  Map<String, dynamic>? _userData;

  final Map<String, bool> _notifs = {
    'nouvelles': true,
    'rdv': true,
    'emploi': false,
    'systeme': true,
  };

  final List<Map<String, String>> _notifsConfig = [
    {
      'key': 'nouvelles',
      'label': 'Nouvelles filières correspondantes',
      'desc': 'Quand une nouvelle filière correspond à votre profil',
    },
    {
      'key': 'rdv',
      'label': 'Rappels de rendez-vous',
      'desc': '24h avant chaque RDV avec un conseiller',
    },
    {
      'key': 'emploi',
      'label': 'Mises à jour marché emploi',
      'desc': 'Rapports mensuels sur le marché au Bénin',
    },
    {
      'key': 'systeme',
      'label': 'Notifications système',
      'desc': 'Mises à jour de la plateforme',
    },
  ];

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
    final email = _userData?['email'] ?? '';
    final telephone = _userData?['telephone'] ?? '';
    final serieBac = _userData?['serie_bac'] ?? '';
    final avatar = '${prenom.isNotEmpty ? prenom[0] : 'B'}${nom.isNotEmpty ? nom[0] : ''}';

    return Scaffold(
      backgroundColor: LeWayColors.background,
      body: CustomScrollView(
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
                  const Text(
                    'Mon profil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isFrench = !_isFrench),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text('FR',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _isFrench
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5))),
                              const SizedBox(width: 6),
                              Container(
                                  width: 1,
                                  height: 12,
                                  color: Colors.white.withOpacity(0.4)),
                              const SizedBox(width: 6),
                              Text('EN',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: !_isFrench
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _editing = !_editing),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _editing
                                ? LeWayColors.green600
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _editing
                                    ? Icons.save_rounded
                                    : Icons.edit_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _editing ? 'Sauvegarder' : 'Modifier',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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

                // Carte infos personnelles
                Container(
                  decoration: BoxDecoration(
                    color: LeWayColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: LeWayColors.slate100),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: LeWayColors.primary900,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                avatar,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$prenom $nom',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: LeWayColors.primary900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded,
                                        size: 14,
                                        color: LeWayColors.slate400),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Bénin',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: LeWayColors.slate500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (serieBac.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: LeWayColors.primary50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Série $serieBac',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: LeWayColors.primary900,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildField('Prénom', prenom,
                          Icons.person_outline_rounded),
                      _buildField('Nom', nom,
                          Icons.person_outline_rounded),
                      _buildField('Email', email,
                          Icons.email_outlined),
                      _buildField('Téléphone', telephone,
                          Icons.phone_outlined),
                      _buildField('Série BAC', serieBac,
                          Icons.school_outlined),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Résumé psychométrique — garde les données mockées pour l'instant
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
                        'Résumé psychométrique',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: LeWayColors.primary900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...currentUser.profilPsycho.entries.map((entry) {
                        final color = entry.value >= 80
                            ? LeWayColors.green600
                            : entry.value >= 60
                                ? LeWayColors.primary900
                                : LeWayColors.amber600;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: LeWayColors.slate100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: LeWayColors.slate700,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value}/100',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: entry.value / 100,
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(color),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: LeWayColors.primary900,
                            side: const BorderSide(
                                color: LeWayColors.primary900),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Voir résultats complets'),
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

                // Notifications
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
                        'Paramètres notifications',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: LeWayColors.primary900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._notifsConfig.map((notif) {
                        final key = notif['key']!;
                        final isOn = _notifs[key] ?? false;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                isOn
                                    ? Icons.notifications_rounded
                                    : Icons.notifications_off_rounded,
                                color: isOn
                                    ? LeWayColors.primary700
                                    : LeWayColors.slate400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notif['label']!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: LeWayColors.slate700,
                                      ),
                                    ),
                                    Text(
                                      notif['desc']!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: LeWayColors.slate400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(
                                    () => _notifs[key] = !isOn),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  width: 44,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isOn
                                        ? LeWayColors.primary900
                                        : LeWayColors.slate200,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: AnimatedAlign(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    alignment: isOn
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Refaire le questionnaire
                Container(
                  decoration: BoxDecoration(
                    color: LeWayColors.amber50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Refaire le questionnaire',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Vos réponses ont évolué ? Mettez à jour votre profil pour de meilleures recommandations.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB45309),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/questionnaire'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LeWayColors.amber600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh_rounded, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Recommencer',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Déconnexion
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () async {
                      await StorageService.clearToken();
                      AuthService.clearUser();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: LeWayColors.red600,
                      side: const BorderSide(color: LeWayColors.red600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Se déconnecter',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: LeWayColors.slate400,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          _editing
              ? TextFormField(
                  initialValue: value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: LeWayColors.slate700,
                  ),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(icon, size: 18, color: LeWayColors.slate400),
                    filled: true,
                    fillColor: LeWayColors.slate100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                )
              : Row(
                  children: [
                    Icon(icon, size: 16, color: LeWayColors.slate400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: LeWayColors.slate700,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}