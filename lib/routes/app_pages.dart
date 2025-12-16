// routes/app_pages.dart
// ============================================================
// app_pages.dart - ربط المسارات بالصفحات
// ============================================================
// هذا الملف يربط كل مسار (route) بالصفحة (page) المقابلة له
// يُستخدم مع GetX للتنقل بين الصفحات
// ============================================================

import 'package:get/get.dart';

// استيراد المسارات
import 'package:build/routes/app_routes.dart';

// استيراد الصفحات
import 'package:build/view/login_page.dart';
import 'package:build/view/forgot_password_page.dart';
import 'package:build/view/register_page.dart';
import 'package:build/view/personal_info_page.dart';
import 'package:build/view/waiting_approval_page.dart';

// صفحة تصفح الشقق (من واجهاتك)
import 'package:build/screens/home_screen.dart';

// ============================================================
// AppPages - إعدادات الصفحات
// ============================================================
class AppPages {
  
  // قائمة جميع صفحات التطبيق
  static final pages = [
    
    // ----------------------------------------------------------
    // صفحة تسجيل الدخول
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.login,     // المسار: '/login'
      page: () => LoginPage(),   // الصفحة: LoginPage
    ),
    
    // ----------------------------------------------------------
    // صفحة نسيت كلمة المرور
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.forgotPassword,     // المسار: '/forgot-password'
      page: () => ForgotPasswordPage(),   // الصفحة: ForgotPasswordPage
    ),
    
    // ----------------------------------------------------------
    // صفحة إنشاء حساب جديد
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.register,    // المسار: '/register'
      page: () => RegisterPage(),  // الصفحة: RegisterPage
    ),
    
    // ----------------------------------------------------------
    // صفحة المعلومات الشخصية
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.personalInfo,    // المسار: '/personal-info'
      page: () => PersonalInfoPage(),  // الصفحة: PersonalInfoPage
    ),
    
    // ----------------------------------------------------------
    // صفحة انتظار الموافقة
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.waitingApproval,    // المسار: '/waiting-approval'
      page: () => WaitingApprovalPage(),  // الصفحة: WaitingApprovalPage
    ),
    


    // ----------------------------------------------------------
    // الصفحة الرئيسية (عرض الشقق)
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.home,         // المسار: '/home'
      page: () => HomeScreen(),     // الصفحة: HomeScreen
    ),
    // ============================================================
    // كيفية إضافة صفحة جديدة:
    // ============================================================
    // GetPage(
    //   name: AppRoutes.newPage,     // المسار من app_routes.dart
    //   page: () => NewPage(),        // الصفحة
    //   binding: NewBinding(),        // (اختياري) لربط Controller
    //   transition: Transition.fade,  // (اختياري) تأثير الانتقال
    // ),
    // ============================================================
  ];
}
