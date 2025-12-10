import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetch(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/api/$endpoint'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }
}
