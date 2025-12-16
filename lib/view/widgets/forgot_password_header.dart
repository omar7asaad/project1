// view/widgets/forgot_password_header.dart
// ============================================================
// forgot_password_header.dart - رأس صفحة نسيت كلمة المرور
// ============================================================
// Widget يعرض: أيقونة القفل + العنوان + الوصف
// ============================================================

import 'package:flutter/material.dart';
import 'package:build/utils/app_colors.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // أيقونة القفل
        Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Color(0x4D1565C0),  // أزرق 30% شفافية
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0x8064B5F6),  // سماوي 50%
              width: 2,
            ),
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: 80,
            color: AppColors.skyBlue,
          ),
        ),

        SizedBox(height: 30),

        // العنوان
        Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 12),

        // الوصف
        Text(
          'أدخل رقم الموبايل المسجل وسنرسل لك\nرمز التحقق لإعادة تعيين كلمة المرور',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

