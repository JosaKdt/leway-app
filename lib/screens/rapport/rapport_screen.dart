import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/colors.dart';
import '../../data/mock_data.dart';

class RapportScreen extends StatelessWidget {
  const RapportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    // Top 5 filières mockées avec scores décomposés
    final List<Map<String, dynamic>> topFilieres = [
      {
        'filiere': filieres[0],
        'score_global': 91,
        'score_riasec': 88,
        'score_marche': 95,
        'score_ia': 92,
        'tendance_ia': 'croissance',
        'justification': 'Votre profil Investigateur dominant (I) correspond parfaitement au Génie Informatique. Votre rigueur analytique et curiosité intellectuelle sont les atouts clés de cette filière en forte croissance au Bénin.',
      },
      {
        'filiere': filieres[1],
        'score_global': 83,
        'score_riasec': 79,
        'score_marche': 94,
        'score_ia': 72,
        'tendance_ia': 'stable',
        'justification': 'Votre dimension Sociale (S) élevée vous oriente vers la Médecine. Le contact humain et l\'empathie sont au cœur de ce métier. Taux d\'insertion exceptionnel au Bénin.',
      },
      {
        'filiere': filieres[3],
        'score_global': 74,
        'score_riasec': 71,
        'score_marche': 79,
        'score_ia': 68,
        'tendance_ia': 'transformation',
        'justification': 'Votre profil Entrepreneur (E) s\'aligne avec l\'Économie & Gestion. La digitalisation des entreprises béninoises crée de nouvelles opportunités dans ce domaine.',
      },
      {
        'filiere': filieres[2],
        'score_global': 68,
        'score_riasec': 65,
        'score_marche': 71,
        'score_ia': 74,
        'tendance_ia': 'stable',
        'justification': 'Votre rigueur (C) et sens de l\'organisation correspondent au Droit. Le cadre OHADA offre des perspectives solides pour les juristes au Bénin.',
      },
      {
        'filiere': filieres[4],
        'score_global': 61,
        'score_riasec': 58,
        'score_marche': 82,
        'score_ia': 85,
        'tendance_ia': 'croissance',
        'justification': 'L\'Agronomie correspond à votre profil Réaliste (R). Le secteur agricole béninois se digitalise rapidement — une opportunité unique pour les profils polyvalents.',
      },
    ];

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rapport d\'orientation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Basé sur vos ${(user.progression * 0.28).round()} réponses au questionnaire RIASEC',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: Color(0xFFFBBF24), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Profil dominant : Investigateur (I)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

                // ========== RADAR CHART RIASEC 6 AXES ==========
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
                        'Profil RIASEC',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: LeWayColors.primary900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Vos 6 dimensions psychologiques',
                        style: TextStyle(
                          fontSize: 12,
                          color: LeWayColors.slate500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: RadarChart(
                          RadarChartData(
                            radarShape: RadarShape.polygon,
                            tickCount: 4,
                            gridBorderData: const BorderSide(
                                color: LeWayColors.slate100, width: 1),
                            radarBorderData: const BorderSide(
                                color: LeWayColors.slate200, width: 1),
                            tickBorderData: const BorderSide(
                                color: Colors.transparent),
                            titleTextStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: LeWayColors.slate600,
                            ),
                            getTitle: (index, angle) {
                              const titles = [
                                'R\nRéaliste',
                                'I\nInvestigateur',
                                'A\nArtistique',
                                'S\nSocial',
                                'E\nEntrepreneur',
                                'C\nConventionnel',
                              ];
                              return RadarChartTitle(
                                text: titles[index],
                                angle: 0,
                              );
                            },
                            dataSets: [
                              RadarDataSet(
                                fillColor: LeWayColors.primary900
                                    .withOpacity(0.15),
                                borderColor: LeWayColors.primary900,
                                borderWidth: 2,
                                entryRadius: 4,
                                dataEntries: const [
                                  RadarEntry(value: 70), // R
                                  RadarEntry(value: 88), // I — dominant
                                  RadarEntry(value: 55), // A
                                  RadarEntry(value: 65), // S
                                  RadarEntry(value: 72), // E
                                  RadarEntry(value: 80), // C
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Barres RIASEC
                      ...[
                        {'label': 'R — Réaliste', 'value': 70, 'desc': 'Concret, manuel, technique'},
                        {'label': 'I — Investigateur', 'value': 88, 'desc': 'Analyser, chercher, comprendre', 'dominant': true},
                        {'label': 'A — Artistique', 'value': 55, 'desc': 'Créer, imaginer, exprimer'},
                        {'label': 'S — Social', 'value': 65, 'desc': 'Aider, communiquer, enseigner'},
                        {'label': 'E — Entrepreneur', 'value': 72, 'desc': 'Diriger, convaincre, entreprendre'},
                        {'label': 'C — Conventionnel', 'value': 80, 'desc': 'Organiser, structurer, planifier'},
                      ].map((item) {
                        final isDominant = item['dominant'] == true;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item['label'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isDominant
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isDominant
                                              ? LeWayColors.primary900
                                              : LeWayColors.slate600,
                                        ),
                                      ),
                                      if (isDominant) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: LeWayColors.primary900,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Dominant',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    '${item['value']}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDominant
                                          ? LeWayColors.primary900
                                          : LeWayColors.slate500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: LeWayColors.slate400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (item['value'] as int) / 100,
                                  backgroundColor: LeWayColors.slate100,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDominant
                                        ? LeWayColors.primary900
                                        : LeWayColors.slate100,
                                  ),
                                  minHeight: 6,
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

                // ========== TOP 5 FILIÈRES ==========
                const Text(
                  'Top 5 filières recommandées',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: LeWayColors.primary900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Basé sur votre profil RIASEC, les données du marché béninois et l\'impact IA',
                  style: TextStyle(
                    fontSize: 12,
                    color: LeWayColors.slate500,
                  ),
                ),
                const SizedBox(height: 12),

                ...topFilieres.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final filiere = item['filiere'];
                  return _filiereCard(context, index, item, filiere);
                }),

                const SizedBox(height: 16),

                // Bouton télécharger PDF
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text(
                      'Télécharger en PDF',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: LeWayColors.primary900,
                      side: const BorderSide(
                          color: LeWayColors.primary900, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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

  Widget _filiereCard(BuildContext context, int index,
      Map<String, dynamic> item, dynamic filiere) {
    final scoreGlobal = item['score_global'] as int;
    final scoreRiasec = item['score_riasec'] as int;
    final scoreMarche = item['score_marche'] as int;
    final scoreIa = item['score_ia'] as int;
    final tendanceIa = item['tendance_ia'] as String;
    final justification = item['justification'] as String;

    final medals = ['🥇', '🥈', '🥉', '4️⃣', '5️⃣'];
    final medalColors = [
      const Color(0xFFFBBF24),
      LeWayColors.slate400,
      LeWayColors.amber600,
      LeWayColors.slate100,
      LeWayColors.slate100,
    ];

    // Badge tendance IA
    Color iaBadgeColor;
    Color iaBadgeBg;
    String iaLabel;
    IconData iaIcon;
    switch (tendanceIa) {
      case 'croissance':
        iaBadgeColor = LeWayColors.green600;
        iaBadgeBg = LeWayColors.green50;
        iaLabel = 'IA : En croissance';
        iaIcon = Icons.trending_up_rounded;
        break;
      case 'stable':
        iaBadgeColor = LeWayColors.primary700;
        iaBadgeBg = LeWayColors.primary50;
        iaLabel = 'IA : Stable';
        iaIcon = Icons.trending_flat_rounded;
        break;
      case 'transformation':
        iaBadgeColor = LeWayColors.amber600;
        iaBadgeBg = LeWayColors.amber50;
        iaLabel = 'IA : En transformation';
        iaIcon = Icons.autorenew_rounded;
        break;
      default:
        iaBadgeColor = LeWayColors.red600;
        iaBadgeBg = LeWayColors.red50;
        iaLabel = 'IA : Fortement affecté';
        iaIcon = Icons.trending_down_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: LeWayColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: index == 0
              ? LeWayColors.primary900.withOpacity(0.3)
              : LeWayColors.slate100,
          width: index == 0 ? 2 : 1,
        ),
        boxShadow: index == 0
            ? [
                BoxShadow(
                  color: LeWayColors.primary900.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header carte
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Médaille
                    Text(medals[index], style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filiere.nom,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: LeWayColors.primary900,
                            ),
                          ),
                          Text(
                            filiere.domaine,
                            style: const TextStyle(
                              fontSize: 11,
                              color: LeWayColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Score global
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? LeWayColors.primary900
                            : LeWayColors.slate100,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$scoreGlobal%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: index == 0
                                  ? Colors.white
                                  : LeWayColors.primary900,
                            ),
                          ),
                          Text(
                            'score',
                            style: TextStyle(
                              fontSize: 8,
                              color: index == 0
                                  ? Colors.white.withOpacity(0.8)
                                  : LeWayColors.slate400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Décomposition score en 3 barres
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: LeWayColors.slate100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _scoreBar('RIASEC', scoreRiasec, '60%',
                          LeWayColors.primary900),
                      const SizedBox(height: 8),
                      _scoreBar('Marché', scoreMarche, '25%',
                          LeWayColors.green600),
                      const SizedBox(height: 8),
                      _scoreBar(
                          'Impact IA', scoreIa, '15%', LeWayColors.amber600),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Données marché
                Row(
                  children: [
                    _dataChip(
                      Icons.payments_rounded,
                      '${(filiere.salaireMedian / 1000).round()}k FCFA/mois',
                      LeWayColors.amber50,
                      LeWayColors.amber600,
                    ),
                    const SizedBox(width: 8),
                    _dataChip(
                      Icons.trending_up_rounded,
                      '${filiere.tauxInsertion}% insertion',
                      LeWayColors.green50,
                      LeWayColors.green600,
                    ),
                    const SizedBox(width: 8),
                    _dataChip(
                      Icons.schedule_rounded,
                      filiere.duree,
                      LeWayColors.primary50,
                      LeWayColors.primary700,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Badge tendance IA
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: iaBadgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(iaIcon, size: 14, color: iaBadgeColor),
                      const SizedBox(width: 6),
                      Text(
                        iaLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: iaBadgeColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Justification LLM
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index == 0
                        ? LeWayColors.primary50
                        : LeWayColors.slate100,
                    borderRadius: BorderRadius.circular(12),
                    border: index == 0
                        ? Border.all(
                            color: LeWayColors.primary900.withOpacity(0.2))
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 14,
                            color: index == 0
                                ? LeWayColors.primary900
                                : LeWayColors.slate400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Analyse IA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: index == 0
                                  ? LeWayColors.primary900
                                  : LeWayColors.slate500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        justification,
                        style: TextStyle(
                          fontSize: 12,
                          color: index == 0
                              ? LeWayColors.primary900
                              : LeWayColors.slate600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBar(
      String label, int value, String weight, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: LeWayColors.slate600,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($weight)',
          style: const TextStyle(
            fontSize: 9,
            color: LeWayColors.slate400,
          ),
        ),
      ],
    );
  }

  Widget _dataChip(
      IconData icon, String label, Color bg, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}