// config/api_config.dart
// ============================================================
// api_config.dart - إعدادات الـ API العامة
// ============================================================

class ApiConfig {
  // ----------------------------------------------------------
  // baseUrl - رابط السيرفر الأساسي
  // ----------------------------------------------------------
  // مثال محلي:
  //   Windows (نفس الجهاز): http://127.0.0.1:8000
  // مثال شبكة LAN:
  //   http://192.168.1.10:8000
  static const String baseUrl = "http://10.167.66.107:8000";

  // ----------------------------------------------------------
  // apiPrefix - بادئة Laravel API (غالباً /api)
  // ----------------------------------------------------------
  static const String apiPrefix = "/api";

  // ----------------------------------------------------------
  // timeouts - مهلات الاتصال
  // ----------------------------------------------------------
  static const Duration timeout = Duration(seconds: 25);
  static const Duration uploadTimeout = Duration(seconds: 35);

  // ----------------------------------------------------------
  // uri - بناء رابط مع Query Parameters
  // ----------------------------------------------------------
  static Uri uri(String path, {Map<String, String>? query}) {
    final full = "$baseUrl$apiPrefix$path";
    final u = Uri.parse(full);
    return (query == null || query.isEmpty)
        ? u
        : u.replace(queryParameters: query);
  }
}
