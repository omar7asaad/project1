// ============================================================
// success_icon.dart - أيقونة النجاح
// ============================================================
// هذا الـ Widget يعرض أيقونة نجاح (صح) داخل دائرة
// يُستخدم في الصفحة الرئيسية لإظهار نجاح تسجيل الدخول
// يمكن تخصيص الحجم واللون
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------

// flutter/material.dart = المكتبة الأساسية
// تحتوي على: Container, Icon, BoxDecoration, etc.
// ⚙️ لا يمكن تغييرها - مطلوبة
import 'package:flutter/material.dart';

// ============================================================
// SuccessIcon - الـ Widget الرئيسي
// ============================================================

// /// = تعليق توثيقي
// ⚙️ يمكن تغييره
/// أيقونة النجاح الدائرية

// class SuccessIcon = تعريف الكلاس
// ⚙️ يمكن تغيير الاسم
// extends StatelessWidget = بدون حالة داخلية
class SuccessIcon extends StatelessWidget {
  
  // ----------------------------------------------------------
  // المتغيرات (Properties)
  // ----------------------------------------------------------
  
  // final = ثابت
  // double = رقم عشري (للأحجام والأبعاد)
  // size = حجم الأيقونة الداخلية
  // ⚙️ يمكن تغيير الاسم: iconSize, diameter, etc.
  final double size;
  
  // Color = نوع اللون
  // iconColor = لون الأيقونة
  // ⚙️ يمكن تغيير الاسم: color, checkColor, etc.
  final Color iconColor;

  // ----------------------------------------------------------
  // Constructor (المُنشئ)
  // ----------------------------------------------------------
  // const = ثابت (أفضل للأداء)
  const SuccessIcon({
    // Key? key = مفتاح اختياري
    // ⚙️ لا تغيّره
    Key? key,
    
    // this.size = 60 = قيمة افتراضية
    // إذا لم يُمرر قيمة، يستخدم 60
    // ⚙️ يمكن تغيير القيمة الافتراضية
    // ⚙️ يمكن جعله required (بدون قيمة افتراضية)
    this.size = 60,
    
    // this.iconColor = Colors.green = قيمة افتراضية
    // ⚙️ يمكن تغيير اللون الافتراضي
    this.iconColor = Colors.green,
    
  // ) : super(key: key) = استدعاء الأب
  }) : super(key: key);

  // ----------------------------------------------------------
  // build - بناء الواجهة
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    
    // Container = حاوية مع زخرفة
    // ⚙️ يمكن استبداله بـ DecoratedBox للأداء
    return Container(
      
      // --------------------------------------------------
      // padding = المسافة الداخلية
      // --------------------------------------------------
      // EdgeInsets.all(30) = 30 بكسل من كل الجهات
      // المسافة بين الحدود والأيقونة الداخلية
      // ⚙️ يمكن تغييره:
      //   - EdgeInsets.all(20) = أصغر
      //   - EdgeInsets.all(40) = أكبر
      //   - EdgeInsets.symmetric(horizontal: 30, vertical: 20)
      padding: EdgeInsets.all(30),
      
      // --------------------------------------------------
      // decoration = الزخرفة (الشكل الخارجي)
      // --------------------------------------------------
      // BoxDecoration = زخرفة الصندوق
      decoration: BoxDecoration(
        
        // color = لون الخلفية
        // Color(0x331565C0) = أزرق 20% شفافية
        // 0x33 = 20% (من 00 إلى FF)
        // 1565C0 = اللون الأزرق
        // ⚙️ يمكن تغييره:
        //   - Color(0x4D1565C0) = أزرق 30%
        //   - Colors.green.withOpacity(0.2) = أخضر 20%
        color: Color(0x331565C0),
        
        // shape = شكل الحاوية
        // BoxShape.circle = دائرة
        // ⚙️ يمكن تغييره:
        //   - BoxShape.rectangle = مستطيل
        //   - (مع borderRadius للزوايا المستديرة)
        // ⚠️ لا يمكن استخدام borderRadius مع circle
        shape: BoxShape.circle,
        
        // border = الحدود (الإطار)
        // Border.all = حدود متساوية لكل الجهات
        border: Border.all(
          // color = لون الحدود
          // Color(0x4D64B5F6) = سماوي 30% شفافية
          // ⚙️ يمكن تغييره
          color: Color(0x4D64B5F6),
          
          // width = سماكة الحدود
          // ⚙️ يمكن تغييره: 1 لأرفع، 5 لأسمك
          width: 3,
        ),
        
        // ⚙️ يمكن إضافة ظل:
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.green.withOpacity(0.3),
        //     blurRadius: 20,
        //     spreadRadius: 5,
        //   ),
        // ],
      ),
      
      // --------------------------------------------------
      // child = الأيقونة الداخلية
      // --------------------------------------------------
      // Icon = widget الأيقونة
      child: Icon(
        // Icons.check_circle_outline_rounded = أيقونة صح دائرية
        // ⚙️ يمكن تغييره:
        //   - Icons.check = صح بسيط
        //   - Icons.check_circle = صح مع دائرة مملوءة
        //   - Icons.done = تم
        //   - Icons.done_all = تم الكل (علامتين)
        //   - Icons.verified = موثق
        //   - Icons.thumb_up = إعجاب
        Icons.check_circle_outline_rounded,
        
        // size = حجم الأيقونة
        // يأخذ القيمة من المتغير size
        // القيمة الافتراضية: 60
        // ⚙️ يمكن تغييره عند الاستخدام:
        //    SuccessIcon(size: 80)
        size: size,
        
        // color = لون الأيقونة
        // يأخذ القيمة من المتغير iconColor
        // القيمة الافتراضية: Colors.green
        // ⚙️ يمكن تغييره عند الاستخدام:
        //    SuccessIcon(iconColor: Colors.blue)
        color: iconColor,
      ),
    );
  }
}

// ============================================================
// ملخص ما يمكن تغييره:
// ============================================================
// ✅ الأيقونة: Icons.check_circle_outline_rounded
// ✅ الألوان: color, iconColor
// ✅ الأحجام: size, padding, border width
// ✅ الشكل: BoxShape.circle, BoxShape.rectangle
// ✅ القيم الافتراضية: size = 60, iconColor = Colors.green
//
// ❌ لا تغيّر:
// - @override, Widget build, BuildContext
// - super(key: key)
// - return
// ============================================================

// ============================================================
// طريقة الاستخدام:
// ============================================================
// 1. بالقيم الافتراضية:
//    SuccessIcon()
//
// 2. بحجم مخصص:
//    SuccessIcon(size: 80)
//
// 3. بلون مخصص:
//    SuccessIcon(iconColor: Colors.blue)
//
// 4. بحجم ولون مخصصين:
//    SuccessIcon(size: 100, iconColor: Colors.orange)
// ============================================================

// ============================================================
// أمثلة للتعديل:
// ============================================================
// 1. إضافة animation (نبض):
//    // يتطلب StatefulWidget + AnimationController
//    // أو استخدام package: animated_icon
//
// 2. أيقونة خطأ بدلاً من نجاح:
//    Icon(
//      Icons.error_outline,
//      color: Colors.red,
//    ),
//
// 3. أيقونة تحميل:
//    CircularProgressIndicator(
//      color: Colors.green,
//    ),
//
// 4. صورة بدلاً من أيقونة:
//    Image.asset(
//      'assets/images/success.png',
//      width: size,
//      height: size,
//    ),
// ============================================================
