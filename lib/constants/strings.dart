class LeWayStrings {
  static Map<String, Map<String, String>> translations = {
    // Splash & Onboarding
    'app_name': {'fr': 'LÉWAY', 'en': 'LÉWAY'},
    'tagline': {
      'fr': 'Ton avenir commence ici',
      'en': 'Your future starts here'
    },
    'get_started': {'fr': 'Commencer', 'en': 'Get started'},
    'login': {'fr': 'Se connecter', 'en': 'Login'},

    // Auth
    'create_account': {'fr': 'Créer un compte', 'en': 'Create account'},
    'full_name': {'fr': 'Nom complet', 'en': 'Full name'},
    'email': {'fr': 'Email', 'en': 'Email'},
    'phone': {'fr': 'Téléphone', 'en': 'Phone number'},
    'password': {'fr': 'Mot de passe', 'en': 'Password'},
    'next': {'fr': 'Suivant', 'en': 'Next'},
    'back': {'fr': 'Retour', 'en': 'Back'},
    'verify_otp': {'fr': 'Vérifier le code', 'en': 'Verify code'},
    'otp_sent': {
      'fr': 'Code envoyé par SMS',
      'en': 'Code sent by SMS'
    },
    'confirm': {'fr': 'Confirmer', 'en': 'Confirm'},

    // Questionnaire
    'questionnaire_title': {
      'fr': 'Ton profil RIASEC',
      'en': 'Your RIASEC profile'
    },
    'question_progress': {'fr': 'Question', 'en': 'Question'},
    'strongly_agree': {'fr': 'Tout à fait d\'accord', 'en': 'Strongly agree'},
    'agree': {'fr': 'D\'accord', 'en': 'Agree'},
    'neutral': {'fr': 'Neutre', 'en': 'Neutral'},
    'disagree': {'fr': 'Pas d\'accord', 'en': 'Disagree'},
    'strongly_disagree': {
      'fr': 'Pas du tout d\'accord',
      'en': 'Strongly disagree'
    },

    // Rapport
    'rapport_title': {'fr': 'Ton rapport', 'en': 'Your report'},
    'dominant_profile': {'fr': 'Profil dominant', 'en': 'Dominant profile'},
    'top_filieres': {
      'fr': 'Filières recommandées',
      'en': 'Recommended fields'
    },
    'compatibility': {'fr': 'Compatibilité', 'en': 'Compatibility'},

    // Filières
    'filieres_title': {'fr': 'Filières', 'en': 'Fields of study'},
    'average_salary': {'fr': 'Salaire moyen', 'en': 'Average salary'},
    'insertion_rate': {'fr': 'Taux d\'insertion', 'en': 'Insertion rate'},
    'duration': {'fr': 'Durée', 'en': 'Duration'},
    'compare': {'fr': 'Comparer', 'en': 'Compare'},
    'add_favorite': {'fr': 'Ajouter aux favoris', 'en': 'Add to favorites'},

    // Profil
    'profile_title': {'fr': 'Mon profil', 'en': 'My profile'},
    'language': {'fr': 'Langue', 'en': 'Language'},
    'my_favorites': {'fr': 'Mes favoris', 'en': 'My favorites'},
    'redo_test': {'fr': 'Refaire le test', 'en': 'Redo the test'},
    'logout': {'fr': 'Se déconnecter', 'en': 'Logout'},
  };

  static String get(String key, String lang) {
    return translations[key]?[lang] ?? translations[key]?['fr'] ?? key;
  }
}