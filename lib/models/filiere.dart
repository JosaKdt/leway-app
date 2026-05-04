class Filiere {
  final String id;
  final String nom;
  final String domaine;
  final String duree;
  final int salaireMedian;
  final int tauxInsertion;
  final String description;
  final List<String> universites;
  final List<String> competences;
  final List<String> debouches;
  final int scoreMarche2030;
  final String ville;
  final List<String> tags;
  int? scoreCompatibilite;

  Filiere({
    required this.id,
    required this.nom,
    required this.domaine,
    required this.duree,
    required this.salaireMedian,
    required this.tauxInsertion,
    required this.description,
    required this.universites,
    required this.competences,
    required this.debouches,
    required this.scoreMarche2030,
    required this.ville,
    required this.tags,
    this.scoreCompatibilite,
  });
}