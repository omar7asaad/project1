// view/personal_info_page.dart
// ============================================================
// personal_info_page.dart - صفحة المعلومات الشخصية
// ============================================================
// هذه الصفحة تُستخدم في حالتين:
//   1. التسجيل الجديد: إدخال المعلومات الشخصية (الخطوة 2)
//   2. تعديل المعلومات: للمستخدم المسجل مسبقاً
// تحتوي على:
//   - الصورة الشخصية
//   - الاسم الأول والأخير
//   - تاريخ الميلاد
//   - صورة الهوية
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';  // للتعامل مع الملفات المحلية (الصور)
import 'package:image_picker/image_picker.dart';  // لاختيار الصور من الكاميرا أو المعرض
import 'package:build/controllers/auth_controller.dart';
import 'package:build/routes/app_routes.dart';
import 'package:build/utils/app_colors.dart';

// ============================================================
// PersonalInfoPage - صفحة المعلومات الشخصية
// ============================================================
class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // الحصول على متحكم المصادقة
  final AuthController authController = Get.find<AuthController>();

  // Controllers للحقول
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    // تهيئة Controllers بالقيم الحالية من Controller
    firstNameController =
        TextEditingController(text: authController.firstName.value);
    lastNameController =
        TextEditingController(text: authController.lastName.value);

    // تحديث القيم في Controller عند التغيير
    firstNameController.addListener(() {
      authController.firstName.value = firstNameController.text;
    });
    lastNameController.addListener(() {
      authController.lastName.value = lastNameController.text;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // isEditMode - التحقق من وضع التعديل
  // ----------------------------------------------------------
  // إذا المستخدم مسجل دخوله = وضع تعديل
  // إذا لا = وضع تسجيل جديد
  // get = خاصية محسوبة (computed property)
  bool get isEditMode => authController.isLoggedIn.value;

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

            // ========================================================
            // صورة الخلفية
            // ========================================================
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/personal_info_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),

            // ========================================================
            // المحتوى
            // ========================================================
            SafeArea(
              child: Column(
                children: [

                  // --------------------------------------------------
                  // شريط العنوان المخصص
                  // --------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        // زر الرجوع
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),

                        // العنوان
                        Expanded(
                          child: Text(
                            'المعلومات الشخصية',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // --------------------------------------------------
                  // محتوى الصفحة
                  // --------------------------------------------------
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          // ================================================
                          // الصورة الشخصية
                          // ================================================
                          // Center = يُوسّط العنصر
                          Center(
                            child: GestureDetector(
                              // عند الضغط: فتح نافذة اختيار الصورة
                              onTap: () => _pickPersonalPhoto(context),

                              child: Obx(() => Stack(
                                children: [
                                  // حاوية الصورة الدائرية
                                  Container(
                                    width: 120,   // العرض
                                    height: 120,  // الارتفاع

                                    decoration: BoxDecoration(
                                      color: const Color(0x331565C0),  // أزرق 20%
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.skyBlue,
                                        width: 3,
                                      ),

                                      // إذا تم اختيار صورة، اعرضها
                                      image: authController.personalPhotoPath.value != null
                                          ? DecorationImage(
                                              // FileImage = صورة من ملف محلي
                                              image: FileImage(File(authController.personalPhotoPath.value!)),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),

                                    // أيقونة افتراضية إذا لم تُختر صورة
                                    child: authController.personalPhotoPath.value == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Color(0xB364B5F6),  // سماوي 70%
                                          )
                                        : null,
                                  ),

                                  // أيقونة الكاميرا في الزاوية
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // تسمية الصورة الشخصية (* = مطلوب)
                          Text(
                            'الصورة الشخصية *',
                            style: TextStyle(color: AppColors.skyBlue, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          // ================================================
                          // حقل الاسم الأول
                          // ================================================
                          _buildTextField(
                            hintText: 'الاسم الأول *',
                            icon: Icons.person_outline,
                            controller: firstNameController,
                          ),

                          const SizedBox(height: 16),

                          // ================================================
                          // حقل الاسم الأخير
                          // ================================================
                          _buildTextField(
                            hintText: 'الاسم الأخير *',
                            icon: Icons.person_outline,
                            controller: lastNameController,
                          ),

                          const SizedBox(height: 16),

                          // ================================================
                          // حقل تاريخ الميلاد
                          // ================================================
                          // GestureDetector لفتح منتقي التاريخ عند الضغط
                          GestureDetector(
                            onTap: () => _pickBirthDate(context),

                            child: Obx(() => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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

                              child: Row(
                                children: [
                                  // أيقونة التقويم
                                  Icon(Icons.calendar_today, color: AppColors.navy),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Text(
                                      // عرض التاريخ إذا تم اختياره
                                      authController.birthDate.value != null
                                          ? '${authController.birthDate.value!.day}/${authController.birthDate.value!.month}/${authController.birthDate.value!.year}'
                                          : 'تاريخ الميلاد *',  // نص تلميحي
                                      style: TextStyle(
                                        // لون مختلف حسب وجود القيمة
                                        color: authController.birthDate.value != null
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),

                          const SizedBox(height: 24),

                          // ================================================
                          // قسم صورة الهوية
                          // ================================================
                          const Text(
                            'صورة الهوية *',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // حاوية صورة الهوية
                          GestureDetector(
                            onTap: () => _pickIdPhoto(context),

                            child: Obx(() => Container(
                              height: 150,  // ارتفاع ثابت

                              decoration: BoxDecoration(
                                color: const Color(0x331565C0),  // أزرق 20%
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.skyBlue,
                                  width: 2,
                                ),

                                // عرض الصورة إذا تم اختيارها
                                image: authController.idPhotoPath.value != null
                                    ? DecorationImage(
                                        image: FileImage(File(authController.idPhotoPath.value!)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),

                              // محتوى افتراضي إذا لم تُختر صورة
                              child: authController.idPhotoPath.value == null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.credit_card,
                                          size: 50,
                                          color: AppColors.skyBlue.withOpacity(0.7),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'انقر لإضافة صورة الهوية',
                                          style: TextStyle(
                                            color: Color(0xB364B5F6),  // سماوي 70%
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            )),
                          ),

                          const SizedBox(height: 30),

                          // ================================================
                          // زر الحفظ / إتمام التسجيل
                          // ================================================
                          Obx(() => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),

                                // الزر معطل أثناء التحميل
                                onPressed: authController.isLoading.value
                                    ? null
                                    : () async {
                                        if (authController.isLoggedIn.value) {
                                          // ----- وضع التعديل -----
                                          await _saveChanges(context);
                                        } else {
                                          // ----- وضع التسجيل -----
                                          // استدعاء دالة التسجيل
                                          final success = await authController.register();

                                          if (success) {
                                            // الانتقال لصفحة انتظار الموافقة
                                            // offAllNamed = يحذف كل الصفحات السابقة
                                            Get.offAllNamed(AppRoutes.waitingApproval);
                                          }
                                        }
                                      },

                                // محتوى الزر
                                child: authController.isLoading.value
                                    // مؤشر التحميل
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    // النص والأيقونة
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // أيقونة مختلفة حسب الوضع
                                          Icon(authController.isLoggedIn.value
                                              ? Icons.save_rounded // تعديل
                                              : Icons.check_circle_rounded), // تسجيل
                                          const SizedBox(width: 10),
                                          // نص مختلف حسب الوضع
                                          Text(
                                            authController.isLoggedIn.value
                                                ? 'حفظ التغييرات'
                                                : 'إتمام التسجيل',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              )),

                          const SizedBox(height: 16),

                          // ================================================
                          // ملاحظة / معلومات إضافية
                          // ================================================
                          // يتغير المحتوى حسب الوضع
                          Obx(() => !authController.isLoggedIn.value
                              // ----- ملاحظة للمستخدم الجديد -----
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33FF9800),  // برتقالي 20%
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0x80FF9800)),  // برتقالي 50%
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: Colors.orange),
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
                                )
                              // ----- رسالة للمستخدم المسجل -----
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0x331565C0),  // أزرق 20%
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0x4D64B5F6)),  // سماوي 30%
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.security, color: AppColors.skyBlue),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'معلوماتك آمنة ومحمية.',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
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
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    TextEditingController? controller,  // استخدام controller بدل initialValue
    String initialValue = '',           // قيمة أولية (للتعديل) - للتوافق مع الكود القديم
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
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

      // TextFormField (بدون إنشاء Controller جديد كل مرة)
      child: (controller != null)
          ? TextFormField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
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
            )
          : TextFormField(
              initialValue: initialValue,
              obscureText: isPassword,
              keyboardType: keyboardType,
              onChanged: (v) => (onChanged ?? (_) {})(v),
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
            ),
    );
  }

  // ============================================================
  // _saveChanges - حفظ التغييرات (وضع التعديل)
  // ============================================================
// ============================================================
// _saveChanges - حفظ التغييرات (وضع التعديل)
// ============================================================
// ============================================================
// _saveChanges - حفظ التغييرات (وضع التعديل)
// ============================================================
Future<void> _saveChanges(BuildContext context) async {
  // تحديث القيم في Controller من TextEditingControllers
  authController.firstName.value = firstNameController.text.trim();
  authController.lastName.value = lastNameController.text.trim();

  // التحقق قبل الحفظ
  if (!authController.validatePersonalInfo()) {
    return;
  }

  // حفظ التغييرات
  await authController.updatePersonalInfo();

  // رسالة نجاح
  Get.snackbar(
    'تم الحفظ',
    'تم حفظ المعلومات الشخصية بنجاح',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
  );

  // ✅ لا تعمل Get.back() أبداً
  // ✅ روح مباشرة لصفحة انتظار الموافقة
  await Future.delayed(const Duration(milliseconds: 700));
  Get.offAllNamed(AppRoutes.waitingApproval);
}


  // ============================================================
  // _pickPersonalPhoto - اختيار الصورة الشخصية
  // ============================================================
  void _pickPersonalPhoto(BuildContext context) async {
    _showPhotoPickerDialog(context, 'personal');
  }

  // ============================================================
  // _pickIdPhoto - اختيار صورة الهوية
  // ============================================================
  void _pickIdPhoto(BuildContext context) async {
    _showPhotoPickerDialog(context, 'id');
  }

  // ============================================================
  // _showPhotoPickerDialog - نافذة اختيار الصورة
  // ============================================================
  // type: 'personal' للصورة الشخصية، 'id' لصورة الهوية
  void _showPhotoPickerDialog(BuildContext context, String type) async {
    // Get.dialog = عرض نافذة حوار
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        title: Text(
          type == 'personal' ? 'اختر الصورة الشخصية' : 'اختر صورة الهوية',
          textAlign: TextAlign.center,
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,  // أصغر حجم ممكن
          children: [

            // خيار الكاميرا
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x1A1565C0),  // أزرق 10%
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.camera_alt, color: AppColors.primaryBlue),
              ),
              title: const Text('الكاميرا'),

              onTap: () async {
                // إغلاق النافذة أولاً
                Get.back();

                // انتظار قليل لضمان إغلاق النافذة
                await Future.delayed(const Duration(milliseconds: 300));

                // استخدام image_picker لفتح الكاميرا
                final ImagePicker picker = ImagePicker();
                try {
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,  // جودة الصورة (0-100)
                  );

                  // إذا تم اختيار صورة
                  if (image != null && image.path.isNotEmpty) {
                    // حفظ مسار الصورة في الـ Controller
                    if (type == 'personal') {
                      authController.setPersonalPhoto(image.path);
                    } else {
                      authController.setIdPhoto(image.path);
                    }

                    // رسالة نجاح
                    Get.snackbar(
                      'نجاح',
                      'تم اختيار الصورة بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  }
                } catch (e) {
                  // في حالة حدوث خطأ
                  Get.snackbar(
                    'خطأ',
                    'حدث خطأ أثناء اختيار الصورة. تأكد من منح الصلاحيات المطلوبة.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                }
              },
            ),

            const Divider(),

            // خيار المعرض
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x1A1565C0),  // أزرق 10%
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.photo_library, color: AppColors.primaryBlue),
              ),
              title: const Text('المعرض'),

              onTap: () async {
                // إغلاق النافذة أولاً
                Get.back();

                // انتظار قليل لضمان إغلاق النافذة
                await Future.delayed(const Duration(milliseconds: 300));

                // استخدام image_picker لفتح المعرض
                final ImagePicker picker = ImagePicker();
                try {
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,  // جودة الصورة (0-100)
                  );

                  // إذا تم اختيار صورة
                  if (image != null && image.path.isNotEmpty) {
                    // حفظ مسار الصورة في الـ Controller
                    if (type == 'personal') {
                      authController.setPersonalPhoto(image.path);
                    } else {
                      authController.setIdPhoto(image.path);
                    }

                    // رسالة نجاح
                    Get.snackbar(
                      'نجاح',
                      'تم اختيار الصورة بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  }
                } catch (e) {
                  // في حالة حدوث خطأ
                  Get.snackbar(
                    'خطأ',
                    'حدث خطأ أثناء اختيار الصورة. تأكد من منح الصلاحيات المطلوبة.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // _pickBirthDate - اختيار تاريخ الميلاد
  // ============================================================
  void _pickBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: authController.birthDate.value ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.navy,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    // إذا تم اختيار تاريخ، احفظه
    if (picked != null) {
      authController.setBirthDate(picked);
    }
  }
}

// ============================================================
// ملخص التعديلات الممكنة:
// ============================================================
// 1. إضافة حقول جديدة:
//    - أضف متغير في auth_controller.dart
//    - أضف _buildTextField() هنا
//
// 2. تفعيل الكاميرا/المعرض:
//    - أضف package: image_picker في pubspec.yaml
//    - استبدل الكود في _showPhotoPickerDialog
//
// 3. تغيير نطاق التواريخ:
//    - عدّل firstDate و lastDate في _pickBirthDate
//
// 4. إضافة تحقق إضافي:
//    - عدّل validatePersonalInfo() في auth_controller.dart
// ============================================================
