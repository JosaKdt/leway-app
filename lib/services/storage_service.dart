import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Sauvegarder le token JWT
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Récupérer le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Supprimer le token (déconnexion)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  // Vérifier si connecté
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}