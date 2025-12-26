// controllers/apartment_controller.dart
// ============================================================
// apartments_controller.dart - Controller للشقق (GetX)
// ============================================================

import 'package:build/Api/apartmentsApi.dart';
import 'package:build/models/apartment.dart';
import 'package:get/get.dart';

import '../Api/apartmentsApi.dart';
import '../models/apartment.dart';
import '../services/storage_service.dart';

class ApartmentsController extends GetxController {
  final ApartmentsApi _api = ApartmentsApi();

  // قائمة الشقق
  final apartments = <Apartment>[].obs;

  // حالات
  final isLoading = false.obs;
  final error = ''.obs;

  // فلاتر
  final governorate = ''.obs;
  final city = ''.obs;
  final minPrice = RxnInt();
  final maxPrice = RxnInt();
  final rooms = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchApartments();
  }

  // ----------------------------------------------------------
  // fetchApartments - جلب الشقق (مع الفلاتر الحالية)
  // ----------------------------------------------------------
  Future<void> fetchApartments() async {
    isLoading.value = true;
    error.value = '';

    try {
      final storage = await StorageService.getInstance();
      final token = storage.getToken();

      if (token == null || token.trim().isEmpty) {
        error.value = 'Token غير موجود (سجّل دخول أولاً)';
        apartments.clear();
        return;
      }

      final list = await _api.getApartments(
        token: token,
        governorate: governorate.value,
        city: city.value,
        minPrice: minPrice.value,
        maxPrice: maxPrice.value,
        rooms: rooms.value,
      );

      apartments.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------------
  // applyFilters - تطبيق فلترة
  // ----------------------------------------------------------
  Future<void> applyFilters({
    required String governorateValue,
    required String cityValue,
    required int? minPriceValue,
    required int? maxPriceValue,
    required int? roomsValue,
  }) async {
    governorate.value = governorateValue.trim();
    city.value = cityValue.trim();
    minPrice.value = minPriceValue;
    maxPrice.value = maxPriceValue;
    rooms.value = roomsValue;

    await fetchApartments();
  }

  // ----------------------------------------------------------
  // getDetails - تفاصيل شقة
  // ----------------------------------------------------------
  Future<Apartment?> getDetails(int id) async {
    try {
      final storage = await StorageService.getInstance();
      final token = storage.getToken();

      if (token == null || token.trim().isEmpty) {
        error.value = 'Token غير موجود (سجّل دخول أولاً)';
        return null;
      }

      return await _api.getApartment(token: token, id: id);
    } catch (e) {
      error.value = e.toString();
      return null;
    }
  }

  // ----------------------------------------------------------
  // addNewApartment - إضافة شقة
  // ----------------------------------------------------------
  Future<bool> addNewApartment({
    required String title,
    required String description,
    required String governorate,
    required String city,
    required double price,
    required int rooms,
    required String imagePath,
  }) async {
    isLoading.value = true;
    error.value = '';

    try {
      final storage = await StorageService.getInstance();
      final token = storage.getToken();

      if (token == null || token.trim().isEmpty) {
        error.value = 'Token غير موجود (سجّل دخول أولاً)';
        return false;
      }

      await _api.addApartment(
        token: token,
        title: title,
        description: description,
        governorate: governorate,
        city: city,
        price: price,
        rooms: rooms,
        imagePath: imagePath,
      );

      await fetchApartments();
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
