// Service mesin terjemahan hybrid
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'language_service.dart';

enum TranslationProvider { googleFree, googleCloud, deepl, openAi }

class TranslationService {
  TranslationService._();

  static const String _keyApiKey = 'user_translation_api_key';
  static const String _keyProvider = 'user_translation_provider';

  static final GoogleTranslator _defaultTranslator = GoogleTranslator();

  // ── Ambil API Key tersimpan ─────────────────────────────────
  static Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyApiKey) ?? '';
  }

  // ── Simpan API Key ─────────────────────────────────────────
  static Future<void> setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, key.trim());
  }

  // ── Ambil Provider tersimpan ────────────────────────────────
  static Future<TranslationProvider> getProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyProvider) ?? 'googleFree';
    return TranslationProvider.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TranslationProvider.googleFree,
    );
  }

  // ── Simpan Provider ────────────────────────────────────────
  static Future<void> setProvider(TranslationProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProvider, provider.name);
  }

  // ── Fungsi utama terjemahan hybrid ─────────────────────────
  static Future<String> translate({
    required String text,
    required String fromCode,
    required String toCode,
  }) async {
    final normalizedFrom = LanguageService.normalize(fromCode);
    final normalizedTo = LanguageService.normalize(toCode);
    final apiKey = await getApiKey();
    final provider = await getProvider();

    // Jika pengguna memasukkan API Key dan memilih Cloud Engine
    if (apiKey.isNotEmpty) {
      try {
        switch (provider) {
          case TranslationProvider.googleCloud:
            return await _translateGoogleCloud(text, normalizedFrom, normalizedTo, apiKey);
          case TranslationProvider.deepl:
            return await _translateDeepL(text, normalizedFrom, normalizedTo, apiKey);
          case TranslationProvider.openAi:
            return await _translateOpenAI(text, normalizedFrom, normalizedTo, apiKey);
          case TranslationProvider.googleFree:
            break;
        }
      } catch (e) {
        debugPrint("API Key translation failed: $e, falling back to default engine");
      }
    }

    // Fallback Bawaan (Gratis) - Menggunakan Multi-Endpoint Direct Google API
    return await _translateGoogleFree(text, normalizedFrom, normalizedTo);
  }

  // ── Google Translate Endpoint Gratis (Multi-Endpoint Fallback) ──
  static Future<String> _translateGoogleFree(
    String text,
    String from,
    String to,
  ) async {
    // 1. Coba Endpoint Primer (Google Translate GTX)
    try {
      final res = await _fetchGtx(text, from, to);
      if (res.isNotEmpty) return res;
    } catch (e) {
      debugPrint("Primary GTX endpoint failed: $e, trying secondary endpoint");
    }

    // 2. Coba Endpoint Sekunder (Chrome Extension API)
    try {
      final res = await _fetchDictChrome(text, from, to);
      if (res.isNotEmpty) return res;
    } catch (e) {
      debugPrint("Secondary Chrome API endpoint failed: $e, trying fallback translator");
    }

    // 3. Coba Legacy translator package (jika didukung)
    try {
      final translation = await _defaultTranslator.translate(
        text,
        from: from,
        to: to,
      );
      if (translation.text.isNotEmpty) return translation.text;
    } catch (e) {
      debugPrint("Translator package failed: $e, trying mobile web endpoint");
    }

    // 4. Coba Mobile Web Scrape Endpoint
    try {
      final res = await _fetchMobileWeb(text, from, to);
      if (res.isNotEmpty) return res;
    } catch (e) {
      debugPrint("Mobile web endpoint failed: $e, trying MyMemory open API");
    }

    // 5. Coba MyMemory Free Open API (100% Gratis & Terbuka)
    try {
      final res = await _fetchMyMemory(text, from, to);
      if (res.isNotEmpty) return res;
    } catch (e) {
      debugPrint("MyMemory open API failed: $e");
    }

    throw Exception("Bahasa target ($to) tidak dapat diterjemahkan saat ini atau terjadi gangguan koneksi.");
  }

  // ── Endpoint 1: GTX Single API ──────────────────────────────
  static Future<String> _fetchGtx(String text, String from, String to) async {
    final url = Uri.parse(
      'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$from&tl=$to&dt=t&dt=bd&dj=1&q=${Uri.encodeComponent(text)}',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('sentences')) {
        final sentences = data['sentences'] as List;
        final buffer = StringBuffer();
        for (final item in sentences) {
          if (item is Map && item.containsKey('trans')) {
            buffer.write(item['trans']);
          }
        }
        final result = buffer.toString().trim();
        if (result.isNotEmpty) return result;
      }
      // Fallback jika format respons berbentuk nested list
      if (data is List && data.isNotEmpty && data[0] is List) {
        final buffer = StringBuffer();
        for (final part in data[0]) {
          if (part is List && part.isNotEmpty && part[0] != null) {
            buffer.write(part[0].toString());
          }
        }
        final result = buffer.toString().trim();
        if (result.isNotEmpty) return result;
      }
    }
    throw Exception("GTX status code: ${response.statusCode}");
  }

  // ── Endpoint 2: Dict Chrome Extension API ───────────────────
  static Future<String> _fetchDictChrome(String text, String from, String to) async {
    final url = Uri.parse(
      'https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=$from&tl=$to&q=${Uri.encodeComponent(text)}',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        if (data[0] is String) {
          return data.join(' ').trim();
        } else if (data[0] is List && (data[0] as List).isNotEmpty) {
          return (data[0] as List).first.toString().trim();
        }
      }
    }
    throw Exception("Dict Chrome status code: ${response.statusCode}");
  }

  // ── Endpoint 3: Google Mobile Web Translation ───────────────
  static Future<String> _fetchMobileWeb(String text, String from, String to) async {
    final url = Uri.parse(
      'https://translate.google.com/m?sl=$from&tl=$to&q=${Uri.encodeComponent(text)}',
    );
    final response = await http.get(
      url,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = response.body;
      final match = RegExp(r'<div class="result-container">(.*?)<\/div>', dotAll: true).firstMatch(body);
      if (match != null && match.group(1) != null) {
        var translated = match.group(1)!;
        // Decode basic HTML entities
        translated = translated
            .replaceAll('&quot;', '"')
            .replaceAll('&#39;', "'")
            .replaceAll('&amp;', '&')
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>');
        return translated.trim();
      }
    }
    throw Exception("Mobile web status code: ${response.statusCode}");
  }

  // ── Endpoint 4: MyMemory Open Translation API (Gratis) ───────
  static Future<String> _fetchMyMemory(String text, String from, String to) async {
    final langFrom = from == 'auto' ? 'id' : from;
    final langpair = '$langFrom|$to';
    final url = Uri.parse(
      'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=${Uri.encodeComponent(langpair)}',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('responseData') && data['responseData'] is Map) {
        final trans = data['responseData']['translatedText'];
        if (trans != null && trans is String && trans.trim().isNotEmpty) {
          // Unescape HTML
          var result = trans
              .replaceAll('&quot;', '"')
              .replaceAll('&#39;', "'")
              .replaceAll('&amp;', '&')
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>');
          return result.trim();
        }
      }
    }
    throw Exception("MyMemory status code: ${response.statusCode}");
  }

  // ── Google Cloud Translation API v2 ────────────────────────
  static Future<String> _translateGoogleCloud(
    String text,
    String from,
    String to,
    String apiKey,
  ) async {
    final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'q': text,
        'source': from == 'auto' ? '' : from,
        'target': to,
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final translations = json['data']['translations'] as List;
      if (translations.isNotEmpty) {
        return translations.first['translatedText'] as String;
      }
    }
    throw Exception('Google Cloud API Error: ${response.statusCode} - ${response.body}');
  }

  // ── DeepL API ──────────────────────────────────────────────
  static Future<String> _translateDeepL(
    String text,
    String from,
    String to,
    String apiKey,
  ) async {
    final isFreeKey = apiKey.endsWith(':fx');
    final endpoint = isFreeKey
        ? 'https://api-free.deepl.com/v2/translate'
        : 'https://api.deepl.com/v2/translate';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'DeepL-Auth-Key $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': [text],
        'target_lang': to.toUpperCase(),
        if (from != 'auto') 'source_lang': from.toUpperCase(),
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final translations = json['translations'] as List;
      if (translations.isNotEmpty) {
        return translations.first['text'] as String;
      }
    }
    throw Exception('DeepL API Error: ${response.statusCode}');
  }

  // ── OpenAI GPT-4o-mini API ──────────────────────────────────
  static Future<String> _translateOpenAI(
    String text,
    String from,
    String to,
    String apiKey,
  ) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a professional translator. Translate the text to target language code "$to". Output ONLY the translation.',
          },
          {'role': 'user', 'content': text},
        ],
        'temperature': 0.3,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final choices = json['choices'] as List;
      if (choices.isNotEmpty) {
        return choices.first['message']['content'].toString().trim();
      }
    }
    throw Exception('OpenAI API Error: ${response.statusCode}');
  }
}
