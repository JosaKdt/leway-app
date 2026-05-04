import '../models/filiere.dart';
import '../models/bachelier.dart';

// Utilisateur mocké — comme Bolt
final Bachelier currentUser = Bachelier(
  id: 'user_001',
  prenom: 'Kofi',
  nom: 'Mensah',
  email: 'kofi.mensah@email.com',
  telephone: '+229 97 12 34 56',
  serieBac: 'C',
  mention: 'Bien',
  ville: 'Cotonou',
  avatar: 'KM',
  progression: 85,
  scoreGlobal: 78,
  filieresauvegardees: ['informatique', 'medecine', 'droit'],
  profilPsycho: {
    'Autonomie': 88,
    'Rigueur': 82,
    'Créativité': 74,
    'Leadership': 68,
    'Empathie': 55,
  },
);

// Filières béninoises — données réelles de Bolt
final List<Filiere> filieres = [
  Filiere(
    id: 'informatique',
    nom: 'Génie Informatique & Systèmes',
    domaine: 'Sciences & Technologie',
    duree: '3-5 ans',
    salaireMedian: 350000,
    tauxInsertion: 87,
    description:
        'Formation complète en développement logiciel, intelligence artificielle, cybersécurité et systèmes embarqués.',
    universites: ['UAC — FAST', 'UNSTIM', 'ESGIS Cotonou', 'UATM Bénin'],
    competences: ['Programmation Python/Java', 'Bases de données', 'Réseaux', 'IA & Machine Learning'],
    debouches: ['Développeur logiciel', 'Data Scientist', 'Administrateur réseau', 'Chef de projet IT'],
    scoreMarche2030: 92,
    ville: 'Cotonou',
    tags: ['Technologie', 'Numérique', 'Innovation'],
    scoreCompatibilite: 91,
  ),
  Filiere(
    id: 'medecine',
    nom: 'Médecine Générale',
    domaine: 'Santé',
    duree: '7 ans',
    salaireMedian: 500000,
    tauxInsertion: 94,
    description:
        'Cursus médical complet intégrant les sciences fondamentales, la clinique et la médecine tropicale.',
    universites: ['UAC — FMSS', 'Université de Parakou'],
    competences: ['Diagnostic clinique', 'Urgences médicales', 'Médecine tropicale', 'Santé publique'],
    debouches: ['Médecin généraliste', 'Médecin spécialiste', 'Chercheur médical'],
    scoreMarche2030: 88,
    ville: 'Cotonou',
    tags: ['Santé', 'Service public', 'Sciences'],
    scoreCompatibilite: 83,
  ),
  Filiere(
    id: 'droit',
    nom: 'Droit & Sciences Juridiques',
    domaine: 'Sciences Humaines',
    duree: '3-5 ans',
    salaireMedian: 280000,
    tauxInsertion: 71,
    description:
        'Formation en droit privé, public, international et affaires avec focus sur le droit OHADA.',
    universites: ['UAC — FADESP', 'Université de Parakou', 'UATM Bénin'],
    competences: ['Droit civil', 'Droit des affaires', 'Procédure judiciaire', 'Droit OHADA'],
    debouches: ['Avocat', 'Magistrat', 'Juriste d\'entreprise', 'Notaire'],
    scoreMarche2030: 74,
    ville: 'Porto-Novo',
    tags: ['Justice', 'Affaires', 'Administration'],
    scoreCompatibilite: 72,
  ),
  Filiere(
    id: 'economie',
    nom: 'Économie & Gestion',
    domaine: 'Sciences Économiques',
    duree: '3-5 ans',
    salaireMedian: 300000,
    tauxInsertion: 76,
    description:
        'Formation en économie appliquée, gestion des entreprises, finance et comptabilité.',
    universites: ['UAC — FASEG', 'ESGIS Cotonou', 'HEC Bénin'],
    competences: ['Comptabilité', 'Finance', 'Marketing', 'Gestion de projet'],
    debouches: ['Comptable', 'Analyste financier', 'Gestionnaire', 'Entrepreneur'],
    scoreMarche2030: 79,
    ville: 'Cotonou',
    tags: ['Finance', 'Gestion', 'Commerce'],
    scoreCompatibilite: 68,
  ),
  Filiere(
    id: 'agriculture',
    nom: 'Agronomie & Développement Rural',
    domaine: 'Sciences Agricoles',
    duree: '3-5 ans',
    salaireMedian: 250000,
    tauxInsertion: 82,
    description:
        'Formation en production végétale, élevage, agroalimentaire et développement durable.',
    universites: ['UAC — FSA', 'UNSTIM Abomey', 'Université de Parakou'],
    competences: ['Production végétale', 'Élevage', 'Agroalimentaire', 'Développement rural'],
    debouches: ['Agronome', 'Conseiller agricole', 'Chef de projet rural', 'Entrepreneur agricole'],
    scoreMarche2030: 85,
    ville: 'Abomey-Calavi',
    tags: ['Agriculture', 'Environnement', 'Rural'],
    scoreCompatibilite: 61,
  ),
];

// Activités récentes mockées
final List<Map<String, dynamic>> activitesRecentes = [
  {'action': 'Questionnaire complété à 85%', 'time': 'Il y a 2 heures', 'icon': 'check'},
  {'action': 'Filière Informatique sauvegardée', 'time': 'Hier', 'icon': 'bookmark'},
  {'action': 'RDV confirmé avec Dr. Agbossou', 'time': 'Il y a 2 jours', 'icon': 'calendar'},
  {'action': 'Profil psychométrique généré', 'time': 'Il y a 3 jours', 'icon': 'trending'},
];