// controllers/auth_controller.dart
// ============================================================
// auth_controller.dart - متحكم المصادقة والمستخدم
// ============================================================
// هذا الملف يدير:
//   - تسجيل الدخول
//   - إنشاء حساب جديد
//   - حفظ بيانات المستخدم
//   - التحقق من صحة البيانات
// ============================================================

import 'package:build/Api/logoutApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build/Api/logInApi.dart';
import 'package:build/Api/registerApi.dart';
import 'package:build/models/User.dart';
import 'package:build/services/storage_service.dart';
import 'package:build/routes/app_routes.dart';

// ============================================================
// AuthController - الكلاس الرئيسي
// ============================================================
// يمتد من GetxController للعمل مع GetX
// للاستخدام في أي صفحة: final controller = Get.find<AuthController>();
class AuthController extends GetxController {

  // ============================================================
  // المتغيرات القابلة للمراقبة (Observable)
  // ============================================================
  // .obs تجعل المتغير قابل للمراقبة - أي تغيير فيه يُحدّث الواجهة تلقائياً
  // للقراءة: اسم_المتغير.value
  // للكتابة: اسم_المتغير.value = القيمة
  
  // هل يتم التحميل حالياً؟ (يُظهر مؤشر التحميل)
  var isLoading = false.obs;
  
  // هل كلمة المرور مخفية؟ (النقاط بدل الحروف)
  var obscurePassword = true.obs;  // لتسجيل الدخول
  
  // إظهار/إخفاء كلمة المرور في صفحة التسجيل
  var obscureRegisterPassword = true.obs;
  var obscureRegisterConfirmPassword = true.obs;
  
  // إظهار/إخفاء كلمة المرور في صفحة نسيان كلمة المرور
  var obscureForgotPassword = true.obs;
  var obscureForgotConfirmPassword = true.obs;
  
  // نوع الحساب: 'tenant' = مستأجر، 'owner' = صاحب شقة
  // للتعديل: غيّر القيمة الافتراضية هنا
  var userType = 'tenant'.obs;
  
  // ============================================================
  // بيانات المستخدم
  // ============================================================
  
  // المستخدم الحالي (Rxn يعني يمكن أن يكون null)
  var currentUser = Rxn<User>();
  
  // هل المستخدم مسجل دخوله؟
  var isLoggedIn = false.obs;
  
  // هل المستخدم زائر (بدون حساب)؟
  var isGuest = false.obs;
  
  // ============================================================
  // بيانات النماذج (Forms)
  // ============================================================
  // هذه المتغيرات تخزن ما يكتبه المستخدم في الحقول
  
  var mobile = ''.obs;           // رقم الموبايل
  var password = ''.obs;         // كلمة المرور
  var confirmPassword = ''.obs;  // تأكيد كلمة المرور
  var firstName = ''.obs;        // الاسم الأول
  var lastName = ''.obs;         // الاسم الأخير
  var birthDate = Rxn<DateTime>();         // تاريخ الميلاد
  var personalPhotoPath = Rxn<String>();   // مسار الصورة الشخصية
  var idPhotoPath = Rxn<String>();         // مسار صورة الهوية

  // ============================================================
  // APIs - الاتصال بالسيرفر
  // ============================================================
  final Loginapi _loginApi = Loginapi();
  final RegisterApi _registerApi = RegisterApi();
  final LogoutApi _logoutApi = LogoutApi();

  
  // ============================================================
  // StorageService - خدمة التخزين المحلي
  // ============================================================
  // Rxn = يمكن أن يكون null (سيتم تهيئته في onInit)
  var _storageService = Rxn<StorageService>();

  // ============================================================
  // الوضع التجريبي (Demo Mode)
  // ============================================================
  // عندما يكون true: التطبيق يعمل بدون سيرفر حقيقي
  // عندما يكون false: التطبيق يتصل بالسيرفر الحقيقي
  // للتعديل: غيّر إلى false عند ربط التطبيق بسيرفر حقيقي
  static const bool demoMode = false;

  // ============================================================
  // onInit - تهيئة Controller عند الإنشاء
  // ============================================================
  // تُستدعى تلقائياً عند إنشاء Controller
  @override
  void onInit() async {
    super.onInit();
    // تهيئة StorageService
    _storageService.value = await StorageService.getInstance();
    // تحميل البيانات المحفوظة
    await loadSavedData();
  }

  // ============================================================
  // الدوال (Functions)
  // ============================================================

  // ----------------------------------------------------------
  // loadSavedData - تحميل البيانات المحفوظة
  // ----------------------------------------------------------
  // تُستدعى عند بدء التطبيق لتحميل البيانات المحفوظة
  Future<void> loadSavedData() async {
    if (_storageService.value == null) return;
    
    final storage = _storageService.value!;
    
    // تحميل حالة تسجيل الدخول
    isLoggedIn.value = storage.getIsLoggedIn();
    
    // إذا كان مسجل دخوله، حمّل البيانات
    if (isLoggedIn.value) {
      // تحميل معلومات تسجيل الدخول
      mobile.value = storage.getMobile() ?? '';
      password.value = storage.getPassword() ?? '';
      
      // تحميل المعلومات الشخصية
      firstName.value = storage.getFirstName() ?? '';
      lastName.value = storage.getLastName() ?? '';
      birthDate.value = storage.getBirthDate();
      personalPhotoPath.value = storage.getPersonalPhotoPath();
      idPhotoPath.value = storage.getIdPhotoPath();
      
      // تحميل نوع الحساب
      userType.value = storage.getUserType();
      
      print('✅ تم تحميل البيانات المحفوظة');
    }
  }

  // ----------------------------------------------------------
  // togglePasswordVisibility - إظهار/إخفاء كلمة المرور
  // ----------------------------------------------------------
  // تُستخدم مع أيقونة العين في حقل كلمة المرور
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  // toggleRegisterPasswordVisibility - إظهار/إخفاء كلمة المرور في التسجيل
  void toggleRegisterPasswordVisibility() {
    obscureRegisterPassword.value = !obscureRegisterPassword.value;
  }
  
  // toggleRegisterConfirmPasswordVisibility - إظهار/إخفاء تأكيد كلمة المرور في التسجيل
  void toggleRegisterConfirmPasswordVisibility() {
    obscureRegisterConfirmPassword.value = !obscureRegisterConfirmPassword.value;
  }
  
  // toggleForgotPasswordVisibility - إظهار/إخفاء كلمة المرور في نسيان كلمة المرور
  void toggleForgotPasswordVisibility() {
    obscureForgotPassword.value = !obscureForgotPassword.value;
  }
  
  // toggleForgotConfirmPasswordVisibility - إظهار/إخفاء تأكيد كلمة المرور في نسيان كلمة المرور
  void toggleForgotConfirmPasswordVisibility() {
    obscureForgotConfirmPassword.value = !obscureForgotConfirmPassword.value;
  }

  // ----------------------------------------------------------
  // setUserType - تحديد نوع الحساب
  // ----------------------------------------------------------
  // المعاملات:
  //   type: 'tenant' للمستأجر، 'owner' لصاحب الشقة
  // للتعديل: يمكن إضافة أنواع أخرى
  void setUserType(String type) async {
    userType.value = type;
    
    // حفظ نوع الحساب في SharedPreferences
    if (_storageService.value != null) {
      await _storageService.value!.saveUserType(type);
    }
    
    // طباعة للتأكد (تظهر في Console)
    print('✅ تم اختيار نوع الحساب: ${type == "tenant" ? "مستأجر" : "صاحب شقة"}');
    
    // إظهار رسالة للمستخدم
    Get.snackbar(
      'تم الاختيار',  // العنوان
      type == 'tenant' ? 'تم اختيار: مستأجر' : 'تم اختيار: صاحب شقة',  // الرسالة
      snackPosition: SnackPosition.TOP,     // الموقع (TOP أو BOTTOM)
      backgroundColor: Colors.green,         // لون الخلفية
      colorText: Colors.white,               // لون النص
      duration: Duration(seconds: 1),        // مدة الظهور
      margin: EdgeInsets.all(10),            // الهوامش
    );
  }

  // ----------------------------------------------------------
  // setBirthDate - تحديد تاريخ الميلاد
  // ----------------------------------------------------------
  void setBirthDate(DateTime date) async {
    birthDate.value = date;
    // حفظ في SharedPreferences عند تحديث المعلومات الشخصية
    await _savePersonalInfo();
  }

  // ----------------------------------------------------------
  // setPersonalPhoto - تحديد الصورة الشخصية
  // ----------------------------------------------------------
  void setPersonalPhoto(String path) async {
    personalPhotoPath.value = path;
    // حفظ في SharedPreferences
    await _savePersonalInfo();
  }

  // ----------------------------------------------------------
  // setIdPhoto - تحديد صورة الهوية
  // ----------------------------------------------------------
  void setIdPhoto(String path) async {
    idPhotoPath.value = path;
    // حفظ في SharedPreferences
    await _savePersonalInfo();
  }
  
  // ----------------------------------------------------------
  // _savePersonalInfo - حفظ المعلومات الشخصية (دالة مساعدة)
  // ----------------------------------------------------------
  Future<void> _savePersonalInfo() async {
    if (_storageService.value == null) return;
    
    await _storageService.value!.savePersonalInfo(
      firstName: firstName.value,
      lastName: lastName.value,
      birthDate: birthDate.value,
      personalPhotoPath: personalPhotoPath.value,
      idPhotoPath: idPhotoPath.value,
    );
  }

  // ----------------------------------------------------------
  // loginAsGuest - الدخول كزائر
  // ----------------------------------------------------------
  void loginAsGuest() {
    isGuest.value = true;
    isLoggedIn.value = false;
  }

  // ----------------------------------------------------------
  // login - تسجيل الدخول
  // ----------------------------------------------------------
  // تُرجع true إذا نجح، false إذا فشل
Future<bool> login() async {
  if (mobile.value.isEmpty) {
    _showError('الرجاء إدخال رقم الموبايل');
    return false;
  }
  if (password.value.isEmpty) {
    _showError('الرجاء إدخال كلمة المرور');
    return false;
  }

  isLoading.value = true;

  try {
    final result = await _loginApi.loginApi(mobile.value.trim(), password.value);

    // ✅ نجاح حقيقي فقط إذا token موجود
    final token = (result.token ?? '').trim();
    if (token.isNotEmpty) {
      isLoggedIn.value = true;

      if (_storageService.value != null) {
        await _storageService.value!.saveLoginInfo(
          mobile: mobile.value.trim(),
          password: '', // لا تحفظ كلمة المرور
          token: token,
        );
      }

      _showSuccess('تم تسجيل الدخول بنجاح');
      return true;
    }

    // ❌ فشل: لا تنتقل للهوم
    isLoggedIn.value = false;
    _showError(result.message ?? 'رقم الهاتف أو كلمة المرور غير صحيحة');
    return false;
  } catch (e) {
    isLoggedIn.value = false;
    _showError('فشل الاتصال بالسيرفر: $e');
    return false;
  } finally {
    isLoading.value = false;
  }
}


  // ----------------------------------------------------------
  // validateRegistrationStep1 - التحقق من الخطوة الأولى للتسجيل
  // ----------------------------------------------------------
  // تتحقق من: رقم الموبايل، كلمة المرور، تأكيد كلمة المرور
  bool validateRegistrationStep1() {
    if (mobile.value.isEmpty) {
      _showError('الرجاء إدخال رقم الموبايل');
      return false;
    }

    if (password.value.isEmpty) {
      _showError('الرجاء إدخال كلمة المرور');
      return false;
    }

    // التحقق من تطابق كلمتي المرور
    if (password.value != confirmPassword.value) {
      _showError('كلمة المرور غير متطابقة');
      return false;
    }

    return true;
  }

  // ----------------------------------------------------------
  // validatePersonalInfo - التحقق من المعلومات الشخصية
  // ----------------------------------------------------------
  // تتحقق من: الاسم، تاريخ الميلاد، الصور
  bool validatePersonalInfo() {
    // التحقق من الاسم الأول
    if (firstName.value.isEmpty || firstName.value.trim().isEmpty) {
      _showError('الرجاء إدخال الاسم الأول');
      return false;
    }

    // التحقق من الاسم الأخير
    if (lastName.value.isEmpty || lastName.value.trim().isEmpty) {
      _showError('الرجاء إدخال الاسم الأخير');
      return false;
    }

    // التحقق من تاريخ الميلاد
    if (birthDate.value == null) {
      _showError('الرجاء اختيار تاريخ الميلاد');
      return false;
    }

    // التحقق من الصورة الشخصية
    if (personalPhotoPath.value == null || 
        personalPhotoPath.value!.isEmpty || 
        personalPhotoPath.value!.trim().isEmpty ||
        personalPhotoPath.value == 'selected') {
      _showError('الرجاء إضافة الصورة الشخصية');
      return false;
    }

    // التحقق من صورة الهوية
    if (idPhotoPath.value == null || 
        idPhotoPath.value!.isEmpty || 
        idPhotoPath.value!.trim().isEmpty ||
        idPhotoPath.value == 'selected') {
      _showError('الرجاء إضافة صورة الهوية');
      return false;
    }

    return true;
  }

  // ----------------------------------------------------------
  // register - إنشاء حساب جديد
  // ----------------------------------------------------------
  Future<bool> register() async {
    // التحقق من المعلومات الشخصية أولاً
    if (!validatePersonalInfo()) return false;

    isLoading.value = true;

    // الوضع التجريبي
    if (demoMode) {
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      
      // حفظ جميع البيانات بعد التسجيل
      if (_storageService.value != null) {
        await _storageService.value!.saveLoginInfo(
          mobile: mobile.value,
          password: password.value,
        );
        await _storageService.value!.savePersonalInfo(
          firstName: firstName.value,
          lastName: lastName.value,
          birthDate: birthDate.value,
          personalPhotoPath: personalPhotoPath.value,
          idPhotoPath: idPhotoPath.value,
        );
        await _storageService.value!.saveUserType(userType.value);
      }
      
      _showSuccess('تم إرسال طلب التسجيل بنجاح');
      return true;
    }

    // الاتصال الحقيقي بالسيرفر
    try {
      final result = await _registerApi.registerUser(
        mobile: mobile.value,
        password: password.value,
        userType: userType.value,
        firstName: firstName.value,
        lastName: lastName.value,
        birthDate: '${birthDate.value!.year}-${birthDate.value!.month}-${birthDate.value!.day}',
        personalPhoto: personalPhotoPath.value,
        idPhoto: idPhotoPath.value,
      );

      if (result['status'] == 1) {
        // حفظ جميع البيانات بعد التسجيل الناجح
        if (_storageService.value != null) {
          await _storageService.value!.saveLoginInfo(
            mobile: mobile.value,
            password: password.value,
          );
          await _storageService.value!.savePersonalInfo(
            firstName: firstName.value,
            lastName: lastName.value,
            birthDate: birthDate.value,
            personalPhotoPath: personalPhotoPath.value,
            idPhotoPath: idPhotoPath.value,
          );
          await _storageService.value!.saveUserType(userType.value);
        }
        
        _showSuccess('تم إرسال طلب التسجيل بنجاح');
        return true;
      } else {
        _showError(result['message'] ?? 'حدث خطأ أثناء التسجيل');
        return false;
      }
    } catch (e) {
      _showError('حدث خطأ: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------------
  // logout - تسجيل الخروج
  // ----------------------------------------------------------
  void logout() async {
    isLoggedIn.value = false;      // إلغاء تسجيل الدخول
    currentUser.value = null;       // مسح بيانات المستخدم
    
    // إرسال طلب تسجيل الخروج للسيرفر (اختياري)
    try {
      final t = _storageService.value?.getToken();
   if (t != null && t.trim().isNotEmpty) {
  await _logoutApi.logout(t);

}
    } catch (e) {
      // تجاهل الخطأ هنا حتى لو فشل السيرفر
      print('LOGOUT ERROR: $e');
    }

    // مسح البيانات المحفوظة
    if (_storageService.value != null) {
      await _storageService.value!.clearLoginInfo();
      // ملاحظة: لا نمسح المعلومات الشخصية (يمكن الاحتفاظ بها)
      // إذا أردت مسح كل شيء: await _storageService.value!.clearAll();
    }
    
    clearFormData();                // مسح بيانات النماذج
    Get.offAllNamed(AppRoutes.login);      // الانتقال لصفحة تسجيل الدخول
  }

  // ----------------------------------------------------------
  // sendPasswordResetCode - إرسال رمز إعادة تعيين كلمة المرور
  // ----------------------------------------------------------
  Future<bool> sendPasswordResetCode(String mobile) async {
    if (mobile.isEmpty) {
      _showError('الرجاء إدخال رقم الموبايل');
      return false;
    }

    isLoading.value = true;

    // الوضع التجريبي
    if (demoMode) {
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      _showSuccess('تم إرسال رمز التحقق إلى $mobile');
      return true;
    }

    // الاتصال الحقيقي بالسيرفر
    try {
      // TODO: استبدل هذا بـ API الحقيقي
      // final result = await _api.sendResetCode(mobile);
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      _showSuccess('تم إرسال رمز التحقق');
      return true;
    } catch (e) {
      _showError('حدث خطأ: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------------
  // resetPassword - إعادة تعيين كلمة المرور
  // ----------------------------------------------------------
  Future<bool> resetPassword(String mobile, String code, String newPassword) async {
    if (code.isEmpty) {
      _showError('الرجاء إدخال رمز التحقق');
      return false;
    }

    if (newPassword.isEmpty) {
      _showError('الرجاء إدخال كلمة المرور الجديدة');
      return false;
    }

    if (newPassword.length < 6) {
      _showError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return false;
    }

    isLoading.value = true;

    // الوضع التجريبي
    if (demoMode) {
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      _showSuccess('تم تغيير كلمة المرور بنجاح');
      return true;
    }

    // الاتصال الحقيقي بالسيرفر
    try {
      // TODO: استبدل هذا بـ API الحقيقي
      // final result = await _api.resetPassword(mobile, code, newPassword);
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      _showSuccess('تم تغيير كلمة المرور بنجاح');
      return true;
    } catch (e) {
      _showError('حدث خطأ: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------------
  // clearFormData - مسح جميع بيانات النماذج
  // ----------------------------------------------------------
  void clearFormData() {
    mobile.value = '';
    password.value = '';
    confirmPassword.value = '';
    firstName.value = '';
    lastName.value = '';
    birthDate.value = null;
    personalPhotoPath.value = null;
    idPhotoPath.value = null;
    userType.value = 'tenant';  // إعادة للقيمة الافتراضية
  }
  
  // ----------------------------------------------------------
  // updatePersonalInfo - تحديث المعلومات الشخصية (للتعديل)
  // ----------------------------------------------------------
  // تُستخدم عند تعديل المعلومات الشخصية من صفحة التعديل
  Future<void> updatePersonalInfo() async {
    // حفظ التغييرات في SharedPreferences
    await _savePersonalInfo();
    
    // حفظ نوع الحساب أيضاً
    if (_storageService.value != null) {
      await _storageService.value!.saveUserType(userType.value);
    }
  }

  // ----------------------------------------------------------
  // _showError - إظهار رسالة خطأ
  // ----------------------------------------------------------
  // دالة خاصة (private) - تبدأ بـ _
  void _showError(String message) {
    Get.snackbar(
      'خطأ',                              // العنوان
      message,                            // الرسالة
      snackPosition: SnackPosition.BOTTOM,  // الموقع
      backgroundColor: Colors.red,          // لون الخلفية (أحمر للخطأ)
      colorText: Colors.white,              // لون النص
      margin: EdgeInsets.all(16),           // الهوامش
      borderRadius: 10,                     // زوايا مستديرة
    );
  }

  // ----------------------------------------------------------
  // _showSuccess - إظهار رسالة نجاح
  // ----------------------------------------------------------
  void _showSuccess(String message) {
    Get.snackbar(
      'نجاح',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,       // لون الخلفية (أخضر للنجاح)
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 10,
    );
  }
}
