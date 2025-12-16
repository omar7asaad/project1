// ============================================================
// app_colors.dart - ألوان التطبيق
// ============================================================
// هذا الملف يحتوي على جميع الألوان المستخدمة في التطبيق
// الهدف: تغيير لون واحد هنا يُغيّره في كل التطبيق
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  
  // ============================================================
  // الألوان الأساسية
  // ============================================================
  // Color(0xFF______) = لون بصيغة Hex
  // 0xFF = الشفافية (FF = كامل)
  // الـ 6 أرقام بعدها = اللون (مثل CSS بدون #)
  
  // الأزرق الأساسي
  // للتعديل: غيّر الكود اللوني
  // مثال: 0xFF1565C0 → 0xFFFF5722 (برتقالي)
  static const Color primaryBlue = Color(0xFF1565C0);
  
  // الكحلي الغامق (للخلفيات)
  static const Color darkNavy = Color(0xFF0D2137);
  
  // الكحلي العادي
  static const Color navy = Color(0xFF1A3A5C);
  
  // الكحلي الفاتح
  static const Color lightNavy = Color(0xFF2C5282);
  
  // الأزرق الفاتح (للتأثيرات)
  static const Color accentBlue = Color(0xFF42A5F5);
  
  // السماوي (للأيقونات والتفاصيل)
  static const Color skyBlue = Color(0xFF64B5F6);
  
  // ============================================================
  // ألوان إضافية
  // ============================================================
  
  // الأبيض
  static const Color white = Colors.white;
  
  // رمادي فاتح (لخلفية الصفحات)
  static const Color lightGrey = Color(0xFFF5F7FA);
  
  // رمادي (للنصوص الثانوية)
  static const Color grey = Color(0xFF9E9E9E);
  
  // ============================================================
  // التدرجات اللونية (Gradients)
  // ============================================================
  // تُستخدم للخلفيات والأزرار
  
  // تدرج الخلفية الرئيسي (من الكحلي الغامق للكحلي)
  // للتعديل: غيّر الألوان في colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,    // يبدأ من الأعلى
    end: Alignment.bottomCenter,   // ينتهي في الأسفل
    colors: [darkNavy, navy],      // الألوان
  );
  
  // تدرج أزرق (للأزرار والعناصر المميزة)
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,      // يبدأ من أعلى اليسار
    end: Alignment.bottomRight,    // ينتهي في أسفل اليمين
    colors: [primaryBlue, navy],   // الألوان
  );
  
  // ============================================================
  // كيفية إضافة لون جديد:
  // ============================================================
  // 1. أضف const هنا:
  //    static const Color newColor = Color(0xFFXXXXXX);
  //
  // 2. استخدمه في أي مكان:
  //    color: AppColors.newColor,
  //
  // للحصول على كود اللون:
  //   - Google "color picker" واختر اللون
  //   - انسخ كود Hex (مثل #FF5722)
  //   - احذف # وأضف 0xFF قبله (0xFFFF5722)
  // ============================================================
  
  // ============================================================
  // كيفية إضافة تدرج جديد:
  // ============================================================
  // static const LinearGradient newGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [color1, color2, color3],  // يمكن أكثر من لونين
  //   stops: [0.0, 0.5, 1.0],            // نقاط التدرج (اختياري)
  // );
  // ============================================================
}
