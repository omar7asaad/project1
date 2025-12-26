// Api/apartmentsApi.dart
// ============================================================
// apartments_api.dart - API الشقق (عرض + فلترة + تفاصيل + إضافة)
// ============================================================
// هذا الملف يحتوي على كلاس ApartmentsApi
// يتعامل مع السيرفر لجلب الشقق وإضافة شقة جديدة
// الوظائف:
//   - getApartments: عرض الشقق + فلترة
//   - getApartment : عرض تفاصيل شقة واحدة
//   - addApartment : إضافة شقة (Landlord فقط) + رفع صورة
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/models/apartment.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/apartment.dart';

// ============================================================
// ApiException - خطأ عام للـ API
// ============================================================
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => "ApiException($statusCode): $message";
}

// ============================================================
// ApartmentsApi - كلاس الشقق
// ============================================================
class ApartmentsApi {
  ApartmentsApi();

  // ----------------------------------------------------------
  // getApartments - عرض الشقق + فلترة
  // endpoint: GET /api/apartments
  // يحتاج token
  // filters:
  //   governorate, city, min_price, max_price, rooms
  // ----------------------------------------------------------
  Future<List<Apartment>> getApartments({
    required String token,
    String? governorate,
    String? city,
    int? minPrice,
    int? maxPrice,
    int? rooms,
  }) async {
    final query = <String, String>{};

    if (governorate != null && governorate.trim().isNotEmpty) {
      query['governorate'] = governorate.trim();
    }
    if (city != null && city.trim().isNotEmpty) {
      query['city'] = city.trim();
    }
    if (minPrice != null) query['min_price'] = minPrice.toString();
    if (maxPrice != null) query['max_price'] = maxPrice.toString();
    if (rooms != null) query['rooms'] = rooms.toString();

    final uri = ApiConfig.uri('/apartments', query: query);

    try {
      final res = await http
          .get(
            uri,
            headers: _headers(token),
          )
          .timeout(ApiConfig.timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        // قد يرجع List مباشرة أو داخل data / apartments حسب الباك
        final list = (data is List)
            ? data
            : (data is Map && data['data'] is List)
                ? data['data']
                : (data is Map && data['apartments'] is List)
                    ? data['apartments']
                    : [];

        return list
            .map<Apartment>(
              (e) => Apartment.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
      }

      _throwFriendly(res);
    } on SocketException {
      throw ApiException('تعذر الاتصال بالسيرفر. تحقق من الشبكة وتشغيل السيرفر.');
    } on TimeoutException {
      throw ApiException('انتهت مهلة الاتصال بالسيرفر (Timeout).');
    }
  }

  // ----------------------------------------------------------
  // getApartment - تفاصيل شقة واحدة
  // endpoint: GET /api/apartments/{id}
  // يحتاج token
  // ----------------------------------------------------------
  Future<Apartment> getApartment({
    required String token,
    required int id,
  }) async {
    final uri = ApiConfig.uri('/apartments/$id');

    try {
      final res = await http
          .get(
            uri,
            headers: _headers(token),
          )
          .timeout(ApiConfig.timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final obj = (data is Map && data['data'] is Map) ? data['data'] : data;
        return Apartment.fromJson(Map<String, dynamic>.from(obj));
      }

      _throwFriendly(res);
    } on SocketException {
      throw ApiException('تعذر الاتصال بالسيرفر. تحقق من الشبكة وتشغيل السيرفر.');
    } on TimeoutException {
      throw ApiException('انتهت مهلة الاتصال بالسيرفر (Timeout).');
    }
  }

  // ----------------------------------------------------------
  // addApartment - إضافة شقة (Landlord فقط)
  // endpoint: POST /api/apartments
  // يحتاج token
  // Form-Data:
  //   title, description, governorate, city, price, rooms, image(file)
  // ----------------------------------------------------------
  Future<Apartment> addApartment({
    required String token,
    required String title,
    required String description,
    required String governorate,
    required String city,
    required double price,
    required int rooms,
    required String imagePath, // مسار الصورة من الجهاز
  }) async {
    final uri = ApiConfig.uri('/apartments');

    try {
      final req = http.MultipartRequest('POST', uri);

      req.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      req.fields['title'] = title.trim();
      req.fields['description'] = description.trim();
      req.fields['governorate'] = governorate.trim();
      req.fields['city'] = city.trim();
      req.fields['price'] = price.toString();
      req.fields['rooms'] = rooms.toString();

      if (imagePath.trim().isNotEmpty) {
        req.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      final streamed = await req.send().timeout(ApiConfig.uploadTimeout);
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final obj = (data is Map && data['data'] is Map) ? data['data'] : data;
        return Apartment.fromJson(Map<String, dynamic>.from(obj));
      }

      // ✅ شرط landlord
      if (res.statusCode == 401 || res.statusCode == 403) {
        throw ApiException('هذه الميزة متاحة فقط للمالك (landlord).', statusCode: res.statusCode);
      }

      _throwFriendly(res);
    } on SocketException {
      throw ApiException('تعذر الاتصال بالسيرفر. تحقق من الشبكة وتشغيل السيرفر.');
    } on TimeoutException {
      throw ApiException('انتهت مهلة الاتصال بالسيرفر (Timeout).');
    }
  }

  // ============================================================
  // Helpers
  // ============================================================

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  String? _readMessage(http.Response res) {
    try {
      final body = jsonDecode(res.body);
      if (body is Map) {
        if (body['message'] != null) return body['message'].toString();
        if (body['error'] != null) return body['error'].toString();
      }
    } catch (_) {}
    return null;
  }

  Never _throwFriendly(http.Response res) {
    final msg = _readMessage(res) ?? 'فشل الطلب من السيرفر';
    throw ApiException(msg, statusCode: res.statusCode);
  }
}
