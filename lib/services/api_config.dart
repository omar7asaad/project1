// services/api_config.dart
class ApiConfig {
  // غيّر هذا فقط حسب السيرفر عندك
  static const String baseUrl = 'http://10.210.241.144:8000';

  // بعض السيرفرات ترجع مسار صورة مثل: /storage/xxx.jpg
  // فنركّبها على baseUrl
  static String normalizeImageUrl(String raw) {
    if (raw.isEmpty) return raw;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return '$baseUrl$raw';
  }
}
