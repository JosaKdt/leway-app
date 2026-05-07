import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/filiere.dart';
import '../../services/filiere_service.dart';

class FilieresScreen extends StatefulWidget {
  const FilieresScreen({super.key});

  @override
  State<FilieresScreen> createState() => _FilieresScreenState();
}

class _FilieresScreenState extends State<FilieresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedDomaine = 'Tous';

  // État API
  List<Filiere> _filieres = [];
  bool _isLoading = true;
  String? _error;

  final List<String> _domaines = [
    'Tous',
    'Sciences & Technologie',
    'Santé',
    'Sciences Humaines',
    'Sciences Économiques',
    'Sciences Agricoles',
  ];

  @override
  void initState() {
    super.initState();
    _loadFilieres();
  }

  Future<void> _loadFilieres() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final filieres = await FiliereService.getFilieres(
        domaine: _selectedDomaine,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      setState(() {
        _filieres = filieres;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les filières.\nVérifie ta connexion.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Explorer les filières',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/comparateur'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Comparer',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isLoading ? 'Chargement...' : '${_filieres.length} filières disponibles au Bénin',
                    style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.75)),
                  ),
                  const SizedBox(height: 16),
                  // Barre de recherche
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        setState(() => _searchQuery = v);
                        _loadFilieres();
                      },
                      style: const TextStyle(fontSize: 14, color: LeWayColors.slate800),
                      decoration: InputDecoration(
                        hintText: 'Rechercher une filière...',
                        hintStyle: const TextStyle(color: LeWayColors.slate400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: LeWayColors.slate400, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                  _loadFilieres();
                                },
                                child: const Icon(Icons.close_rounded, color: LeWayColors.slate400, size: 20),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filtres domaines
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: _domaines.length,
                itemBuilder: (context, index) {
                  final domaine = _domaines[index];
                  final isSelected = _selectedDomaine == domaine;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDomaine = domaine);
                      _loadFilieres();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? LeWayColors.primary900 : LeWayColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? LeWayColors.primary900 : LeWayColors.slate200,
                        ),
                      ),
                      child: Text(
                        domaine,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : LeWayColors.slate600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Contenu principal
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 48, color: LeWayColors.slate400),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: LeWayColors.slate500)),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadFilieres, child: const Text('Réessayer')),
                  ],
                ),
              ),
            )
          else ...[
            // Compteur résultats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${_filieres.length} résultat${_filieres.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 13, color: LeWayColors.slate500, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Liste filières
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _FiliereCard(filiere: _filieres[index]),
                  childCount: _filieres.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }
}

// ─── Card filière ─────────────────────────────────────────────────────────────

class _FiliereCard extends StatelessWidget {
  final Filiere filiere;
  const _FiliereCard({required this.filiere});

  Color get _tendanceColor {
    switch (filiere.tendanceIa) {
      case 0: return const Color(0xFF16A34A);
      case 1: return const Color(0xFF2563EB);
      case 2: return const Color(0xFFD97706);
      case 3: return const Color(0xFFDC2626);
      default: return LeWayColors.slate400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/filiere-detail', arguments: filiere),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: LeWayColors.primary100, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.school_rounded, size: 22, color: LeWayColors.primary700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filiere.nom, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: LeWayColors.primary900)),
                      Text(filiere.domaine, style: const TextStyle(fontSize: 12, color: LeWayColors.slate500)),
                    ],
                  ),
                ),
                // Badge tendance IA
                if (filiere.tendanceIa != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _tendanceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      filiere.tendanceIaLabel,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _tendanceColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatChip(icon: Icons.schedule_rounded, label: filiere.duree),
                const SizedBox(width: 8),
                _StatChip(icon: Icons.trending_up_rounded, label: '${filiere.tauxInsertionInt}% insertion'),
                const SizedBox(width: 8),
                _StatChip(icon: Icons.payments_rounded, label: '${(filiere.salaireMedian / 1000).round()}k FCFA'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(color: LeWayColors.slate100, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(icon, size: 14, color: LeWayColors.primary700),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: LeWayColors.slate700), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
