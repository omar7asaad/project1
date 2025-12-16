// ============================================================
// app_routes.dart - أسماء المسارات (الصفحات)
// ============================================================
// هذا الملف يحتوي على أسماء ثابتة لجميع صفحات التطبيق
// الهدف: تجنب كتابة النصوص مباشرة وتسهيل التعديل
// ============================================================

// abstract class = لا يمكن إنشاء object منه
// نستخدمه فقط للوصول للقيم الثابتة
abstract class AppRoutes {
  
  // ============================================================
  // أسماء الصفحات
  // ============================================================
  // static const = ثابت يمكن الوصول له مباشرة بدون إنشاء object
  // المسار يبدأ بـ / دائماً
  
  // صفحة تسجيل الدخول
  // للانتقال: Get.toNamed(AppRoutes.login)
  static const login = '/login';
  
  // صفحة نسيت كلمة المرور
  // للانتقال: Get.toNamed(AppRoutes.forgotPassword)
  static const forgotPassword = '/forgot-password';
  
  // صفحة إنشاء حساب جديد
  // للانتقال: Get.toNamed(AppRoutes.register)
  static const register = '/register';
  
  // صفحة المعلومات الشخصية
  // للانتقال: Get.toNamed(AppRoutes.personalInfo)
  static const personalInfo = '/personal-info';
  
  // صفحة انتظار الموافقة
  // للانتقال: Get.toNamed(AppRoutes.waitingApproval)
  static const waitingApproval = '/waiting-approval';
  
  
  // صفحة الرئيسية (عرض الشقق)
  // للانتقال: Get.offAllNamed(AppRoutes.home)
  static const home = '/home';
  
  // ============================================================
  // كيفية إضافة صفحة جديدة:
  // ============================================================
  // 1. أضف const هنا:
  //    static const newPage = '/new-page';
  // 2. أنشئ ملف الصفحة في lib/view/
  // 3. أضف GetPage في app_pages.dart
  // ============================================================
}
