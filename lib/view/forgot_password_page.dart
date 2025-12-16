// view/forgot_password_page.dart
// ============================================================
// forgot_password_page.dart - صفحة نسيت كلمة المرور
// ============================================================
// هذه الصفحة تسمح للمستخدم بإعادة تعيين كلمة المرور
// الخطوات:
//   1. إدخال رقم الموبايل
//   2. الضغط على "إرسال رمز التحقق"
//   3. إدخال الرمز + كلمة المرور الجديدة
//   4. العودة لصفحة تسجيل الدخول
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------

// flutter/material.dart = المكتبة الأساسية للواجهات
// ⚙️ لا يمكن تغييرها - مطلوبة
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build/controllers/auth_controller.dart';
import 'package:build/utils/app_colors.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/forgot_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0x4D1565C0),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x8064B5F6),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: 80,
                        color: AppColors.skyBlue,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'أدخل رقم الموبايل المسجل وسنرسل لك\nرمز التحقق لإعادة تعيين كلمة المرور',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "رقم الموبايل",
                          prefixIcon: Icon(Icons.phone_android, color: AppColors.navy),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: authController.isLoading.value
                                ? null
                                : _sendResetCode,
                            child: authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'إرسال رمز التحقق',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendResetCode() async {
    final mobile = mobileController.text.trim();

    if (mobile.isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء إدخال رقم الموبايل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await authController.sendPasswordResetCode(mobile);
    if (success) {
      _showResetCodeDialog();
    }
  }

  void _showResetCodeDialog() {
    final codeController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'إعادة تعيين كلمة المرور',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'رمز التحقق',
                  prefixIcon: Icon(Icons.pin),
                ),
              ),
              const SizedBox(height: 12),

              /// ✅ GetBuilder بدل Obx (حل الخطأ)
              GetBuilder<AuthController>(
                builder: (_) => TextField(
                  controller: newPasswordController,
                  obscureText: authController.obscureForgotPassword.value,
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور الجديدة',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        authController.obscureForgotPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: authController.toggleForgotPasswordVisibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              GetBuilder<AuthController>(
                builder: (_) => TextField(
                  controller: confirmPasswordController,
                  obscureText: authController.obscureForgotConfirmPassword.value,
                  decoration: InputDecoration(
                    hintText: 'تأكيد كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        authController.obscureForgotConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed:
                          authController.toggleForgotConfirmPasswordVisibility,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeController.text.isEmpty ||
                  newPasswordController.text.isEmpty ||
                  newPasswordController.text !=
                      confirmPasswordController.text) {
                Get.snackbar(
                  'خطأ',
                  'تحقق من البيانات المدخلة',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final success = await authController.resetPassword(
                mobileController.text.trim(),
                codeController.text.trim(),
                newPasswordController.text,
              );

              if (success) {
                Get.back();
                Get.back();
              }
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// ملخص ما يمكن تغييره:
// ============================================================
// ✅ النصوص: العناوين، الأوصاف، رسائل الخطأ
// ✅ الألوان: الخلفية، الأزرار، النصوص
// ✅ الأيقونات: Icons.lock_reset_rounded, Icons.phone_android
// ✅ الأحجام: fontSize, size, padding
// ✅ صورة الخلفية: الرابط أو استخدام صورة محلية
//
// ❌ لا تغيّر:
// - Get.find<AuthController>()
// - authController.sendPasswordResetCode()
// - authController.resetPassword()
// - Get.back(), Get.dialog(), Get.snackbar()
// ============================================================

// ============================================================
// خطوات عمل الصفحة:
// ============================================================
// 1. المستخدم يدخل رقم الموبايل
// 2. يضغط "إرسال رمز التحقق"
// 3. _sendResetCode() تتحقق وتستدعي API
// 4. إذا نجح: تظهر _showResetCodeDialog()
// 5. المستخدم يدخل الرمز + كلمة المرور الجديدة
// 6. يضغط "تأكيد"
// 7. resetPassword() تستدعي API
// 8. إذا نجح: العودة لصفحة تسجيل الدخول
// ============================================================
