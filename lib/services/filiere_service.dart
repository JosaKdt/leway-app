import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filiere.dart';

class FiliereService {
  // Change cette URL selon ton environnement
  // Émulateur Android → 10.0.2.2
  // Appareil physique   → l'IP de ton PC sur le réseau local ex: 192.168.1.X
  static const String _baseUrl = 'http://10.0.2.2:8000';

  /// Récupère toutes les filières avec filtres optionnels
  static Future<List<Filiere>> getFilieres({
    String? domaine,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (domaine != null && domaine != 'Tous') queryParams['domaine'] = domaine;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse('$_baseUrl/api/filieres')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Filiere.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des filières');
    }
  }

  /// Récupère le détail d'une filière par son ID
  static Future<Filiere> getFiliereById(String id) async {
    final uri = Uri.parse('$_baseUrl/api/filieres/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Filiere.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 404) {
      throw Exception('Filière introuvable');
    } else {
      throw Exception('Erreur serveur');
    }
  }
}
