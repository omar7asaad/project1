// bindings/app_bindings.dart
// ============================================================
// app_bindings.dart - ربط المتحكمات (Controllers)
// ============================================================
// هذا الملف يُحمّل الـ Controllers عند بدء التطبيق
// الـ Bindings تضمن توفر الـ Controller في كل مكان
// ============================================================

import 'package:get/get.dart';
import 'package:build/controllers/auth_controller.dart';

// ============================================================
// AppBindings - الربط الرئيسي
// ============================================================
// يمتد من Bindings ويُنفّذ الدالة dependencies()
class AppBindings extends Bindings {
  
  @override
  void dependencies() {
    // ============================================================
    // تسجيل الـ Controllers
    // ============================================================
    
    // ----------------------------------------------------------
    // AuthController - متحكم المصادقة
    // ----------------------------------------------------------
    // Get.put() = تسجيل Controller جديد
    // <AuthController> = نوع الـ Controller
    // permanent: true = يبقى في الذاكرة طوال فترة تشغيل التطبيق
    // permanent: false = يُحذف عند الخروج من الصفحة
    Get.put<AuthController>(AuthController(), permanent: true);
    
    // ============================================================
    // كيفية إضافة Controller جديد:
    // ============================================================
    // 1. أنشئ ملف Controller في lib/controllers/
    // 2. أضفه هنا:
    //
    //    // Controller جديد
    //    Get.put<NewController>(NewController(), permanent: true);
    //
    // 3. استخدمه في أي صفحة:
    //    final controller = Get.find<NewController>();
    // ============================================================
    
    // ============================================================
    // طرق تسجيل الـ Controllers:
    // ============================================================
    //
    // 1. Get.put() - تسجيل مباشر
    //    Get.put<MyController>(MyController());
    //
    // 2. Get.lazyPut() - تسجيل كسول (يُنشأ عند الاستخدام)
    //    Get.lazyPut<MyController>(() => MyController());
    //
    // 3. Get.putAsync() - تسجيل مع async
    //    Get.putAsync<MyController>(() async => MyController());
    //
    // ============================================================
  }
}
