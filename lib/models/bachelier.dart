class Bachelier {
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final String telephone;
  final String serieBac;
  final String mention;
  final String ville;
  final String avatar;
  final int progression;
  final int scoreGlobal;
  final List<String> filieresauvegardees;
  final Map<String, int> profilPsycho;

  Bachelier({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.serieBac,
    required this.mention,
    required this.ville,
    required this.avatar,
    required this.progression,
    required this.scoreGlobal,
    required this.filieresauvegardees,
    required this.profilPsycho,
  });
}