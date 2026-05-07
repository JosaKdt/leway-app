import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/colors.dart';
import '../../models/filiere.dart';
import '../../services/filiere_service.dart';

class ComparateurScreen extends StatefulWidget {
  const ComparateurScreen({super.key});

  @override
  State<ComparateurScreen> createState() => _ComparateurScreenState();
}

class _ComparateurScreenState extends State<ComparateurScreen> {
  List<Filiere> _selected = [];
  List<Filiere> _allFilieres = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showDropdown = false;

  final List<Color> _colors = [
    LeWayColors.primary900,
    LeWayColors.amber600,
    LeWayColors.green600,
  ];

  @override
  void initState() {
    super.initState();
    _loadFilieres();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFilieres() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final filieres = await FiliereService.getFilieres();
      setState(() {
        _allFilieres = filieres;
        // Pré-sélectionner les 2 premières si dispo
        if (filieres.length >= 2) {
          _selected = [filieres[0], filieres[1]];
        } else if (filieres.length == 1) {
          _selected = [filieres[0]];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les filières.\nVérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  List<Filiere> get _suggestions => _allFilieres.where((f) {
        // Exclure celles déjà sélectionnées (comparaison par idFiliere)
        final notSelected =
            !_selected.any((s) => s.idFiliere == f.idFiliere);
        final matchQuery = _query.isEmpty ||
            f.nom.toLowerCase().contains(_query.toLowerCase());
        return notSelected && matchQuery;
      }).toList();

  void _addFiliere(Filiere f) {
    if (_selected.length < 3) {
      setState(() {
        _selected.add(f);
        _query = '';
        _showDropdown = false;
        _searchController.clear();
      });
    }
  }

  void _removeFiliere(String idFiliere) {
    setState(() =>
        _selected.removeWhere((f) => f.idFiliere == idFiliere));
  }

  /// Radar entries : 5 axes normalisés sur 100
  List<RadarEntry> _radarEntries(Filiere f) {
    return [
      // Taux d'insertion (déjà en %)
      RadarEntry(value: (f.tauxInsertion ?? 0).clamp(0, 100).toDouble()),
      // Salaire normalisé (ex: 500 000 FCFA → 100)
      RadarEntry(
          value: ((f.salaireMedianP50 ?? 0) / 5000).clamp(0, 100).toDouble()),
      // Alignement curricula-marché (0.0 – 1.0 → 0 – 100)
      RadarEntry(
          value: ((f.tendanceCurriculaMarche ?? 0) * 100)
              .clamp(0, 100)
              .toDouble()),
      // Nombre d'universités (cap à 5 → 100)
      RadarEntry(
          value: (f.universites.length * 20).clamp(0, 100).toDouble()),
      // Nombre de débouchés (cap à 7 → 100)
      RadarEntry(
          value: (f.debouches.length * 15).clamp(0, 100).toDouble()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Cas chargement initial
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Cas erreur réseau
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: LeWayColors.slate400),
              const SizedBox(height: 16),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: LeWayColors.slate500)),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _loadFilieres,
                  child: const Text('Réessayer')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: LeWayColors.background,
      body: GestureDetector(
        onTap: () => setState(() => _showDropdown = false),
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LeWayColors.headerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding:
                    const EdgeInsets.fromLTRB(20, 56, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comparateur de filières',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comparez jusqu\'à 3 filières côte à côte',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Corps ─────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Chips filières sélectionnées + bouton ajouter ──────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._selected.asMap().entries.map((entry) {
                        final i = entry.key;
                        final f = entry.value;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _colors[i].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: _colors[i], width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _colors[i],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                f.nom.length > 20
                                    ? '${f.nom.substring(0, 20)}...'
                                    : f.nom,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _colors[i],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                // ← idFiliere au lieu de id
                                onTap: () => _removeFiliere(f.idFiliere),
                                child: Icon(Icons.close_rounded,
                                    size: 14, color: _colors[i]),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (_selected.length < 3)
                        GestureDetector(
                          onTap: () => setState(
                              () => _showDropdown = !_showDropdown),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: LeWayColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: LeWayColors.slate100,
                                width: 1.5,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_rounded,
                                    size: 16,
                                    color: LeWayColors.slate500),
                                SizedBox(width: 6),
                                Text(
                                  'Ajouter une filière',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: LeWayColors.slate500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // ── Dropdown recherche ─────────────────────────────────
                  if (_showDropdown) ...[
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: LeWayColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: LeWayColors.slate100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: (v) =>
                                  setState(() => _query = v),
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Rechercher...',
                                hintStyle: const TextStyle(
                                    color: LeWayColors.slate400,
                                    fontSize: 14),
                                prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: LeWayColors.slate400,
                                    size: 18),
                                filled: true,
                                fillColor: LeWayColors.slate100,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxHeight: 200),
                            child: _suggestions.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'Aucune filière disponible',
                                      style: TextStyle(
                                          color: LeWayColors.slate400,
                                          fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _suggestions.length,
                                    itemBuilder: (context, i) {
                                      final f = _suggestions[i];
                                      return GestureDetector(
                                        onTap: () => _addFiliere(f),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: LeWayColors
                                                      .primary50,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                                child: const Icon(
                                                  Icons.school_rounded,
                                                  size: 18,
                                                  color: LeWayColors
                                                      .primary700,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(f.nom,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                          color: LeWayColors
                                                              .slate700,
                                                        )),
                                                    Text(f.domaine,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: LeWayColors
                                                              .slate400,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ── Message si < 2 filières ────────────────────────────
                  if (_selected.length < 2)
                    Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: LeWayColors.slate100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.add_rounded,
                                size: 32,
                                color: LeWayColors.slate400),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Sélectionnez au moins 2 filières',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LeWayColors.slate500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Utilisez le bouton "Ajouter une filière"',
                            style: TextStyle(
                              fontSize: 12,
                              color: LeWayColors.slate400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  // ── Radar + Tableau (si ≥ 2 filières) ─────────────────
                  if (_selected.length >= 2) ...[
                    // Radar chart
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
                            'Comparaison radar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: LeWayColors.primary900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Légende
                          Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            children:
                                _selected.asMap().entries.map((e) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _colors[e.key],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    e.value.nom.length > 18
                                        ? '${e.value.nom.substring(0, 18)}...'
                                        : e.value.nom,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: LeWayColors.slate600),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 220,
                            child: RadarChart(
                              RadarChartData(
                                radarShape: RadarShape.polygon,
                                tickCount: 4,
                                gridBorderData: const BorderSide(
                                    color: LeWayColors.slate200,
                                    width: 1),
                                radarBorderData: const BorderSide(
                                    color: LeWayColors.slate200,
                                    width: 1),
                                tickBorderData: const BorderSide(
                                    color: Colors.transparent),
                                titleTextStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: LeWayColors.slate600,
                                ),
                                getTitle: (index, angle) {
                                  const titles = [
                                    'Insertion',
                                    'Salaire',
                                    'Curricula',
                                    'Univers.',
                                    'Débouchés',
                                  ];
                                  return RadarChartTitle(
                                      text: titles[index], angle: 0);
                                },
                                dataSets: _selected
                                    .asMap()
                                    .entries
                                    .map((e) => RadarDataSet(
                                          fillColor: _colors[e.key]
                                              .withOpacity(0.12),
                                          borderColor: _colors[e.key],
                                          borderWidth: 2,
                                          entryRadius: 3,
                                          dataEntries:
                                              _radarEntries(e.value),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tableau comparatif
                    Container(
                      decoration: BoxDecoration(
                        color: LeWayColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: LeWayColors.slate100),
                      ),
                      child: Column(
                        children: [
                          // En-tête
                          Container(
                            decoration: const BoxDecoration(
                              color: LeWayColors.primary50,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Critère',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: LeWayColors.slate400,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                ..._selected.asMap().entries.map(
                                    (e) => Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: _colors[e.key],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                e.value.nom.length > 12
                                                    ? '${e.value.nom.substring(0, 12)}...'
                                                    : e.value.nom,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color: LeWayColors
                                                      .primary900,
                                                ),
                                                textAlign:
                                                    TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )),
                              ],
                            ),
                          ),

                          // Lignes — utilise les bons champs du nouveau modèle
                          _tableRow(
                            'Domaine',
                            _selected.map((f) => f.domaine).toList(),
                            false,
                          ),
                          _tableRow(
                            'Durée',
                            _selected.map((f) => f.duree).toList(),
                            false,
                          ),
                          _tableRow(
                            'Insertion',
                            _selected
                                .map((f) =>
                                    '${f.tauxInsertionInt}%')
                                .toList(),
                            true,
                            numValues: _selected
                                .map((f) =>
                                    (f.tauxInsertion ?? 0).toDouble())
                                .toList(),
                          ),
                          _tableRow(
                            'Salaire',
                            _selected
                                .map((f) =>
                                    '${((f.salaireMedianP50 ?? 0) / 1000).round()}k FCFA')
                                .toList(),
                            true,
                            numValues: _selected
                                .map((f) =>
                                    (f.salaireMedianP50 ?? 0).toDouble())
                                .toList(),
                          ),
                          _tableRow(
                            'Tendance IA',
                            _selected
                                .map((f) => f.tendanceIaLabel)
                                .toList(),
                            false,
                          ),
                          _tableRow(
                            'Universités',
                            _selected
                                .map((f) =>
                                    '${f.universites.length} dispo.')
                                .toList(),
                            true,
                            numValues: _selected
                                .map((f) =>
                                    f.universites.length.toDouble())
                                .toList(),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(
    String label,
    List<String> values,
    bool highlight, {
    List<double>? numValues,
    bool isLast = false,
  }) {
    double maxVal = 0;
    if (highlight && numValues != null) {
      maxVal = numValues.reduce((a, b) => a > b ? a : b);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: LeWayColors.slate100),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: LeWayColors.slate600,
              ),
            ),
          ),
          ...values.asMap().entries.map((e) {
            final isMax = highlight &&
                numValues != null &&
                numValues[e.key] == maxVal;
            return Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: isMax
                      ? LeWayColors.green50
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Text(
                      e.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isMax
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isMax
                            ? LeWayColors.green600
                            : LeWayColors.slate700,
                      ),
                    ),
                    if (isMax)
                      const Text(
                        '✓ meilleur',
                        style: TextStyle(
                          fontSize: 9,
                          color: LeWayColors.green600,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}