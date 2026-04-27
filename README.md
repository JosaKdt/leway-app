📱 LÉWAY — Application Mobile Flutter
> **Conception et Réalisation d'une application mobile et web pour l'orientation des nouveaux bacheliers au Bénin**  
> Mémoire de fin de formation — Licence Professionnelle, Génie Électrique et Informatique  
> Université Africaine de Technologie et de Management (UATM) — Année académique 2025-2026
---
🧭 Présentation du projet
LÉWAY (du fon "Lé" = bénéfice + anglais "way" = chemin) est une plateforme web et mobile d'aide à l'orientation post-baccalauréat. Elle guide chaque bachelier béninois à partir de trois sources objectives :
son profil psychométrique RIASEC,
les données réelles du marché du travail béninois,
l'impact de l'intelligence artificielle sur les métiers.
Ce dépôt contient la couche mobile Flutter (interface Android), développée par Marie Josaphat KOUDHOROT dans le cadre du PFE.
---
👥 Équipe & responsabilités
Rôle	Responsable	Périmètre
Frontend Flutter	Marie (JosaKdt)	Tous les écrans, navigation, UI
Backend + Intégration	Chéri (Folawè)	FastAPI, PostgreSQL, LLM, endpoints API
---
🏗️ Architecture globale
```
Flutter App (Mobile Android)
        ↕  HTTP + JWT (Dio)
FastAPI Backend (Python 3.11)
        ↕
PostgreSQL 15 + Redis
        ↕
Moteur LLM (Claude Haiku / Ollama)
```
---
📁 Structure du projet
```
lib/
├── screens/
│   ├── splash/                   → splash_screen.dart
│   ├── onboarding/               → onboarding_screen.dart
│   ├── auth/                     → login_screen.dart
│   │                             → register_screen.dart
│   │                             → otp_screen.dart
│   ├── questionnaire/            → questionnaire_screen.dart (28 questions RIASEC)
│   ├── rapport/                  → rapport_screen.dart (radar chart)
│   ├── filieres/                 → filieres_screen.dart
│   │                             → filiere_detail_screen.dart
│   │                             → comparaison_screen.dart
│   └── profil/                   → profil_screen.dart
├── widgets/                      → composants réutilisables
├── services/
│   ├── api_service.dart          → ⚡ POINT D'INTÉGRATION BACKEND
│   ├── auth_service.dart         → gestion token JWT
│   └── storage_service.dart      → shared_preferences
├── models/                       → miroir exact des schémas Pydantic
│   ├── bachelier.dart
│   ├── filiere.dart
│   └── recommandation.dart
├── constants/
│   ├── colors.dart               → palette teal LÉWAY
│   └── strings.dart              → textes FR/EN
└── config/
    └── router.dart               → navigation go_router
```
> ✅ Tous les fichiers ci-dessus ont été créés. L'implémentation est en cours branche par branche.
---
🎨 Design
Élément	Valeur
Couleur principale	`#0F6E56` (teal foncé)
Couleur moyenne	`#5DCAA5` (teal clair)
Couleur de fond	`#E1F5EE` (teal très clair)
Style	Moderne, épuré, blanc
Langues	Français / Anglais (switch in-app)
Cible	Android — bacheliers béninois
---
⚡ Guide d'intégration backend (pour Chéri)
1. Le seul fichier à connaître : `api_service.dart`
Tout appel HTTP vers le backend passe par ce fichier. Marie prépare les méthodes — Chéri fournit les endpoints correspondants.
```dart
// Exemple de ce que Marie attend de Chéri :
Future<Recommandation> getRecommandations(String bachelierId);
Future<List<Filiere>> getFilieres();
Future<void> submitQuestionnaire(Map<String, int> reponses);
```
2. Format d'échange : JSON → Models Dart
Chéri partage le format exact de ses réponses JSON. Marie crée le modèle Dart correspondant.
Exemple :
Chéri retourne :
```json
{
  "id": "uuid",
  "nom_filiere": "Génie Logiciel",
  "score_compatibilite": 87,
  "salaire_moyen": 180000,
  "taux_insertion": 74
}
```
Marie crée dans `models/filiere.dart` :
```dart
class Filiere {
  final String id;
  final String nomFiliere;
  final int scoreCompatibilite;
  final int salaireMoyen;
  final int tauxInsertion;
}
```
3. Configuration de l'URL backend
Chéri définit l'URL de son serveur dans un fichier `.env` :
```env
BASE_URL=http://192.168.x.x:8000   # IP locale pendant le dev
BASE_URL=https://api.leway.bj      # production
```
4. Endpoints attendus par Flutter
Écran Flutter	Endpoint backend	Méthode
Login	`/auth/login`	POST
Inscription	`/auth/register`	POST
Vérif OTP	`/auth/verify-otp`	POST
Questionnaire	`/questionnaire/items`	GET
Soumettre réponses	`/questionnaire/submit`	POST
Rapport RIASEC	`/recommandations/{id}`	GET
Liste filières	`/filieres`	GET
Détail filière	`/filieres/{id}`	GET
Profil bachelier	`/bachelier/{id}`	GET
---
🚀 Installation & lancement
Prérequis
Flutter 3.19.6+
Android Studio + SDK Android 35
Git
Cloner et lancer
```bash
git clone https://github.com/JosaKdt/leway-app.git
cd leway-app
flutter pub get
flutter run
```
---
🌿 Conventions Git
Branches
```
main          → code stable uniquement (pas de push direct)
develop       → branche de travail commune ✅ créée et poussée
feature/xxx   → nouvelle fonctionnalité  (ex: feature/splash-screen) ✅ en cours
fix/xxx       → correction de bug
backend/xxx   → travail backend Chéri  (ex: backend/auth-endpoints)
```
État actuel des branches
Branche	Statut
`main`	✅ Initialisée
`develop`	✅ Créée et poussée (`git push -u origin develop`)
`feature/splash-screen`	✅ En cours (`git checkout -b feature/splash-screen`)
Workflow
```bash
# 1. Toujours partir de develop
git checkout develop
git pull origin develop

# 2. Créer une branche de fonctionnalité
git checkout -b feature/nom-ecran

# 3. Coder + commiter régulièrement
git add .
git commit -m "feat: description claire du changement"

# 4. Pousser et ouvrir une Pull Request vers develop
git push origin feature/nom-ecran
```
> ⚠️ **Règle absolue :** ne jamais pousser directement sur `main`.  
> Tout passe par `develop` → Pull Request → review → merge.
---
📋 Suivi des écrans (Marie)
Écran	Fichier	Statut
Splash	`splash_screen.dart`	🔄 En cours (`feature/splash-screen`)
Onboarding	`onboarding_screen.dart`	⏳ À faire
Login	`login_screen.dart`	⏳ À faire
Inscription	`register_screen.dart`	⏳ À faire
OTP	`otp_screen.dart`	⏳ À faire
Questionnaire RIASEC	`questionnaire_screen.dart`	⏳ À faire
Rapport radar	`rapport_screen.dart`	⏳ À faire
Liste filières	`filieres_screen.dart`	⏳ À faire
Détail filière	`filiere_detail_screen.dart`	⏳ À faire
Comparaison	`comparaison_screen.dart`	⏳ À faire
Profil	`profil_screen.dart`	⏳ À faire
---
📚 Contexte académique
Institution : Université Africaine de Technologie et de Management (UATM), Cotonou, Bénin
Filière : Génie Électrique et Informatique — option Système Informatique et Logiciel
Directeur de mémoire : M. OGUNDE Zhoulikoufouli
Auteurs : Folawè Milarépa AGLI & Marie Josaphat M.B.KOUDHOROT
Année académique : 2025-2026