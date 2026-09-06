// Service profil pengguna lokal
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  UserProfileService._();

  static const String _keyDisplayName = 'profile_display_name';
  static const String _keyPrimaryLang = 'profile_primary_language';
  static const String _keyPrimaryLangCode = 'profile_primary_language_code';
  static const String _keyTranslationCount = 'profile_translation_count';
  static const String _keyCreatedAt = 'profile_created_at';
  static const String _keyIsPro = 'profile_is_pro_active';

  // ── Display Name ────────────────────────────────────────────
  static Future<String> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDisplayName) ?? 'Masukin nama lu';
  }

  static Future<void> setDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDisplayName, name.trim());
  }

  // ── Primary Language ────────────────────────────────────────
  static Future<String> getPrimaryLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPrimaryLang) ?? 'Indonesia';
  }

  static Future<String> getPrimaryLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPrimaryLangCode) ?? 'id';
  }

  static Future<void> setPrimaryLanguage(String lang, {String code = 'id'}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPrimaryLang, lang);
    await prefs.setString(_keyPrimaryLangCode, code);
  }

  // ── Translation Count ───────────────────────────────────────
  static Future<int> getTranslationCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTranslationCount) ?? 0;
  }

  static Future<void> incrementTranslationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyTranslationCount) ?? 0;
    await prefs.setInt(_keyTranslationCount, count + 1);
  }

  static Future<void> resetTranslationCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTranslationCount, 0);
  }

  // ── Created At (Tanggal Pertama Install/Buka) ────────────────
  static Future<String> getCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyCreatedAt);
    if (stored != null && stored.isNotEmpty) return stored;

    // Simpan tanggal pertama kali saat aplikasi digunakan
    final now = DateTime.now().toIso8601String().split('T').first;
    await prefs.setString(_keyCreatedAt, now);
    return now;
  }

  // ── PRO Status ──────────────────────────────────────────────
  static Future<bool> isProUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsPro) ?? true; // Default PRO aktif
  }

  static Future<void> setProStatus(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPro, active);
  }

  // ── Reset Seluruh Profil ────────────────────────────────────
  static Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final createdAt = await getCreatedAt(); // Tetap simpan tanggal install asli
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyPrimaryLang);
    await prefs.remove(_keyPrimaryLangCode);
    await prefs.remove(_keyTranslationCount);
    await prefs.setString(_keyCreatedAt, createdAt);
  }

  // ── Get All Profile Data ────────────────────────────────────
  static Future<Map<String, dynamic>> getProfile() async {
    return {
      'displayName': await getDisplayName(),
      'primaryLanguage': await getPrimaryLanguage(),
      'primaryLanguageCode': await getPrimaryLanguageCode(),
      'translationCount': await getTranslationCount(),
      'createdAt': await getCreatedAt(),
      'isPro': await isProUser(),
    };
  }
}
