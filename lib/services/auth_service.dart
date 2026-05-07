import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static Map<String, dynamic>? _currentUser;

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    final token = await StorageService.getToken();
    if (token == null) return null;
    try {
      _currentUser = await apiService.getMe();
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  static void clearUser() {
    _currentUser = null;
  }

  static String getPrenom() => _currentUser?['prenom'] ?? 'Bachelier';
  static String getNom() => _currentUser?['nom'] ?? '';
  static String getEmail() => _currentUser?['email'] ?? '';
  static String getAvatar() {
    final prenom = getPrenom();
    final nom = getNom();
    return '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}';
  }

  static Future<void> refreshUser() async {
  _currentUser = null;
  await getCurrentUser();
}
}