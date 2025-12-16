// ============================================================
// registerApi.dart - API التسجيل
// ============================================================
// هذا الملف يحتوي على كلاس RegisterApi
// يتعامل مع السيرفر لتسجيل مستخدم جديد
// الوظائف:
//   - إرسال بيانات المستخدم الجديد للسيرفر
//   - استقبال رد السيرفر (نجاح/فشل)
// ============================================================

// ----------------------------------------------------------
// استيراد المكتبات
// ----------------------------------------------------------
import 'dart:convert';  // لتحويل JSON
import 'dart:io';       // للتعامل مع الملفات (الصور)
import 'package:http/http.dart' as http;  // مكتبة HTTP

// ============================================================
// RegisterApi - كلاس التسجيل
// ============================================================
class RegisterApi {

  // ----------------------------------------------------------
  // baseUrl - رابط السيرفر الأساسي
  // ----------------------------------------------------------
  // !!هام!! غيّر هذا الرابط لرابط السيرفر الخاص بك
  final String baseUrl = "http://10.210.241.144:8000";

  // المُنشئ الفارغ
  RegisterApi();

  // ----------------------------------------------------------
  // registerUser - دالة تسجيل مستخدم جديد
  // ----------------------------------------------------------
  // حسب مواصفات الباك التي عندكم:
  // POST /register  (Form-Data)
  // الحقول (Form-Data):
  // first_name, last_name, phone, password, role, birth_date
  // profile_photo (File), id_photo (File)
  //
  // تُرجع: Map<String, dynamic> يحتوي:
  //   - 'status': 1 للنجاح، 0 للفشل
  //   - 'message': رسالة توضيحية
  Future<Map<String, dynamic>> registerUser({
    required String mobile,         // رقم الهاتف (نستخدم الاسم mobile داخلياً لتوافق الواجهات)
    required String password,
    required String userType,       // 'tenant' أو 'landlord'
    required String firstName,
    required String lastName,
    required String birthDate,      // "YYYY-MM-DD"
    String? personalPhoto,          // مسار الصورة الشخصية
    String? idPhoto,                // مسار صورة الهوية
  }) async {

    // بناء الرابط الكامل
    // ✅ حسب الباك: /register
    final Uri uri1 = Uri.parse('$baseUrl/register');
    final Uri uri2 = Uri.parse('$baseUrl/api/register'); // fallback

    // ----------------------------------------------------------
    // تجهيز Form-Data (Multipart)
    // ----------------------------------------------------------
    Future<http.Response> send(Uri uri) async {
      final request = http.MultipartRequest('POST', uri);

      // Headers
      request.headers['Accept'] = 'application/json';

      // ملاحظة: في بعض المشاريع القديمة كان اسم الدور "owner"
      // نحولها تلقائياً إلى landlord حتى ما يصير تضارب
      final fixedRole = (userType == 'owner') ? 'landlord' : userType;

      // Fields
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['phone'] = mobile;
      request.fields['password'] = password;
      request.fields['role'] = fixedRole; // landlord/tenant
      request.fields['birth_date'] = birthDate;

      // Files (اختياري)
      if (personalPhoto != null && personalPhoto.trim().isNotEmpty) {
        final f = File(personalPhoto);
        if (f.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath('profile_photo', personalPhoto));
        }
      }
      if (idPhoto != null && idPhoto.trim().isNotEmpty) {
        final f = File(idPhoto);
        if (f.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath('id_photo', idPhoto));
        }
      }

      final streamed = await request.send().timeout(const Duration(seconds: 30));
      return http.Response.fromStream(streamed);
    }

    try {
      var response = await send(uri1);

      // fallback إذا السيرفر يستخدم /api
      if (response.statusCode == 404) {
        response = await send(uri2);
      }

      // طباعة للتصحيح
      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      // ----------------------------------------------------------
      // معالجة الرد
      // ----------------------------------------------------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        // نجاح
        return {
          'status': 1,
          'message': 'تم إرسال طلب التسجيل بنجاح (بانتظار موافقة الأدمن)',
        };
      }

      // محاولة قراءة رسالة من السيرفر
      String msg = 'حدث خطأ أثناء التسجيل';
      try {
        final body = jsonDecode(response.body);
        if (body is Map) {
          msg = (body['message'] ?? body['detail'] ?? body['error'] ?? msg).toString();
        }
      } catch (_) {}

      return {
        'status': 0,
        'message': msg,
      };

    } catch (e) {
      // ----------------------------------------------------------
      // معالجة الأخطاء
      // ----------------------------------------------------------
      print("REGISTER ERROR: $e");
      return {
        'status': 0,
        'message': 'حدث خطأ في الاتصال: $e',
      };
    }
  }
}
