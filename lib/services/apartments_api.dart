// services/apartments_api.dart
import 'dart:convert';
import '../models/apartment.dart';
import 'api_config.dart';
import 'http_helper.dart';
import 'token_store.dart';

class ApartmentsApi {
  Future<List<Apartment>> getApartments({
    String? governorate,
    String? city,
    int? minPrice,
    int? maxPrice,
    int? rooms,
  }) async {
    final token = await TokenStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('غير مسجل دخول (Token مفقود)');
    }

    final headers = {
      'Authorization': 'Token $token',
      'Accept': 'application/json',
    };

    final res = await HttpHelper.getWithFallback(
      baseUrl: ApiConfig.baseUrl,
      pathWithApi: '/api/apartments',
      pathNoApi: '/apartments',
      headers: headers,
      query: {
        if (governorate != null && governorate.isNotEmpty) 'governorate': governorate,
        if (city != null && city.isNotEmpty) 'city': city,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (rooms != null) 'rooms': rooms,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('فشل جلب الشقق: ${res.statusCode} - ${res.body}');
    }

    final decoded = jsonDecode(res.body);

    // بعض السيرفرات ترجع List مباشرة، وبعضها داخل data
    final List list = (decoded is List)
        ? decoded
        : (decoded is Map && decoded['data'] is List)
            ? decoded['data']
            : [];

    return list.map((e) {
      final a = Apartment.fromJson((e as Map).cast<String, dynamic>());
      return Apartment(
        id: a.id,
        title: a.title,
        description: a.description,
        governorate: a.governorate,
        city: a.city,
        price: a.price,
        rooms: a.rooms,
        image: ApiConfig.normalizeImageUrl(a.image),
      );
    }).toList();
  }
}
