// Api/logoutApi.dart
import 'package:http/http.dart' as http;

class LogoutApi {
  final String baseUrl = "http://10.206.50.107:8000/api";

  Future<void> logout(String token) async {
    final uri1 = Uri.parse('$baseUrl/logout');
    final uri2 = Uri.parse('$baseUrl/api/logout');

    Future<http.Response> send(Uri uri) {
      return http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 20));
    }

    var res = await send(uri1);
    if (res.statusCode == 404) {
      await send(uri2);
    }
  }
}
