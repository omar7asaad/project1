// Api/logInApi.dart
// ============================================================
// logInApi.dart - API تسجيل الدخول
// ============================================================
// هذا الملف يحتوي على كلاس Loginapi
// يتعامل مع السيرفر لتسجيل دخول المستخدم
// الوظائف:
//   - إرسال رقم الموبايل وكلمة المرور للسيرفر
//   - استقبال رد السيرفر (نجاح/فشل + token)
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------
import 'dart:convert';  // لتحويل JSON
import 'package:build/models/LoginResbonse.dart';  // نموذج الرد
import 'package:http/http.dart' as http;  // مكتبة HTTP لطلبات الشبكة

// ============================================================
// Loginapi - كلاس تسجيل الدخول
// ============================================================
class Loginapi {
  
  // ----------------------------------------------------------
  // baseUrl - رابط السيرفر الأساسي
  // ----------------------------------------------------------
  // !!هام!! غيّر هذا الرابط لرابط السيرفر الخاص بك
  // 
  // للتطوير المحلي:
  //   - Android Emulator: "http://10.0.2.2:8000"
  //   - iOS Simulator: "http://localhost:8000"
  //   - Physical Device: "http://[IP_ADDRESS]:8000"
  // 
  // للإنتاج:
  //   - "https://your-server.com"
  final String baseUrl = "http://10.206.50.107:8000/api";
  
  // ----------------------------------------------------------
  // Constructor - المُنشئ الفارغ
  // ----------------------------------------------------------
  Loginapi();
  
  // ----------------------------------------------------------
  // loginApi - دالة تسجيل الدخول
  // ----------------------------------------------------------
  // المعاملات:
  //   - mobile: رقم الموبايل
  //   - password: كلمة المرور
  // 
  // تُرجع: Future<LoginResponse>
  //   - Future = عملية غير متزامنة (async)
  //   - LoginResponse = كائن الرد
  // 
  // مثال الاستخدام:
  //   final api = Loginapi();
  //   final response = await api.loginApi("123456789", "password123");
  //   if (response.status == 1) {
  //     // نجح تسجيل الدخول
  //     print(response.token);
  //   }
  Future<LoginResponse> loginApi(String mobile, String password) async {
    
    // بناء الرابط الكامل
    // مثال: "http://10.210.241.144:8000/api/login"
    // للتعديل: غيّر '/api/login' حسب الـ API الخاص بك
    String url = '$baseUrl/login';

    // تحويل النص إلى Uri
    Uri uri = Uri.parse(url);

    // ----------------------------------------------------------
    // try-catch للتعامل مع الأخطاء
    // ----------------------------------------------------------
    try {
      // إرسال طلب POST
      var response = await http.post(
        uri,
        
        // Headers - ترويسات الطلب
        headers: {
          'Accept': 'application/json',  // نتوقع رد JSON
          // للتعديل: أضف headers إضافية إذا يتطلب الـ API
          // 'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
        },
        
        // Body - بيانات الطلب
        body: {
          'phone': mobile,
          'password': password,
          // للتعديل: أضف حقول إضافية إذا يتطلب الـ API
        },
      );

      // طباعة للتصحيح (تظهر في Console)
      // للتعديل: احذف هذه الأسطر في الإنتاج
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      // ----------------------------------------------------------
      // التحقق من نجاح الطلب
      // ----------------------------------------------------------
      // إذا كان السيرفر يستخدم /api (Fallback)
      if (response.statusCode == 404) {
        Uri uri2 = Uri.parse('$baseUrl/api/login');
        response = await http.post(
          uri2,
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'phone': mobile,
            'password': password,
          },
        );
      }

      // statusCode 200 = نجاح
  if (response.statusCode == 200) {
  final body = jsonDecode(response.body);
  return LoginResponse.fromJson(body);
} else {
  String msg = 'فشل تسجيل الدخول';
  try {
    final body = jsonDecode(response.body);
    msg = body['message']?.toString() ?? msg;
  } catch (_) {}

  return LoginResponse(
    status: 0,
    message: msg,
    token: null,
  );
}
    } catch (e) {
      // ----------------------------------------------------------
      // التعامل مع الأخطاء
      // ----------------------------------------------------------
      // قد تحدث في حالة:
      //   - عدم وجود اتصال بالإنترنت
      //   - السيرفر غير متاح
      //   - خطأ في التحويل
      print(e);

      return LoginResponse(
        status: 0,
        message: "Exception: $e",
      );
    }
  }
}

// ============================================================
// ملخص التعديلات الممكنة:
// ============================================================
// 1. تغيير رابط السيرفر:
//    - عدّل baseUrl للرابط الصحيح
//
// 2. تغيير endpoint:
//    - عدّل '/api/login' للمسار الصحيح
//
// 3. إضافة headers:
//    - أضف headers إضافية في headers: {}
//
// 4. إضافة حقول للطلب:
//    - أضف حقول في body: {}
//
// 5. إضافة timeout:
//    - await http.post(...).timeout(Duration(seconds: 30))
//
// 6. إضافة معالجة أخطاء أفضل:
//    - تحقق من نوع الخطأ وأعطِ رسالة مناسبة
// ============================================================
