import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'tous';

  final List<Map<String, dynamic>> _notifs = [
    {
      'id': 'n1',
      'type': 'filiere',
      'titre': 'Nouvelle filière recommandée',
      'message': 'Basé sur votre profil mis à jour, la filière "Data Science & IA" correspond à 89% de vos compétences clés.',
      'date': '2026-04-22T10:00:00',
      'lue': false,
    },
    {
      'id': 'n2',
      'type': 'rdv',
      'titre': 'Rappel rendez-vous',
      'message': 'Votre rendez-vous avec Dr. Agbossou est prévu demain, vendredi 15 avril à 10h00. N\'oubliez pas de préparer vos questions.',
      'date': '2026-04-21T14:00:00',
      'lue': false,
    },
    {
      'id': 'n3',
      'type': 'emploi',
      'titre': 'Rapport marché emploi avril 2026',
      'message': 'Le secteur informatique au Bénin a enregistré +34% de recrutements au Q1 2026. L\'IA et le cloud computing sont les profils les plus recherchés.',
      'date': '2026-04-20T09:00:00',
      'lue': false,
    },
    {
      'id': 'n4',
      'type': 'filiere',
      'titre': 'Mise à jour filière Génie Informatique',
      'message': 'L\'UAC a ouvert une nouvelle option "Cybersécurité & Réseaux" pour la rentrée 2026-2027. Les inscriptions sont ouvertes.',
      'date': '2026-04-18T11:30:00',
      'lue': true,
    },
    {
      'id': 'n5',
      'type': 'systeme',
      'titre': 'Questionnaire incomplet',
      'message': 'Vous avez complété 85% de votre questionnaire d\'orientation. Terminez-le pour obtenir des recommandations encore plus précises.',
      'date': '2026-04-15T16:00:00',
      'lue': true,
    },
    {
      'id': 'n6',
      'type': 'rdv',
      'titre': 'Confirmation rendez-vous',
      'message': 'Votre rendez-vous avec Prof. Zannou le 20 avril à 14h30 a été confirmé.',
      'date': '2026-04-14T10:00:00',
      'lue': true,
    },
    {
      'id': 'n7',
      'type': 'emploi',
      'titre': 'Nouvelle offre de stage',
      'message': 'L\'entreprise SOGECI Bénin recrute des stagiaires en développement web. Profil requis: L2 informatique minimum. Délai: 31 mai.',
      'date': '2026-04-12T09:00:00',
      'lue': true,
    },
  ];

  final Map<String, IconData> _typeIcons = {
    'filiere': Icons.school_rounded,
    'rdv': Icons.calendar_today_rounded,
    'emploi': Icons.trending_up_rounded,
    'systeme': Icons.settings_rounded,
  };

  final Map<String, Color> _typeBgColors = {
    'filiere': LeWayColors.primary100,
    'rdv': LeWayColors.green50,
    'emploi': LeWayColors.amber50,
    'systeme': LeWayColors.slate100,
  };

  final Map<String, Color> _typeIconColors = {
    'filiere': LeWayColors.primary700,
    'rdv': LeWayColors.green600,
    'emploi': LeWayColors.amber600,
    'systeme': LeWayColors.slate500,
  };

  final Map<String, String> _typeLabels = {
    'filiere': 'Filière',
    'rdv': 'Rendez-vous',
    'emploi': 'Marché emploi',
    'systeme': 'Système',
  };

  List<Map<String, dynamic>> get _filtered => _notifs
      .where((n) => _filter == 'tous' || n['type'] == _filter)
      .toList();

  int get _unreadCount => _notifs.where((n) => !n['lue']).length;

  void _markRead(String id) {
    setState(() {
      final i = _notifs.indexWhere((n) => n['id'] == id);
      if (i != -1) _notifs[i]['lue'] = true;
    });
  }

  void _markAllRead() {
    setState(() {
      for (var n in _notifs) {
        n['lue'] = true;
      }
    });
  }

  void _deleteNotif(String id) {
    setState(() => _notifs.removeWhere((n) => n['id'] == id));
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    const mois = [
      'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${date.day} ${mois[date.month - 1]} · ${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            if (_unreadCount > 0)
                              Text(
                                '$_unreadCount non lue${_unreadCount > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_unreadCount > 0)
                        GestureDetector(
                          onTap: _markAllRead,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.done_all_rounded,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Tout lu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
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

          // Filtres
          SliverToBoxAdapter(
  child: SizedBox(
    height: 52,
    child: ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white,
          Colors.white,
          Colors.transparent,
        ],
        stops: [0.0, 0.8, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        children: [
          _filterChip('tous', 'Toutes'),
          _filterChip('filiere', 'Filière'),
          _filterChip('rdv', 'Rendez-vous'),
          _filterChip('emploi', 'Marché emploi'),
          _filterChip('systeme', 'Système'),
          const SizedBox(width: 16),
        ],
      ),
    ),
  ),
),

          // Liste notifications
          _filtered.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(60),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: LeWayColors.slate100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.notifications_none_rounded,
                              size: 32, color: LeWayColors.slate400),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucune notification',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: LeWayColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Vous êtes à jour !',
                          style: TextStyle(
                            fontSize: 13,
                            color: LeWayColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notif = _filtered[index];
                        return _notifCard(notif);
                      },
                      childCount: _filtered.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _filterChip(String type, String label) {
    final isSelected = _filter == type;
    final count = type == 'tous'
        ? null
        : _notifs.where((n) => n['type'] == type).length;

    return GestureDetector(
      onTap: () => setState(() => _filter = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? LeWayColors.primary900 : LeWayColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? LeWayColors.primary900 : LeWayColors.slate200,
          ),
        ),
        child: Text(
          count != null ? '$label ($count)' : label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : LeWayColors.slate600,
          ),
        ),
      ),
    );
  }

  Widget _notifCard(Map<String, dynamic> notif) {
    final isLue = notif['lue'] as bool;
    final type = notif['type'] as String;

    return Dismissible(
      key: Key(notif['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: LeWayColors.red50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded,
            color: LeWayColors.red600, size: 24),
      ),
      onDismissed: (_) => _deleteNotif(notif['id']),
      child: GestureDetector(
        onTap: () => _markRead(notif['id']),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: LeWayColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLue ? LeWayColors.slate100 : LeWayColors.primary100,
              width: isLue ? 1 : 1.5,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône type
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _typeBgColors[type],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _typeIcons[type],
                  size: 20,
                  color: _typeIconColors[type],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif['titre'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isLue
                                  ? LeWayColors.slate700
                                  : LeWayColors.primary900,
                            ),
                          ),
                        ),
                        if (!isLue)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: LeWayColors.primary900,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Badge type
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _typeBgColors[type],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _typeLabels[type]!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _typeIconColors[type],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif['message'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: LeWayColors.slate500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(notif['date']),
                          style: const TextStyle(
                            fontSize: 11,
                            color: LeWayColors.slate400,
                          ),
                        ),
                        Row(
                          children: [
                            if (!isLue)
                              GestureDetector(
                                onTap: () => _markRead(notif['id']),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: LeWayColors.primary50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.check_rounded,
                                          size: 12,
                                          color: LeWayColors.primary700),
                                      SizedBox(width: 4),
                                      Text(
                                        'Marquer lu',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: LeWayColors.primary700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _deleteNotif(notif['id']),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: LeWayColors.red50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.delete_outline_rounded,
                                    size: 14, color: LeWayColors.red600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}