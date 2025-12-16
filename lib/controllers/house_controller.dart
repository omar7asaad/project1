// controllers/house_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/house.dart';

class HouseController extends GetxController {
  // ✅ غيّر فقط هذا إذا تغيّر السيرفر
  static const String baseUrl = "http://10.210.241.144:8000";

  // عرض البيانات
  final houses = <House>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  // البحث والمفضلة (محلي)
  final searchQuery = ''.obs;
  final favoritesOnly = false.obs;
  final favorites = <int>{}.obs;

  // فلترة (سيرفر)
  final governorate = ''.obs;
  final city = ''.obs;
  final minPrice = RxnInt();
  final maxPrice = RxnInt();
  final rooms = RxnInt();

  static const _favKey = 'fav_house_ids';
  static const _tokenKey = 'token'; // متوافق مع زميلك غالباً

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    fetchHouses();
  }

  // ----------------------------------------------------------
  // Favorites
  // ----------------------------------------------------------
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favKey) ?? [];
    favorites.value = list.map((e) => int.tryParse(e) ?? -1).where((x) => x > 0).toSet();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, favorites.map((e) => e.toString()).toList());
  }

  void toggleFavorite(int id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    _saveFavorites();
  }

  void setSearch(String v) => searchQuery.value = v;
  void toggleFavoritesOnly() => favoritesOnly.value = !favoritesOnly.value;

  // ----------------------------------------------------------
  // Token
  // ----------------------------------------------------------
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_tokenKey);
    return (t == null || t.trim().isEmpty) ? null : t.trim();
  }

  Map<String, String> _authHeaders(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      };

  // ----------------------------------------------------------
  // HTTP helpers مع fallback (/path) ثم (/api/path)
  // ----------------------------------------------------------
  Future<http.Response> _getWithFallback(String path, {Map<String, dynamic>? query}) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token غير موجود (سجّل دخول أولاً)');

    final uri1 = Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );

    final uri2 = Uri.parse('$baseUrl/api$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );

    var res = await http.get(uri1, headers: _authHeaders(token)).timeout(const Duration(seconds: 20));
    if (res.statusCode == 404) {
      res = await http.get(uri2, headers: _authHeaders(token)).timeout(const Duration(seconds: 20));
    }
    return res;
  }

  Future<http.Response> _postJsonWithFallback(String path, Map<String, dynamic> body) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token غير موجود (سجّل دخول أولاً)');

    final h = {
      ..._authHeaders(token),
      'Content-Type': 'application/json',
    };

    final uri1 = Uri.parse('$baseUrl$path');
    final uri2 = Uri.parse('$baseUrl/api$path');

    var res = await http
        .post(uri1, headers: h, body: jsonEncode(body))
        .timeout(const Duration(seconds: 20));

    if (res.statusCode == 404) {
      res = await http
          .post(uri2, headers: h, body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));
    }
    return res;
  }

  // ----------------------------------------------------------
  // Fetch apartments (houses)
  // ----------------------------------------------------------
  Future<void> fetchHouses() async {
    try {
      isLoading.value = true;
      error.value = '';

      final res = await _getWithFallback('/apartments', query: {
        if (governorate.value.trim().isNotEmpty) 'governorate': governorate.value.trim(),
        if (city.value.trim().isNotEmpty) 'city': city.value.trim(),
        if (minPrice.value != null) 'min_price': minPrice.value!,
        if (maxPrice.value != null) 'max_price': maxPrice.value!,
        if (rooms.value != null) 'rooms': rooms.value!,
      });

      if (res.statusCode != 200) {
        throw Exception('فشل تحميل الشقق: ${res.statusCode} - ${res.body}');
      }

      final decoded = jsonDecode(res.body);

      final List list = (decoded is List)
          ? decoded
          : (decoded is Map && decoded['data'] is List)
              ? decoded['data']
              : [];

      final parsed = list
          .whereType<Map>()
          .map((e) => House.fromJson(e.cast<String, dynamic>(), baseUrl: baseUrl))
          .toList();

      houses.assignAll(parsed);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyFilters({
    String? governorateValue,
    String? cityValue,
    int? minPriceValue,
    int? maxPriceValue,
    int? roomsValue,
  }) async {
    governorate.value = (governorateValue ?? '').trim();
    city.value = (cityValue ?? '').trim();
    minPrice.value = minPriceValue;
    maxPrice.value = maxPriceValue;
    rooms.value = roomsValue;
    await fetchHouses();
  }

  // بحث + مفضلة فقط (محلي)
  List<House> get visibleHouses {
    final q = searchQuery.value.trim().toLowerCase();
    Iterable<House> list = houses;

    if (favoritesOnly.value) {
      list = list.where((h) => favorites.contains(h.id));
    }

    if (q.isNotEmpty) {
      list = list.where((h) {
        final text = '${h.title} ${h.address} ${h.description}'.toLowerCase();
        return text.contains(q);
      });
    }

    return list.toList();
  }

  // ----------------------------------------------------------
  // Booking
  // ----------------------------------------------------------
  String _fmt(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  Future<void> bookNow({
    required int apartmentId,
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await _postJsonWithFallback('/bookings', {
      'apartment_id': apartmentId,
      'start_date': _fmt(start),
      'end_date': _fmt(end),
    });

    if (res.statusCode == 201 || res.statusCode == 200) return;

    if (res.statusCode == 409) {
      throw Exception('409: التاريخ محجوز (تضارب)');
    }

    throw Exception('فشل الحجز: ${res.statusCode} - ${res.body}');
  }

  // ----------------------------------------------------------
  // Helpers
  // ----------------------------------------------------------
  String formatPrice(int v) {
    final s = v.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }
    // ----------------------------------------------------------
  // addApartment - إضافة شقة جديدة (Form-Data + صورة)
  // ----------------------------------------------------------
  // Endpoint حسب الباك:
  // POST /apartments (يحتاج Token) ويجب المستخدم يكون landlord
  // Form-Data:
  // title, description, governorate, city, price, rooms, image
  Future<void> addApartment({
    required String title,
    required String description,
    required String governorate,
    required String city,
    required int price,
    required int rooms,
    required String imagePath,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token غير موجود (سجّل دخول أولاً)');

    Future<http.StreamedResponse> _send(Uri uri) async {
      final request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Token $token';

      request.fields['title'] = title.trim();
      request.fields['description'] = description.trim();
      request.fields['governorate'] = governorate.trim();
      request.fields['city'] = city.trim();
      request.fields['price'] = price.toString();
      request.fields['rooms'] = rooms.toString();

      if (imagePath.trim().isNotEmpty && File(imagePath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      } else {
        throw Exception('الصورة غير موجودة أو المسار خاطئ');
      }

      return request.send().timeout(const Duration(seconds: 30));
    }

    try {
      isLoading.value = true;
      error.value = '';

      // جرّب /apartments أولاً
      final uri1 = Uri.parse('$baseUrl/apartments');
      final uri2 = Uri.parse('$baseUrl/api/apartments');

      var streamed = await _send(uri1);

      // fallback إذا السيرفر شغّال على /api
      if (streamed.statusCode == 404) {
        streamed = await _send(uri2);
      }

      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 201 || res.statusCode == 200) {
        // نجاح
        await fetchHouses(); // تحديث القائمة مباشرة
        return;
      }

    if (res.statusCode == 401) {
  throw Exception('يجب تسجيل الدخول أولاً قبل إضافة شقة.');
}
if (res.statusCode == 403) {
  throw Exception('هذه الميزة متاحة فقط للمالك (landlord).');
}

      if (res.body.isNotEmpty) {
        throw Exception('فشل إضافة الشقة: ${res.statusCode} - ${res.body}');
      }

      throw Exception('فشل إضافة الشقة: ${res.statusCode}');
    } finally {
      isLoading.value = false;
    }
  }

}
