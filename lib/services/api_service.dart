import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  // 10.0.2.2 = localhost depuis l'émulateur Android
  // Sur appareil réel, remplace par ton IP locale ex: http://192.168.1.x:8000

  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    // Intercepteur JWT — ajoute le token automatiquement
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  // ─── AUTH ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/auth/register', data: data);
    return response.data;
  }

 Future<Map<String, dynamic>> login(String email, String motDePasse) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'email': email,
        'mot_de_passe': motDePasse,
      });
      return response.data;
    } on DioException catch (e) {
      print('=== DIO ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status: ${e.response?.statusCode}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/api/auth/me');
    return response.data;
  }

  // ─── FILIÈRES ────────────────────────────────────────────────────────────

  Future<List<dynamic>> getFilieres({String? domaine, String? search}) async {
    final response = await _dio.get('/api/filieres', queryParameters: {
      if (domaine != null) 'domaine': domaine,
      if (search != null) 'search': search,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getFiliere(String id) async {
    final response = await _dio.get('/api/filieres/$id');
    return response.data;
  }

  // ─── FAVORIS ─────────────────────────────────────────────────────────────

  Future<List<dynamic>> getFavoris() async {
    final response = await _dio.get('/api/favoris');
    return response.data;
  }

  Future<Map<String, dynamic>> addFavori(String idFiliere) async {
    final response = await _dio.post('/api/favoris', data: {
      'id_filiere': idFiliere,
    });
    return response.data;
  }

  Future<void> deleteFavori(String idFavori) async {
    await _dio.delete('/api/favoris/$idFavori');
  }

  // ─── BACHELIER ───────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getMonProfil() async {
    final response = await _dio.get('/api/bacheliers/me');
    return response.data;
  }

  Future<Map<String, dynamic>> updateMonProfil(
      Map<String, dynamic> data) async {
    final response = await _dio.patch('/api/bacheliers/me', data: data);
    return response.data;
  }
}

// Instance globale
final apiService = ApiService();