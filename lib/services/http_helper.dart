// services/http_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<http.Response> getWithFallback({
    required String baseUrl,
    required String pathWithApi,
    required String pathNoApi,
    required Map<String, String> headers,
    Map<String, dynamic>? query,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    Uri u1 = Uri.parse('$baseUrl$pathWithApi').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );
    Uri u2 = Uri.parse('$baseUrl$pathNoApi').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );

    var res = await http.get(u1, headers: headers).timeout(timeout);
    if (res.statusCode == 404) {
      res = await http.get(u2, headers: headers).timeout(timeout);
    }
    return res;
  }

  static Future<http.Response> postJsonWithFallback({
    required String baseUrl,
    required String pathWithApi,
    required String pathNoApi,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final h = {
      ...headers,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Uri u1 = Uri.parse('$baseUrl$pathWithApi');
    Uri u2 = Uri.parse('$baseUrl$pathNoApi');

    var res = await http
        .post(u1, headers: h, body: jsonEncode(body))
        .timeout(timeout);

    if (res.statusCode == 404) {
      res = await http
          .post(u2, headers: h, body: jsonEncode(body))
          .timeout(timeout);
    }
    return res;
  }

  static Future<http.Response> postEmptyWithFallback({
    required String baseUrl,
    required String pathWithApi,
    required String pathNoApi,
    required Map<String, String> headers,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    Uri u1 = Uri.parse('$baseUrl$pathWithApi');
    Uri u2 = Uri.parse('$baseUrl$pathNoApi');

    var res = await http.post(u1, headers: headers).timeout(timeout);
    if (res.statusCode == 404) {
      res = await http.post(u2, headers: headers).timeout(timeout);
    }
    return res;
  }
}
