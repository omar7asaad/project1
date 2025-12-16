// view/widgets/account_type_selector.dart
// ============================================================
// account_type_selector.dart - أزرار اختيار نوع الحساب
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------
// flutter/material.dart = المكتبة الأساسية للواجهات
// تحتوي على: Text, Container, Row, Column, Icon, etc.
// ⚙️ لا يمكن تغييرها - مطلوبة دائماً
import 'package:flutter/material.dart';

// app_colors.dart = ملف الألوان المخصصة للتطبيق
// ⚙️ يمكن تغييرها - إذا غيرت اسم الملف أو المسار
import 'package:build/utils/app_colors.dart';

// ============================================================
// AccountTypeSelector - الـ Widget الرئيسي
// ============================================================
// /// = تعليق توثيقي (يظهر عند hover)
// ⚙️ يمكن تغييره - غيّر النص للوصف المناسب
/// Widget لاختيار نوع الحساب (مستأجر / صاحب شقة)

// class = تعريف كلاس (صنف)
// AccountTypeSelector = اسم الكلاس
// ⚙️ يمكن تغييره - اختر اسم يصف الوظيفة
// extends StatelessWidget = يرث من StatelessWidget (بدون حالة)
// ⚙️ يمكن تغييره - StatefulWidget إذا تحتاج حالة داخلية
class AccountTypeSelector extends StatelessWidget {
  
  // ----------------------------------------------------------
  // المتغيرات (Properties)
  // ----------------------------------------------------------
  
  // final = قيمة ثابتة لا تتغير بعد التعيين
  // String = نوع البيانات (نص)
  // selectedType = اسم المتغير (النوع المحدد حالياً)
  // ⚙️ يمكن تغيير الاسم - اختر اسم واضح
  final String selectedType;
  
  // Function(String) = دالة تستقبل String كمعامل
  // onTypeSelected = اسم الدالة (عند اختيار النوع)
  // ⚙️ يمكن تغيير الاسم والنوع حسب الحاجة
  final Function(String) onTypeSelected;

  // ----------------------------------------------------------
  // Constructor (المُنشئ)
  // ----------------------------------------------------------
  // const = يُنشئ كائن ثابت (أفضل للأداء)
  // ⚙️ يمكن إزالة const - لكن أبقِها للأداء
  const AccountTypeSelector({
    // Key? = مفتاح اختياري للـ Widget
    // يُستخدم للتمييز بين الـ widgets
    // ⚙️ لا تغيّره - اتركه كما هو
    Key? key,
    
    // required = مطلوب (يجب تمريره)
    // this.selectedType = يُعيّن قيمة المتغير selectedType
    // ⚙️ يمكن إزالة required - لكن يجب إعطاء قيمة افتراضية
    required this.selectedType,
    
    required this.onTypeSelected,
    
  // ) : super(key: key) = استدعاء constructor الأب
  // ⚙️ لا تغيّره - مطلوب للوراثة
  }) : super(key: key);

  // ----------------------------------------------------------
  // build - بناء الواجهة
  // ----------------------------------------------------------
  // @override = إعادة تعريف دالة من الأب
  // ⚙️ لا تغيّره - مطلوب
  @override
  
  // Widget = نوع الإرجاع (يُرجع widget)
  // build = اسم الدالة (مطلوب)
  // BuildContext context = معلومات عن الشاشة والثيم
  // ⚙️ لا تغيّره - هذا هو التوقيع الصحيح
  Widget build(BuildContext context) {
    
    // return = إرجاع القيمة
    // Column = ترتيب عمودي (من الأعلى للأسفل)
    // ⚙️ يمكن تغييره - Row للترتيب الأفقي
    return Column(
      
      // children = العناصر الداخلية (قائمة)
      // ⚙️ يمكن إضافة/حذف عناصر
      children: [
        
        // --------------------------------------------------
        // عنوان "نوع الحساب"
        // --------------------------------------------------
        // Text = عنصر نص
        // ⚙️ يمكن تغييره - غيّر النص للمناسب
        Text(
          'نوع الحساب',  // ⚙️ النص - يمكن تغييره
          
          // style = تنسيق النص
          // TextStyle = كائن التنسيق
          style: TextStyle(
            // color = لون النص
            // Colors.white = أبيض
            // ⚙️ يمكن تغييره - أي لون: Colors.red, Color(0xFF...)
            color: Colors.white,
            
            // fontSize = حجم الخط (بالبكسل)
            // ⚙️ يمكن تغييره - أي رقم: 12, 16, 20, etc.
            fontSize: 14,
            
            // fontWeight = سماكة الخط
            // FontWeight.bold = عريض (w700)
            // ⚙️ يمكن تغييره - w100 لـ w900 أو normal
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // SizedBox = مسافة فارغة
        // height = الارتفاع (مسافة عمودية)
        // ⚙️ يمكن تغييره - أي رقم، أو width للمسافة الأفقية
        SizedBox(height: 10),
        
        // --------------------------------------------------
        // صف الأزرار
        // --------------------------------------------------
        // Row = ترتيب أفقي (من اليمين لليسار بالعربي)
        // ⚙️ يمكن تغييره - Column للترتيب العمودي
        Row(
          children: [
            
            // زر مستأجر
            // Expanded = يأخذ المساحة المتبقية بالتساوي
            // ⚙️ يمكن تغييره - Flexible للمرونة، أو حذفه لحجم ثابت
            Expanded(
              // child = العنصر الداخلي (عنصر واحد)
              child: _AccountTypeButton(
                // label = النص الظاهر
                // ⚙️ يمكن تغييره
                label: 'مستأجر',
                
                // icon = الأيقونة
                // Icons.person = أيقونة شخص
                // ⚙️ يمكن تغييره - أي أيقونة من Icons.xxx
                icon: Icons.person,
                
                // type = نوع الحساب (للمقارنة)
                // ⚙️ يمكن تغييره - أي نص تريده
                type: 'tenant',
                
                // isSelected = هل محدد؟
                // selectedType == 'tenant' = مقارنة
                // ⚙️ المنطق صحيح - لا تغيّره
                isSelected: selectedType == 'tenant',
                
                // onTap = عند الضغط
                // () => = دالة مختصرة (arrow function)
                // onTypeSelected('tenant') = استدعاء الدالة مع القيمة
                // ⚙️ المنطق صحيح - لا تغيّره
                onTap: () => onTypeSelected('tenant'),
              ),
            ),
            
            // مسافة بين الزرين
            // ⚙️ يمكن تغييره - width: 20 لمسافة أكبر
            SizedBox(width: 10),
            
            // زر صاحب شقة
            Expanded(
              child: _AccountTypeButton(
                label: 'صاحب شقة',
                icon: Icons.home_work,
                type: 'landlord',
                isSelected: selectedType == 'landlord',
                onTap: () => onTypeSelected('landlord'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// _AccountTypeButton - زر نوع الحساب الفردي
// ============================================================
// _ في البداية = private (خاص بهذا الملف فقط)
// ⚙️ يمكن إزالة _ - لجعله public (متاح للملفات الأخرى)
class _AccountTypeButton extends StatelessWidget {
  
  // ----------------------------------------------------------
  // المتغيرات
  // ----------------------------------------------------------
  // final String label = نص الزر
  final String label;
  
  // final IconData icon = بيانات الأيقونة
  // IconData = نوع خاص للأيقونات
  final IconData icon;
  
  // final String type = نوع الحساب
  final String type;
  
  // final bool isSelected = هل محدد؟
  // bool = نوع منطقي (true/false)
  final bool isSelected;
  
  // final VoidCallback onTap = دالة بدون معاملات وبدون إرجاع
  // VoidCallback = اختصار لـ void Function()
  final VoidCallback onTap;

  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  const _AccountTypeButton({
    required this.label,
    required this.icon,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });
  // ⚙️ ملاحظة: لا يوجد Key? key هنا لأنه private widget

  @override
  Widget build(BuildContext context) {
    
    // ----------------------------------------------------------
    // GestureDetector - كاشف اللمس
    // ----------------------------------------------------------
    // يكتشف: onTap, onLongPress, onDoubleTap, onPan, etc.
    // ⚙️ يمكن تغييره - InkWell لتأثير الموجة، أو إزالته
    return GestureDetector(
      
      // onTap = عند الضغط (نقرة واحدة)
      // ⚙️ يمكن إضافة: onLongPress, onDoubleTap
      onTap: onTap,
      
      // child = العنصر الداخلي
      child: Container(
        
        // padding = المسافة الداخلية
        // EdgeInsets.symmetric = متماثل (عمودي/أفقي)
        // vertical: 12 = 12 بكسل من الأعلى والأسفل
        // ⚙️ يمكن تغييره - EdgeInsets.all(16) لكل الجهات
        padding: EdgeInsets.symmetric(vertical: 12),
        
        // --------------------------------------------------
        // decoration = الزخرفة (الشكل الخارجي)
        // --------------------------------------------------
        // BoxDecoration = زخرفة الصندوق
        // ⚙️ يمكن حذفه - للحصول على container بدون تنسيق
        decoration: BoxDecoration(
          
          // gradient = تدرج لوني
          // isSelected ? X : Y = شرط ternary
          // إذا محدد: استخدم التدرج، وإلا: null
          // ⚙️ يمكن تغييره - أي LinearGradient أو RadialGradient
          gradient: isSelected ? AppColors.blueGradient : null,
          
          // color = لون الخلفية
          // !isSelected = ليس محدد
          // Color(0x1AFFFFFF) = أبيض 10% شفافية
          // ⚙️ يمكن تغييره - أي لون
          color: !isSelected ? Color(0x1AFFFFFF) : null,
          
          // borderRadius = زوايا مستديرة
          // BorderRadius.circular(10) = 10 بكسل لكل الزوايا
          // ⚙️ يمكن تغييره - 0 لزوايا حادة، 30 لدائرية أكثر
          borderRadius: BorderRadius.circular(10),
          
          // border = الحدود (الإطار)
          // Border.all = حدود لكل الجهات
          border: Border.all(
            // color = لون الحدود
            // ⚙️ يمكن تغييره
            color: isSelected ? AppColors.skyBlue : Colors.white30,
            
            // width = سماكة الحدود
            // ⚙️ يمكن تغييره - 1 لأرفع، 4 لأسمك
            width: 2,
          ),
        ),
        
        // --------------------------------------------------
        // المحتوى الداخلي
        // --------------------------------------------------
        child: Row(
          // mainAxisAlignment = المحاذاة على المحور الرئيسي
          // MainAxisAlignment.center = في المنتصف
          // ⚙️ يمكن تغييره:
          //   - start = البداية
          //   - end = النهاية
          //   - spaceBetween = مسافات بين العناصر
          //   - spaceAround = مسافات حول العناصر
          //   - spaceEvenly = مسافات متساوية
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            // --------------------------------------------------
            // أيقونة الصح (إذا محدد)
            // --------------------------------------------------
            // if (isSelected) = شرط - يُنفذ فقط إذا محدد
            // ...[] = spread operator - يفك القائمة
            // ⚙️ يمكن حذفه - لإزالة علامة الصح
            if (isSelected) ...[
              // أيقونة الصح الخضراء
              Icon(
                Icons.check_circle,  // ⚙️ يمكن تغييره - Icons.done, Icons.check
                color: Colors.green,  // ⚙️ يمكن تغييره
                size: 16,  // ⚙️ يمكن تغييره
              ),
              SizedBox(width: 4),
            ],
            
            // --------------------------------------------------
            // الأيقونة الرئيسية
            // --------------------------------------------------
            Icon(
              icon,  // الأيقونة الممررة من الأعلى
              size: 18,  // ⚙️ يمكن تغييره
              color: Colors.white,  // ⚙️ يمكن تغييره
            ),
            
            SizedBox(width: 4),
            
            // --------------------------------------------------
            // نص الزر
            // --------------------------------------------------
            Text(
              label,  // النص الممرر من الأعلى
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ملخص ما يمكن تغييره:
// ============================================================
// ✅ النصوص: 'نوع الحساب', 'مستأجر', 'صاحب شقة'
// ✅ الألوان: Colors.white, Color(0x...), AppColors.xxx
// ✅ الأحجام: fontSize, size, width, height
// ✅ الأيقونات: Icons.person, Icons.home_work, etc.
// ✅ المسافات: SizedBox, padding, margin
// ✅ الزوايا: borderRadius
// ✅ الحدود: border width, color
//
// ❌ لا تغيّر:
// - @override, Widget build, BuildContext
// - super(key: key)
// - return
// ============================================================
