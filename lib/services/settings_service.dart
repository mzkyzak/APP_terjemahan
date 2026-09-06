// Service pengaturan aplikasi
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'translation_service.dart';

class SettingsService {
  SettingsService._();

  // ── Keys ────────────────────────────────────────────────────
  static const String _keyAutoDetect = 'setting_auto_detect';
  static const String _keyHaptic = 'setting_haptic_enabled';
  static const String _keyVoiceGender = 'setting_voice_gender'; // 'male' or 'female'
  static const String _keyThemeMode = 'is_dark_mode'; // backward compat
  static const String _keyThemeOption = 'setting_theme_option'; // system/dark/light
  static const String _keyLastFromLang = 'last_from_lang_code';
  static const String _keyLastToLang = 'last_to_lang_code';
  static const String _keyLastInputText = 'last_input_text';
  static const String _keyLastTranslatedText = 'last_translated_text';

  // ── Voice Gender (Pria / Wanita) ────────────────────────────
  /// Returns 'male' (Pria) or 'female' (Wanita). Default: 'male'
  static Future<String> getVoiceGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyVoiceGender) ?? 'male';
  }

  static Future<void> setVoiceGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVoiceGender, gender);
  }

  // ── Last Active State Persistence (Anti Hilang Data) ────────
  static Future<String> getLastFromLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastFromLang) ?? 'auto';
  }

  static Future<void> setLastFromLang(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastFromLang, code);
  }

  static Future<String> getLastToLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastToLang) ?? 'en';
  }

  static Future<void> setLastToLang(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastToLang, code);
  }

  static Future<String> getLastInputText() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastInputText) ?? '';
  }

  static Future<void> setLastInputText(String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastInputText, text);
  }

  static Future<String> getLastTranslatedText() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastTranslatedText) ?? '';
  }

  static Future<void> setLastTranslatedText(String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastTranslatedText, text);
  }

  // ── Auto Detect ─────────────────────────────────────────────
  static Future<bool> getAutoDetect() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoDetect) ?? true;
  }

  static Future<void> setAutoDetect(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoDetect, value);
  }

  // ── Haptic Feedback ─────────────────────────────────────────
  static Future<bool> getHapticEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHaptic) ?? true;
  }

  static Future<void> setHapticEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptic, value);
  }

  // ── Theme Mode ──────────────────────────────────────────────
  /// Returns 'system', 'dark', or 'light'
  static Future<String> getThemeOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeOption) ?? 'dark';
  }

  static Future<void> setThemeOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeOption, option);
    // Backward compat: also update the boolean key
    await prefs.setBool(_keyThemeMode, option == 'dark');
  }

  // ── Test API Connection ─────────────────────────────────────
  /// Returns a human-readable result message and success bool.
  static Future<({bool success, String message})> testApiConnection() async {
    final apiKey = await TranslationService.getApiKey();
    final provider = await TranslationService.getProvider();

    if (apiKey.isEmpty) {
      return (success: false, message: 'API Key belum diisi.');
    }

    try {
      switch (provider) {
        case TranslationProvider.googleCloud:
          final url = Uri.parse(
            'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
          );
          final res = await http.post(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({'q': 'hello', 'target': 'id', 'format': 'text'}),
          ).timeout(const Duration(seconds: 10));
          if (res.statusCode == 200) {
            return (success: true, message: 'Google Cloud API terhubung! ✅');
          }
          return (success: false, message: 'Error ${res.statusCode}: ${res.body}');

        case TranslationProvider.deepl:
          final isFreeKey = apiKey.endsWith(':fx');
          final endpoint = isFreeKey
              ? 'https://api-free.deepl.com/v2/translate'
              : 'https://api.deepl.com/v2/translate';
          final res = await http.post(
            Uri.parse(endpoint),
            headers: {
              'Authorization': 'DeepL-Auth-Key $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'text': ['hello'], 'target_lang': 'ID'}),
          ).timeout(const Duration(seconds: 10));
          if (res.statusCode == 200) {
            return (success: true, message: 'DeepL API terhubung! ✅');
          }
          return (success: false, message: 'Error ${res.statusCode}');

        case TranslationProvider.openAi:
          final res = await http.post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'gpt-4o-mini',
              'messages': [
                {'role': 'user', 'content': 'Say "OK"'},
              ],
              'max_tokens': 5,
            }),
          ).timeout(const Duration(seconds: 15));
          if (res.statusCode == 200) {
            return (success: true, message: 'OpenAI API terhubung! ✅');
          }
          return (success: false, message: 'Error ${res.statusCode}');

        case TranslationProvider.googleFree:
          return (success: true, message: 'Mesin gratis tidak memerlukan API Key.');
      }
    } catch (e) {
      debugPrint('Test API Connection error: $e');
      return (success: false, message: 'Gagal terhubung: ${e.toString().split(":").first}');
    }
  }
}
