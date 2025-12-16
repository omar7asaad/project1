// view/widgets/guest_buttons.dart
// ============================================================
// guest_buttons.dart - أزرار الزائر
// ============================================================
// هذا الـ Widget يُعرض للمستخدم غير المسجل (الزائر)
// يحتوي على زرين: تسجيل الدخول وإنشاء حساب جديد
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------

// flutter/material.dart = المكتبة الأساسية للواجهات
// ⚙️ لا يمكن تغييرها - مطلوبة دائماً
import 'package:flutter/material.dart';

// get/get.dart = مكتبة GetX للتنقل وإدارة الحالة
// Get.offAllNamed() = التنقل مع حذف الصفحات السابقة
// ⚙️ لا يمكن تغييرها - مطلوبة للتنقل
import 'package:get/get.dart';

// app_colors.dart = ملف الألوان المخصصة
// ⚙️ يمكن تغيير المسار إذا نقلت الملف
import 'package:build/utils/app_colors.dart';

// ============================================================
// GuestButtons - الـ Widget الرئيسي
// ============================================================

// /// = تعليق توثيقي (documentation comment)
// يظهر عند hover على اسم الكلاس
// ⚙️ يمكن تغييره - اكتب وصف مناسب
/// أزرار تسجيل الدخول وإنشاء حساب للزائر

// class = تعريف كلاس جديد
// GuestButtons = اسم الكلاس
// ⚙️ يمكن تغيير الاسم - اختر اسم واضح
// extends StatelessWidget = يرث من StatelessWidget
// StatelessWidget = widget بدون حالة داخلية (ثابت)
// ⚙️ يمكن تغييره لـ StatefulWidget إذا تحتاج حالة
class GuestButtons extends StatelessWidget {
  
  // ----------------------------------------------------------
  // Constructor (المُنشئ)
  // ----------------------------------------------------------
  // const = ثابت (أفضل للأداء)
  // ⚙️ يمكن إزالة const - لكن أبقِها
  // GuestButtons = اسم المُنشئ (نفس اسم الكلاس)
  // ({...}) = معاملات مسماة (named parameters)
  // Key? key = مفتاح اختياري للـ Widget
  // ⚙️ لا تغيّره - اتركه كما هو
  const GuestButtons({Key? key}) : super(key: key);

  // ----------------------------------------------------------
  // build - بناء الواجهة
  // ----------------------------------------------------------
  // @override = إعادة تعريف دالة من الأب (StatelessWidget)
  // ⚙️ لا تغيّره - مطلوب
  @override
  
  // Widget = نوع الإرجاع
  // build = اسم الدالة (مطلوب)
  // BuildContext context = سياق البناء (معلومات الشاشة والثيم)
  // ⚙️ لا تغيّره - هذا هو التوقيع الصحيح
  Widget build(BuildContext context) {
    
    // return = إرجاع الـ Widget
    // Column = ترتيب عمودي (من الأعلى للأسفل)
    // ⚙️ يمكن تغييره لـ Row للترتيب الأفقي
    return Column(
      
      // children = قائمة العناصر الداخلية
      // [...] = قائمة (List)
      children: [
        
        // ========================================================
        // زر تسجيل الدخول (ElevatedButton)
        // ========================================================
        
        // SizedBox = صندوق بحجم محدد
        // يُستخدم هنا لجعل الزر بعرض كامل
        SizedBox(
          // width = العرض
          // double.infinity = أقصى عرض متاح
          // ⚙️ يمكن تغييره - 200 لعرض ثابت
          width: double.infinity,
          
          // child = العنصر الداخلي (واحد فقط)
          // ElevatedButton = زر مرتفع (بخلفية ملونة)
          // ⚙️ يمكن تغييره:
          //   - TextButton = زر نصي بدون خلفية
          //   - OutlinedButton = زر بحدود فقط
          //   - IconButton = زر أيقونة
          child: ElevatedButton(
            
            // --------------------------------------------------
            // style = تنسيق الزر
            // --------------------------------------------------
            // ElevatedButton.styleFrom = إنشاء تنسيق بسهولة
            // ⚙️ يمكن استخدام ButtonStyle() لتحكم أكثر
            style: ElevatedButton.styleFrom(
              
              // backgroundColor = لون خلفية الزر
              // ⚙️ يمكن تغييره - أي لون
              backgroundColor: AppColors.primaryBlue,
              
              // foregroundColor = لون النص والأيقونة
              // ⚙️ يمكن تغييره - أي لون
              foregroundColor: Colors.white,
              
              // padding = المسافة الداخلية
              // EdgeInsets.symmetric = متماثل
              // vertical: 16 = 16 بكسل أعلى وأسفل
              // ⚙️ يمكن تغييره:
              //   - EdgeInsets.all(16) = كل الجهات
              //   - EdgeInsets.only(top: 10, bottom: 10)
              padding: EdgeInsets.symmetric(vertical: 16),
              
              // shape = شكل الزر
              // RoundedRectangleBorder = مستطيل بزوايا مستديرة
              // ⚙️ يمكن تغييره:
              //   - CircleBorder() = دائري
              //   - StadiumBorder() = كبسولة
              shape: RoundedRectangleBorder(
                // borderRadius = نصف قطر الزوايا
                // BorderRadius.circular(15) = 15 بكسل لكل الزوايا
                // ⚙️ يمكن تغييره - 0 لحاد، 30 لدائري أكثر
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            
            // --------------------------------------------------
            // onPressed = عند الضغط على الزر
            // --------------------------------------------------
            // () => = دالة مختصرة (arrow function)
            // Get.offAllNamed = ينتقل ويحذف كل الصفحات السابقة
            // '/login' = مسار صفحة تسجيل الدخول
            // ⚙️ يمكن تغييره:
            //   - Get.toNamed('/login') = ينتقل مع إمكانية الرجوع
            //   - Get.to(() => LoginPage()) = ينتقل لـ widget مباشرة
            onPressed: () => Get.offAllNamed('/login'),
            
            // --------------------------------------------------
            // child = محتوى الزر
            // --------------------------------------------------
            // Text = نص
            // ⚙️ يمكن تغييره:
            //   - Row([Icon, Text]) = أيقونة مع نص
            //   - Icon() = أيقونة فقط
            child: Text(
              // النص المعروض
              // ⚙️ يمكن تغييره
              'تسجيل الدخول',
              
              // style = تنسيق النص
              style: TextStyle(
                // fontSize = حجم الخط
                // ⚙️ يمكن تغييره - 14, 16, 20, etc.
                fontSize: 18,
                
                // fontWeight = سماكة الخط
                // FontWeight.bold = عريض
                // ⚙️ يمكن تغييره - normal, w500, w600, etc.
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        // مسافة عمودية بين الزرين
        // ⚙️ يمكن تغييره - height: 20 لمسافة أكبر
        SizedBox(height: 16),
        
        // ========================================================
        // زر إنشاء حساب جديد (OutlinedButton)
        // ========================================================
        
        SizedBox(
          width: double.infinity,
          
          // OutlinedButton = زر بحدود فقط (بدون خلفية)
          // ⚙️ الفرق عن ElevatedButton:
          //   - ElevatedButton = خلفية ملونة
          //   - OutlinedButton = حدود فقط، خلفية شفافة
          child: OutlinedButton(
            
            // --------------------------------------------------
            // style = تنسيق الزر
            // --------------------------------------------------
            style: OutlinedButton.styleFrom(
              
              // foregroundColor = لون النص والأيقونة
              // ⚙️ يمكن تغييره
              foregroundColor: Colors.white,
              
              // padding = المسافة الداخلية
              padding: EdgeInsets.symmetric(vertical: 16),
              
              // side = الحدود (الإطار)
              // BorderSide = تعريف الحدود
              // ⚙️ يمكن تغييره
              side: BorderSide(
                // color = لون الحدود
                color: AppColors.skyBlue,
                // width = سماكة الحدود
                // ⚙️ يمكن تغييره - 1 لأرفع، 4 لأسمك
                width: 2,
              ),
              
              // shape = شكل الزر
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            
            // onPressed = عند الضغط
            // '/register' = مسار صفحة التسجيل
            // ⚙️ يمكن تغيير المسار
            onPressed: () => Get.offAllNamed('/register'),
            
            // child = محتوى الزر
            child: Text(
              'إنشاء حساب جديد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // لون النص مختلف (سماوي)
                // ⚙️ يمكن تغييره
                color: AppColors.skyBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ملخص ما يمكن تغييره:
// ============================================================
// ✅ النصوص: 'تسجيل الدخول', 'إنشاء حساب جديد'
// ✅ الألوان: backgroundColor, foregroundColor, color
// ✅ الأحجام: fontSize, padding, width, height
// ✅ الزوايا: borderRadius (0 لـ 50)
// ✅ الحدود: side (color, width)
// ✅ المسارات: '/login', '/register'
// ✅ نوع الزر: ElevatedButton, OutlinedButton, TextButton
//
// ❌ لا تغيّر:
// - @override, Widget build, BuildContext
// - super(key: key)
// - return, children
// ============================================================

// ============================================================
// أمثلة للتعديل:
// ============================================================
// 1. إضافة أيقونة للزر:
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: [
//        Icon(Icons.login),
//        SizedBox(width: 8),
//        Text('تسجيل الدخول'),
//      ],
//    ),
//
// 2. تغيير لون الزر عند الضغط:
//    style: ElevatedButton.styleFrom(
//      backgroundColor: AppColors.primaryBlue,
//      overlayColor: Colors.white.withOpacity(0.2),
//    ),
//
// 3. إضافة ظل للزر:
//    style: ElevatedButton.styleFrom(
//      elevation: 8,
//      shadowColor: Colors.blue,
//    ),
// ============================================================
