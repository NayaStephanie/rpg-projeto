import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// Faz uma requisição GET simples e retorna o corpo decodificado como JSON.
  /// Lança exceção em caso de erro de rede ou resposta inválida.
  static Future<dynamic> fetchJson(String url, {Duration timeout = const Duration(seconds: 8)}) async {
    final uri = Uri.parse(url);
    final resp = await http.get(uri).timeout(timeout);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body);
    }
    throw Exception('Erro ao buscar dados: ${resp.statusCode}');
  }
}
