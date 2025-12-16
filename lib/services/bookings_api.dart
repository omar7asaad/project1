// services/bookings_api.dart
import 'dart:convert';
import 'api_config.dart';
import 'http_helper.dart';
import 'token_store.dart';

class BookingsApi {
  Future<void> createBooking({
    required int apartmentId,
    required String startDate, // YYYY-MM-DD
    required String endDate,   // YYYY-MM-DD
  }) async {
    final token = await TokenStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('غير مسجل دخول (Token مفقود)');
    }

    final headers = {
      'Authorization': 'Token $token',
      'Accept': 'application/json',
    };

    final res = await HttpHelper.postJsonWithFallback(
      baseUrl: ApiConfig.baseUrl,
      pathWithApi: '/api/bookings',
      pathNoApi: '/bookings',
      headers: headers,
      body: {
        'apartment_id': apartmentId,
        'start_date': startDate,
        'end_date': endDate,
      },
    );

    if (res.statusCode == 201 || res.statusCode == 200) return;

    if (res.statusCode == 409) {
      throw Exception('التاريخ محجوز (409)');
    }

    // حاول استخراج رسالة
    try {
      final j = jsonDecode(res.body);
      final msg = (j is Map)
          ? (j['message'] ?? j['detail'] ?? j['error'] ?? res.body).toString()
          : res.body;
      throw Exception('فشل الحجز: $msg');
    } catch (_) {
      throw Exception('فشل الحجز: ${res.statusCode} - ${res.body}');
    }
  }

  Future<void> logout() async {
    final token = await TokenStore.getToken();
    if (token == null || token.isEmpty) return;

    final headers = {
      'Authorization': 'Token $token',
      'Accept': 'application/json',
    };

    // /logout
    await HttpHelper.postEmptyWithFallback(
      baseUrl: ApiConfig.baseUrl,
      pathWithApi: '/api/logout',
      pathNoApi: '/logout',
      headers: headers,
    );
  }
}
