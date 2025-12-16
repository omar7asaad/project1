// ============================================================
// storage_service.dart - خدمة التخزين المحلي
// ============================================================
// هذا الملف يدير حفظ وقراءة البيانات من SharedPreferences
// SharedPreferences = تخزين محلي بسيط (مثل localStorage في الويب)
// البيانات تُحفظ على الجهاز حتى بعد إغلاق التطبيق
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// StorageService - الكلاس الرئيسي
// ============================================================
// Singleton Pattern = نسخة واحدة فقط من الكلاس
// للتعديل: يمكن جعله عادي (بدون singleton)
class StorageService {
  
  // ----------------------------------------------------------
  // Singleton Pattern
  // ----------------------------------------------------------
  // _instance = النسخة الواحدة من الكلاس
  // static = مشترك بين كل النسخ
  // ⚙️ لا تغيّره - مطلوب للـ singleton
  static StorageService? _instance;
  
  // _prefs = كائن SharedPreferences
  // late = سيتم تعيينه لاحقاً (قبل الاستخدام)
  // ⚙️ لا تغيّره
  late SharedPreferences _prefs;
  
  // ----------------------------------------------------------
  // Constructor (خاص - private)
  // ----------------------------------------------------------
  // _StorageService = private constructor (لا يمكن إنشاء نسخة من الخارج)
  // ⚙️ لا تغيّره
  StorageService._();
  
  // ----------------------------------------------------------
  // getInstance - الحصول على النسخة الواحدة
  // ----------------------------------------------------------
  // static = يمكن استدعاؤه بدون إنشاء كائن
  // async = دالة غير متزامنة (تحتوي await)
  // ⚙️ لا تغيّره
  static Future<StorageService> getInstance() async {
    // إذا لم تكن موجودة، أنشئها
    _instance ??= StorageService._();
    // تهيئة SharedPreferences
    _instance!._prefs = await SharedPreferences.getInstance();
    return _instance!;
  }
  
  // ============================================================
  // مفاتيح التخزين (Keys)
  // ============================================================
  // هذه المفاتيح تُستخدم كأسماء للمتغيرات المحفوظة
  // ⚙️ يمكن تغيير الأسماء لكن احتفظ بنفس القيم في كل الملفات
  
  // معلومات تسجيل الدخول
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyMobile = 'mobile';
  static const String _keyPassword = 'password';  // ⚠️ في الإنتاج، لا تحفظ كلمة المرور!
  static const String _keyToken = 'token';
  
  // المعلومات الشخصية
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyBirthDate = 'birth_date';
  static const String _keyPersonalPhotoPath = 'personal_photo_path';
  static const String _keyIdPhotoPath = 'id_photo_path';
  
  // نوع الحساب
  static const String _keyUserType = 'user_type';  // 'tenant' أو 'owner'
  
  // ============================================================
  // دوال الحفظ (Save Functions)
  // ============================================================
  
  // ----------------------------------------------------------
  // saveLoginInfo - حفظ معلومات تسجيل الدخول
  // ----------------------------------------------------------
  // ⚙️ يمكن إضافة معاملات أخرى: email, username, etc.
  Future<bool> saveLoginInfo({
    required String mobile,
    String? password,  // ⚠️ اختياري - لا تحفظه في الإنتاج
    String? token,
  }) async {
    try {
      // حفظ كل قيمة
      await _prefs.setString(_keyMobile, mobile);
      if (password != null) {
        await _prefs.setString(_keyPassword, password);
      }
      if (token != null) {
        await _prefs.setString(_keyToken, token);
      }
      await _prefs.setBool(_keyIsLoggedIn, true);
      
      return true;
    } catch (e) {
      print('❌ خطأ في حفظ معلومات تسجيل الدخول: $e');
      return false;
    }
  }
  
  // ----------------------------------------------------------
  // savePersonalInfo - حفظ المعلومات الشخصية
  // ----------------------------------------------------------
  // ⚙️ يمكن إضافة معاملات أخرى: address, city, etc.
  Future<bool> savePersonalInfo({
    required String firstName,
    required String lastName,
    DateTime? birthDate,
    String? personalPhotoPath,
    String? idPhotoPath,
  }) async {
    try {
      await _prefs.setString(_keyFirstName, firstName);
      await _prefs.setString(_keyLastName, lastName);
      
      // حفظ تاريخ الميلاد كـ String (ISO format)
      if (birthDate != null) {
        await _prefs.setString(_keyBirthDate, birthDate.toIso8601String());
      } else {
        await _prefs.remove(_keyBirthDate);  // حذف إذا كان null
      }
      
      if (personalPhotoPath != null) {
        await _prefs.setString(_keyPersonalPhotoPath, personalPhotoPath);
      } else {
        await _prefs.remove(_keyPersonalPhotoPath);
      }
      
      if (idPhotoPath != null) {
        await _prefs.setString(_keyIdPhotoPath, idPhotoPath);
      } else {
        await _prefs.remove(_keyIdPhotoPath);
      }
      
      return true;
    } catch (e) {
      print('❌ خطأ في حفظ المعلومات الشخصية: $e');
      return false;
    }
  }
  
  // ----------------------------------------------------------
  // saveUserType - حفظ نوع الحساب
  // ----------------------------------------------------------
  // ⚙️ يمكن إضافة أنواع أخرى: 'admin', 'moderator', etc.
  Future<bool> saveUserType(String userType) async {
    try {
      await _prefs.setString(_keyUserType, userType);
      return true;
    } catch (e) {
      print('❌ خطأ في حفظ نوع الحساب: $e');
      return false;
    }
  }
  
  // ============================================================
  // دوال القراءة (Read Functions)
  // ============================================================
  
  // ----------------------------------------------------------
  // getIsLoggedIn - هل المستخدم مسجل دخوله؟
  // ----------------------------------------------------------
  bool getIsLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }
  
  // ----------------------------------------------------------
  // getMobile - الحصول على رقم الموبايل
  // ----------------------------------------------------------
  String? getMobile() {
    return _prefs.getString(_keyMobile);
  }
  
  // ----------------------------------------------------------
  // getPassword - الحصول على كلمة المرور
  // ----------------------------------------------------------
  // ⚠️ في الإنتاج، لا تحفظ كلمة المرور!
  String? getPassword() {
    return _prefs.getString(_keyPassword);
  }
  
  // ----------------------------------------------------------
  // getToken - الحصول على رمز المصادقة
  // ----------------------------------------------------------
  String? getToken() {
    return _prefs.getString(_keyToken);
  }
  
  // ----------------------------------------------------------
  // getFirstName - الحصول على الاسم الأول
  // ----------------------------------------------------------
  String? getFirstName() {
    return _prefs.getString(_keyFirstName);
  }
  
  // ----------------------------------------------------------
  // getLastName - الحصول على الاسم الأخير
  // ----------------------------------------------------------
  String? getLastName() {
    return _prefs.getString(_keyLastName);
  }
  
  // ----------------------------------------------------------
  // getBirthDate - الحصول على تاريخ الميلاد
  // ----------------------------------------------------------
  DateTime? getBirthDate() {
    final dateString = _prefs.getString(_keyBirthDate);
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print('❌ خطأ في قراءة تاريخ الميلاد: $e');
      return null;
    }
  }
  
  // ----------------------------------------------------------
  // getPersonalPhotoPath - الحصول على مسار الصورة الشخصية
  // ----------------------------------------------------------
  String? getPersonalPhotoPath() {
    return _prefs.getString(_keyPersonalPhotoPath);
  }
  
  // ----------------------------------------------------------
  // getIdPhotoPath - الحصول على مسار صورة الهوية
  // ----------------------------------------------------------
  String? getIdPhotoPath() {
    return _prefs.getString(_keyIdPhotoPath);
  }
  
  // ----------------------------------------------------------
  // getUserType - الحصول على نوع الحساب
  // ----------------------------------------------------------
  String getUserType() {
    return _prefs.getString(_keyUserType) ?? 'tenant';  // افتراضي: مستأجر
  }
  
  // ============================================================
  // دوال الحذف (Delete Functions)
  // ============================================================
  
  // ----------------------------------------------------------
  // clearLoginInfo - مسح معلومات تسجيل الدخول
  // ----------------------------------------------------------
  Future<bool> clearLoginInfo() async {
    try {
      await _prefs.remove(_keyMobile);
      await _prefs.remove(_keyPassword);
      await _prefs.remove(_keyToken);
      await _prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      print('❌ خطأ في مسح معلومات تسجيل الدخول: $e');
      return false;
    }
  }
  
  // ----------------------------------------------------------
  // clearPersonalInfo - مسح المعلومات الشخصية
  // ----------------------------------------------------------
  Future<bool> clearPersonalInfo() async {
    try {
      await _prefs.remove(_keyFirstName);
      await _prefs.remove(_keyLastName);
      await _prefs.remove(_keyBirthDate);
      await _prefs.remove(_keyPersonalPhotoPath);
      await _prefs.remove(_keyIdPhotoPath);
      return true;
    } catch (e) {
      print('❌ خطأ في مسح المعلومات الشخصية: $e');
      return false;
    }
  }
  
  // ----------------------------------------------------------
  // clearAll - مسح كل البيانات
  // ----------------------------------------------------------
  // ⚙️ يمكن استخدامها عند تسجيل الخروج
  Future<bool> clearAll() async {
    try {
      await _prefs.clear();
      return true;
    } catch (e) {
      print('❌ خطأ في مسح كل البيانات: $e');
      return false;
    }
  }
}

// ============================================================
// ملخص الاستخدام:
// ============================================================
// 
// 1. الحصول على النسخة:
//    final storage = await StorageService.getInstance();
//
// 2. حفظ البيانات:
//    await storage.saveLoginInfo(mobile: '0512345678', token: 'abc123');
//    await storage.savePersonalInfo(firstName: 'أحمد', lastName: 'محمد');
//    await storage.saveUserType('owner');
//
// 3. قراءة البيانات:
//    final mobile = storage.getMobile();
//    final firstName = storage.getFirstName();
//    final userType = storage.getUserType();
//
// 4. مسح البيانات:
//    await storage.clearAll();
// ============================================================

