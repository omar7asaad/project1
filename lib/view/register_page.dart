// view/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build/controllers/auth_controller.dart';
import 'package:build/routes/app_routes.dart';
import 'package:build/utils/app_colors.dart';

// ============================================================
// RegisterPage - صفحة التسجيل
// ============================================================
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final AuthController authController = Get.find<AuthController>();

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
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/register_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0x331565C0),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x4D64B5F6),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person_add_alt_1,
                              size: 70,
                              color: AppColors.skyBlue,
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            'اختر نوع الحساب',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 5),

                          Obx(
                            () => Text(
                              'المحدد حالياً: ${authController.userType.value == "tenant" ? "مستأجر ✓" : "صاحب شقة ✓"}',
                              style: TextStyle(
                                color: AppColors.skyBlue,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      authController.setUserType('tenant'),
                                  child: Obx(
                                    () => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      decoration: BoxDecoration(
                                        gradient:
                                            authController.userType.value ==
                                                    'tenant'
                                                ? AppColors.blueGradient
                                                : null,
                                        color: authController.userType.value !=
                                                'tenant'
                                            ? const Color(0x1AFFFFFF)
                                            : null,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              authController.userType.value ==
                                                      'tenant'
                                                  ? AppColors.skyBlue
                                                  : Colors.white30,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        children: const [
                                          Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'مستأجر',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      authController.setUserType('owner'),
                                  child: Obx(
                                    () => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      decoration: BoxDecoration(
                                        gradient:
                                            authController.userType.value ==
                                                    'owner'
                                                ? AppColors.blueGradient
                                                : null,
                                        color: authController.userType.value !=
                                                'owner'
                                            ? const Color(0x1AFFFFFF)
                                            : null,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              authController.userType.value ==
                                                      'owner'
                                                  ? AppColors.skyBlue
                                                  : Colors.white30,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        children: const [
                                          Icon(
                                            Icons.home_work,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'صاحب شقة',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // رقم الموبايل (بدون Obx لأنه لا يعتمد على Rx في الواجهة)
                          _buildTextField(
                            hintText: 'رقم الموبايل',
                            icon: Icons.phone_android,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) =>
                                authController.mobile.value = value,
                          ),

                          const SizedBox(height: 16),

                          // كلمة المرور (Obx فقط لهذا النوع لأنه يعتمد على Rx إخفاء/إظهار)
                          _buildTextField(
                            hintText: 'كلمة المرور',
                            icon: Icons.lock,
                            isPassword: true,
                            showPasswordToggle: true,
                            passwordType: 'password',
                            onChanged: (value) =>
                                authController.password.value = value,
                          ),

                          const SizedBox(height: 16),

                          // تأكيد كلمة المرور (Obx فقط)
                          _buildTextField(
                            hintText: 'تأكيد كلمة المرور',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            showPasswordToggle: true,
                            passwordType: 'confirm',
                            onChanged: (value) =>
                                authController.confirmPassword.value = value,
                          ),

                          const SizedBox(height: 30),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () {
                              if (authController.validateRegistrationStep1()) {
                                Get.toNamed(AppRoutes.personalInfo);
                              }
                            },
                            child: const Text(
                              'متابعة التسجيل',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0x33FF9800),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0x80FF9800)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    color: Colors.orange),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'ملاحظة: يجب مراجعة طلب التسجيل من قبل مدير النظام (Admin) قبل السماح باستخدام التطبيق.',
                                    style: TextStyle(
                                      color: Colors.orange.shade200,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // _buildTextField - دالة مساعدة لإنشاء حقول الإدخال
  // ============================================================
  Widget 
  _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    bool showPasswordToggle = false,
    String passwordType = 'password', // 'password' أو 'confirm'
  }) {
    // حقل عادي (بدون Obx)
    Widget normalField() {
      return TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: AppColors.navy),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      );
    }

    // حقل كلمة مرور (مع Obx لأنه يعتمد على Rx لإخفاء/إظهار)
    Widget passwordField() {
      return Obx(() {
        final obscure = (passwordType == 'password')
            ? authController.obscureRegisterPassword.value
            : authController.obscureRegisterConfirmPassword.value;

        return TextField(
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: AppColors.navy),
            suffixIcon: showPasswordToggle
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      if (passwordType == 'password') {
                        authController.toggleRegisterPasswordVisibility();
                      } else {
                        authController
                            .toggleRegisterConfirmPasswordVisibility();
                      }
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        );
      });
    }

    return Container(
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
      child: isPassword ? passwordField() : normalField(),
    );
  }
}
