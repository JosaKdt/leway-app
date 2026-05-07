class Filiere {
  final String idFiliere;
  final String nom;
  final String domaine;
  final int? dureeTheorique;
  final int? salaireMedianP50;
  final double? tauxInsertion;
  final double? indiceSaturation;
  final int? tendanceIa;
  final double? tendanceCurriculaMarche;
  final List<String> universites;
  final List<String> competences;
  final List<String> debouches;
  final String? description;
  final Map<String, dynamic>? profilRiasecDominant;

  Filiere({
    required this.idFiliere,
    required this.nom,
    required this.domaine,
    this.dureeTheorique,
    this.salaireMedianP50,
    this.tauxInsertion,
    this.indiceSaturation,
    this.tendanceIa,
    this.tendanceCurriculaMarche,
    this.universites = const [],
    this.competences = const [],
    this.debouches = const [],
    this.description,
    this.profilRiasecDominant,
  });

  // Champs formatés pour l'affichage
  String get duree => dureeTheorique != null ? '$dureeTheorique ans' : 'N/A';
  int get tauxInsertionInt => tauxInsertion?.round() ?? 0;
  int get salaireMedian => salaireMedianP50 ?? 0;

  // Badge tendance IA
  String get tendanceIaLabel {
    switch (tendanceIa) {
      case 0: return 'En croissance';
      case 1: return 'Stable';
      case 2: return 'En transformation';
      case 3: return 'Fortement affecté';
      default: return 'N/A';
    }
  }

  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      idFiliere: json['id_filiere'] as String,
      nom: json['nom'] as String,
      domaine: json['domaine'] as String? ?? '',
      dureeTheorique: json['duree_theorique'] as int?,
      salaireMedianP50: json['salaire_median_p50'] as int?,
      tauxInsertion: (json['taux_insertion'] as num?)?.toDouble(),
      indiceSaturation: (json['indice_saturation'] as num?)?.toDouble(),
      tendanceIa: json['tendance_ia'] as int?,
      tendanceCurriculaMarche: (json['tendance_curricula_marche'] as num?)?.toDouble(),
      universites: _parseStringList(json['universites']),
      competences: _parseStringList(json['competences']),
      debouches: _parseStringList(json['debouches']),
      description: json['description'] as String?,
      profilRiasecDominant: json['profil_riasec_dominant'] as Map<String, dynamic>?,
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }
}
