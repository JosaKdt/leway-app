### 4. Endpoints attendus par Flutter

| Écran Flutter | Endpoint backend | Méthode |
|---------------|-----------------|---------|
| Login | `/auth/login` | POST |
| Inscription | `/auth/register` | POST |
| Vérif OTP | `/auth/verify-otp` | POST |
| Questionnaire | `/questionnaire/items` | GET |
| Soumettre réponses | `/questionnaire/submit` | POST |
| Rapport RIASEC | `/recommandations/{id}` | GET |
| Liste filières | `/filieres` | GET |
| Détail filière | `/filieres/{id}` | GET |
| Profil bachelier | `/bachelier/{id}` | GET |

---

## 🚀 Installation & lancement

### Prérequis
- Flutter 3.19.6+
- Android Studio + SDK Android 35
- Git

### Cloner et lancer
```bash
git clone https://github.com/JosaKdt/leway-app.git
cd leway-app
flutter pub get
flutter run
```

---

## 🌿 Convention Git