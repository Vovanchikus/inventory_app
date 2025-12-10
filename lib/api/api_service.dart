import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final bool ignoreSsl;

  late http.Client _client;

  ApiService({required this.baseUrl, this.ignoreSsl = false}) {
    if (ignoreSsl) {
      final ioc = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      _client = IOClient(ioc);
    } else {
      _client = http.Client();
    }
  }

  Future<List<dynamic>> fetchList(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response =
        await _client.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load $endpoint: ${response.statusCode}');
    }

    return jsonDecode(response.body)['data'] as List<dynamic>;
  }
}
