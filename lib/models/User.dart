// ============================================================
// User.dart - نموذج المستخدم
// ============================================================
// هذا الملف يحتوي على كلاس User الذي يمثل بيانات المستخدم
// يُستخدم لـ:
//   - تخزين معلومات المستخدم الحالي
//   - تحويل البيانات من/إلى JSON (للـ API)
//   - التحقق من حالة المستخدم
// ============================================================

// ============================================================
// User - كلاس المستخدم
// ============================================================
class User {
  
  // ----------------------------------------------------------
  // الخصائص (Properties)
  // ----------------------------------------------------------
  // final = لا يمكن تغييره بعد الإنشاء
  // ? = يمكن أن يكون null (اختياري)
  
  // معرف المستخدم في قاعدة البيانات
  // nullable لأن المستخدم الجديد ليس له id بعد
  final int? id;
  
  // رقم الموبايل (مطلوب)
  // required = يجب إعطاؤه قيمة عند الإنشاء
  final String mobile;
  
  // الاسم الأول (مطلوب)
  final String firstName;
  
  // الاسم الأخير (مطلوب)
  final String lastName;
  
  // نوع المستخدم (مطلوب)
  // القيم المحتملة: 'owner' (صاحب شقة) أو 'tenant' (مستأجر)
  // للتعديل: يمكن إضافة أنواع أخرى
  final String userType;
  
  // تاريخ الميلاد (اختياري)
  // يُخزن كنص بصيغة: "YYYY-MM-DD"
  final String? birthDate;
  
  // مسار الصورة الشخصية (اختياري)
  // قد يكون رابط URL أو مسار ملف محلي
  final String? personalPhoto;
  
  // مسار صورة الهوية (اختياري)
  final String? idPhoto;
  
  // هل تمت الموافقة على الحساب؟
  // false = قيد المراجعة
  // true = تمت الموافقة
  final bool isApproved;
  
  // رمز المصادقة (Token)
  // يُستخدم للتحقق من هوية المستخدم في الـ API calls
  final String? token;

  // ----------------------------------------------------------
  // Constructor - المُنشئ
  // ----------------------------------------------------------
  // {} = named parameters (معاملات مسماة)
  // required = مطلوب
  // this.x = اختصار لـ x = x
  User({
    this.id,
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.birthDate,
    this.personalPhoto,
    this.idPhoto,
    this.isApproved = false,  // القيمة الافتراضية = false
    this.token,
  });

  // ----------------------------------------------------------
  // fromJson - إنشاء User من JSON
  // ----------------------------------------------------------
  // factory = مُنشئ خاص يمكنه إرجاع كائن موجود أو جديد
  // يُستخدم لتحويل رد الـ API إلى كائن User
  // 
  // مثال الاستخدام:
  //   final json = {'mobile': '123', 'first_name': 'أحمد', ...};
  //   final user = User.fromJson(json);
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // json['key'] = الحصول على قيمة من الـ map
      // ?? = إذا كان null، استخدم القيمة البديلة
      id: json['id'],
      mobile: json['mobile'] ?? '',
      firstName: json['first_name'] ?? '',  // لاحظ: snake_case من الـ API
      lastName: json['last_name'] ?? '',
      userType: json['user_type'] ?? 'tenant',
      birthDate: json['birth_date'],
      personalPhoto: json['personal_photo'],
      idPhoto: json['id_photo'],
      isApproved: json['is_approved'] ?? false,
      token: json['token'],
    );
  }

  // ----------------------------------------------------------
  // toJson - تحويل User إلى JSON
  // ----------------------------------------------------------
  // يُستخدم لإرسال بيانات المستخدم إلى الـ API
  // 
  // مثال الاستخدام:
  //   final user = User(mobile: '123', ...);
  //   final json = user.toJson();
  //   // json = {'mobile': '123', 'first_name': '...', ...}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'birth_date': birthDate,
      'personal_photo': personalPhoto,
      'id_photo': idPhoto,
      'is_approved': isApproved,
    };
  }

  // ----------------------------------------------------------
  // fullName - خاصية محسوبة للاسم الكامل
  // ----------------------------------------------------------
  // get = getter (خاصية للقراءة فقط)
  // يُرجع الاسم الأول والأخير معاً
  // 
  // مثال الاستخدام:
  //   final user = User(firstName: 'أحمد', lastName: 'محمد', ...);
  //   print(user.fullName);  // أحمد محمد
  String get fullName => '$firstName $lastName';
}

// ============================================================
// ملخص التعديلات الممكنة:
// ============================================================
// 1. إضافة خاصية جديدة:
//    - أضف final String? newProperty; في الأعلى
//    - أضف في Constructor: this.newProperty,
//    - أضف في fromJson: newProperty: json['new_property'],
//    - أضف في toJson: 'new_property': newProperty,
//
// 2. تغيير أسماء الـ JSON:
//    - عدّل الـ keys في fromJson و toJson
//    - يجب أن تتطابق مع الـ API الخاص بك
//
// 3. إضافة validation:
//    - أضف دالة bool isValid() تتحقق من صحة البيانات
//
// 4. إضافة copyWith:
//    - لإنشاء نسخة معدلة من الـ User
//    - User copyWith({String? mobile, ...}) => User(...)
// ============================================================
