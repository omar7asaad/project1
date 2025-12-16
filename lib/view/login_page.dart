// view/login_page.dart
// ============================================================
// login_page.dart - صفحة تسجيل الدخول
// ============================================================
// هذه الصفحة تعرض نموذج تسجيل الدخول للمستخدم
// تحتوي على:
//   - حقل رقم الموبايل
//   - حقل كلمة المرور
//   - زر تسجيل الدخول
//   - زر إنشاء حساب جديد
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------
import 'package:flutter/material.dart';  // مكتبة Flutter الأساسية للواجهات
import 'package:get/get.dart';  // مكتبة GetX لإدارة الحالة والتنقل
import 'package:build/controllers/auth_controller.dart';  // متحكم المصادقة
import 'package:build/routes/app_routes.dart';  // أسماء الصفحات
import 'package:build/utils/app_colors.dart';  // ألوان التطبيق

// ============================================================
// LoginPage - صفحة تسجيل الدخول
// ============================================================
// StatelessWidget = ويدجت بدون حالة (لا يتغير بمفرده)
// نستخدم GetX لإدارة الحالة بدلاً من StatefulWidget
class LoginPage extends StatelessWidget {
  
  // ----------------------------------------------------------
  // الحصول على المتحكم
  // ----------------------------------------------------------
  // Get.find<AuthController>() = يجلب الـ Controller المسجل مسبقاً
  // يجب أن يكون AuthController مسجل في AppBindings
  final AuthController authController = Get.find<AuthController>();

  // ----------------------------------------------------------
  // build - بناء الواجهة
  // ----------------------------------------------------------
  // تُستدعى تلقائياً لبناء شكل الصفحة
  // context = معلومات عن الشاشة والثيم
  @override
  Widget build(BuildContext context) {
    
    // Scaffold = الهيكل الأساسي للصفحة
    // يوفر: AppBar, body, drawer, bottomNavigation, etc.
    return Scaffold(
      
      // body = المحتوى الرئيسي للصفحة
      body: Container(
        
        // ----------------------------------------------------------
        // حجم الـ Container
        // ----------------------------------------------------------
        // double.infinity = يأخذ كل المساحة المتاحة
        width: double.infinity,
        height: double.infinity,
        
        // ----------------------------------------------------------
        // الزخرفة (الخلفية)
        // ----------------------------------------------------------
        decoration: BoxDecoration(
          // تدرج لوني للخلفية
          // للتعديل: غيّر AppColors.primaryGradient في app_colors.dart
          gradient: AppColors.primaryGradient,
        ),
        
        // ----------------------------------------------------------
        // Stack - ترتيب العناصر فوق بعض
        // ----------------------------------------------------------
        // يسمح بوضع عناصر فوق بعضها (مثل الطبقات)
        child: Stack(
          children: [
            
            // ========================================================
            // الطبقة 1: صورة الخلفية
            // ========================================================
            // Positioned.fill = يملأ كل مساحة الـ Stack
            Positioned.fill(
              child: Opacity(
                // الشفافية (0.0 = شفاف كلياً، 1.0 = معتم كلياً)
                // للتعديل: غيّر القيمة (مثل 0.2 لصورة أوضح)
                opacity: 0.1,
                
                // Image.asset = صورة من المشروع (محلية)
                // للتعديل: ضع الصورة في assets/images/login_background.png
                child: Image.asset(
                  'assets/images/login_background.png',
                  
                  // fit = كيفية ملء الصورة للمساحة
                  // BoxFit.cover = تملأ المساحة مع قص الزائد
                  // BoxFit.contain = تظهر كاملة مع هوامش
                  // BoxFit.fill = تمدد لتملأ (قد تتشوه)
                  fit: BoxFit.cover,
                  
                  // errorBuilder = ماذا يُعرض إذا فشل تحميل الصورة
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // ========================================================
            // الطبقة 2: المحتوى الرئيسي
            // ========================================================
            // SafeArea = يُبعد المحتوى عن الـ notch والـ status bar
            SafeArea(
              child: SingleChildScrollView(
                // padding = المسافة الداخلية من جميع الجهات
                // للتعديل: EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                padding: EdgeInsets.all(24),
                
                // Column = ترتيب العناصر عمودياً
                child: Column(
                  // mainAxisAlignment = توزيع العناصر على المحور الرئيسي (عمودي)
                  // center = في المنتصف
                  // start = في الأعلى
                  // end = في الأسفل
                  // spaceBetween = مسافات متساوية بين العناصر
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    // مسافة فارغة في الأعلى
                    // للتعديل: غيّر الرقم لزيادة/تقليل المسافة
                    SizedBox(height: 40),
                    
                    // ====================================================
                    // الشعار (أيقونة الشقق)
                    // ====================================================
                    Container(
                      // padding = مسافة داخلية
                      padding: EdgeInsets.all(25),
                      
                      decoration: BoxDecoration(
                        // لون الخلفية مع شفافية
                        // withOpacity(0.3) = 30% من اللون
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        
                        // شكل الـ Container
                        // BoxShape.circle = دائرة
                        // BoxShape.rectangle = مستطيل (افتراضي)
                        shape: BoxShape.circle,
                        
                        // الإطار (الحدود)
                        border: Border.all(
                          color: AppColors.skyBlue.withOpacity(0.5),
                          width: 2,  // سماكة الإطار
                        ),
                        
                        // الظل
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 20,      // نعومة الظل
                            spreadRadius: 5,     // انتشار الظل
                          ),
                        ],
                      ),
                      
                      // الأيقونة داخل الدائرة
                      // للتعديل: غيّر Icons.apartment_rounded لأيقونة أخرى
                      // مثل: Icons.home, Icons.business, Icons.house
                      child: Icon(
                        Icons.apartment_rounded,
                        size: 80,  // حجم الأيقونة
                        color: AppColors.skyBlue,  // لون الأيقونة
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // ====================================================
                    // العنوان الرئيسي
                    // ====================================================
                    // للتعديل: غيّر النص واللون والحجم
                    Text(
                      'عقاراتي',  // النص
                      style: TextStyle(
                        color: Colors.white,           // لون النص
                        fontSize: 36,                  // حجم الخط
                        fontWeight: FontWeight.bold,   // سماكة الخط
                        letterSpacing: 2,              // المسافة بين الحروف
                      ),
                    ),
                    
                    // العنوان الفرعي
                    Text(
                      'ابحث عن شقتك المثالية',
                      style: TextStyle(
                        color: AppColors.skyBlue,
                        fontSize: 16,
                      ),
                    ),
                    
                    SizedBox(height: 50),
                    
                    // ====================================================
                    // حقل رقم الموبايل
                    // ====================================================
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        
                        // borderRadius = زوايا مستديرة
                        // للتعديل: غيّر الرقم (0 = زوايا حادة)
                        borderRadius: BorderRadius.circular(15),
                        
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),  // اتجاه الظل (x, y)
                          ),
                        ],
                      ),
                      
                      // TextField = حقل إدخال نص
                      child: TextField(
                        // نوع لوحة المفاتيح
                        // TextInputType.phone = أرقام فقط
                        // TextInputType.email = بريد إلكتروني
                        // TextInputType.text = نص عادي
                        keyboardType: TextInputType.phone,
                        
                        // اتجاه النص (للعربية)
                        textAlign: TextAlign.right,
                        
                        // onChanged = يُستدعى عند كل تغيير في النص
                        // يحفظ القيمة في الـ Controller
                        onChanged: (value) => authController.mobile.value = value,
                        
                        // زخرفة حقل الإدخال
                        decoration: InputDecoration(
                          hintText: "رقم الموبايل",  // النص التلميحي
                          hintStyle: TextStyle(color: Colors.grey),
                          
                          // الأيقونة في بداية الحقل
                          prefixIcon: Icon(Icons.phone_android, color: AppColors.navy),
                          
                          // إزالة الحدود
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // ====================================================
                    // حقل كلمة المرور
                    // ====================================================
                    // Obx = يُعيد البناء تلقائياً عند تغيّر القيم
                    // مطلوب لأن obscurePassword متغير يتغير
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        // obscureText = إخفاء النص (للكلمات السرية)
                        // true = يُظهر نقاط بدل الحروف
                        obscureText: authController.obscurePassword.value,
                        textAlign: TextAlign.right,
                        onChanged: (value) => authController.password.value = value,
                        
                        decoration: InputDecoration(
                          hintText: "كلمة المرور",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.lock, color: AppColors.navy),
                          
                          // suffixIcon = أيقونة في نهاية الحقل
                          // IconButton = زر بشكل أيقونة
                          suffixIcon: IconButton(
                            icon: Icon(
                              // يتغير الـ icon حسب حالة الإظهار/الإخفاء
                              authController.obscurePassword.value 
                                  ? Icons.visibility_off  // مخفي
                                  : Icons.visibility,      // ظاهر
                              color: Colors.grey,
                            ),
                            // عند الضغط: تبديل حالة الإظهار/الإخفاء
                            onPressed: () => authController.togglePasswordVisibility(),
                          ),
                          
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    )),
                    
                    SizedBox(height: 12),
                    
                    // ====================================================
                    // رابط "نسيت كلمة المرور"
                    // ====================================================
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            color: AppColors.skyBlue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // ====================================================
                    // زر تسجيل الدخول
                    // ====================================================
                    Obx(() => SizedBox(
                      // width: double.infinity = يأخذ كل العرض المتاح
                      width: double.infinity,
                      
                      // ElevatedButton = زر مرتفع (بخلفية)
                      child: ElevatedButton(
                        
                        // style = تنسيق الزر
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,  // لون الخلفية
                          foregroundColor: Colors.white,           // لون النص/الأيقونة
                          
                          // padding = المسافة الداخلية
                          padding: EdgeInsets.symmetric(vertical: 16),
                          
                          // شكل الزر
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),  // زوايا مستديرة
                          ),
                          
                          elevation: 5,  // ارتفاع الظل
                        ),
                        
                        // onPressed = ماذا يحدث عند الضغط
                        // null = الزر معطل (رمادي)
                        // إذا isLoading = true، نعطّل الزر
                        onPressed: authController.isLoading.value 
                            ? null  // معطل أثناء التحميل
                            : () async {
                                // استدعاء دالة تسجيل الدخول
                                final success = await authController.login();
                                
                                // إذا نجح تسجيل الدخول
                                if (success) {
                                  // ✅ الانتقال إلى واجهة عرض الشقق الخاصة بك
                                  Get.offAllNamed(AppRoutes.home);
                                }
                              },
                        
                        // محتوى الزر
                        // يتغير بين مؤشر التحميل والنص حسب الحالة
                        child: authController.isLoading.value
                            // أثناء التحميل: مؤشر دائري
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            // بدون تحميل: النص
                            : Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                    
                    SizedBox(height: 30),
                    
                    // ====================================================
                    // خط فاصل مع كلمة "أو"
                    // ====================================================
                    Row(
                      children: [
                        // Expanded = يأخذ المساحة المتبقية
                        Expanded(
                          // Divider = خط فاصل
                          child: Divider(color: Colors.white30),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'أو',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.white30),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 30),
                    
                    // ====================================================
                    // زر إنشاء حساب جديد
                    // ====================================================
                    SizedBox(
                      width: double.infinity,
                      
                      // OutlinedButton = زر بحدود فقط (بدون خلفية)
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          
                          // side = الحدود
                          side: BorderSide(color: AppColors.skyBlue, width: 2),
                          
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        
                        onPressed: () {
                          // مسح بيانات النموذج السابقة
                          authController.clearFormData();
                          
                          // الانتقال لصفحة التسجيل
                          Get.toNamed(AppRoutes.register);
                        },
                        
                        child: Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.skyBlue,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // ====================================================
                    // معلومات إضافية في الأسفل
                    // ====================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_work, color: Colors.white54, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'سجل كصاحب شقة أو كمستأجر',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ملخص التعديلات الممكنة:
// ============================================================
// 1. تغيير الألوان: عدّل في app_colors.dart
// 2. تغيير الصورة الخلفية: ضع الصورة في assets/images/login_background.png
// 3. تغيير النصوص: عدّل النص داخل Text()
// 4. تغيير الأيقونات: غيّر Icons.xxx لأيقونة أخرى
// 5. تغيير حجم العناصر: عدّل أرقام fontSize, size, padding
// 6. تغيير التنقل: عدّل Get.toNamed() أو Get.offAllNamed()
// 7. إضافة حقول: انسخ Container الخاص بـ TextField وعدّله
// ============================================================
