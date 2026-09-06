// Service pemetaan dan validasi bahasa
import '../models/language.dart';

class TranslationValidationResult {
  final bool isValid;
  final String? errorMessage;
  const TranslationValidationResult({required this.isValid, this.errorMessage});
}

class LanguageService {
  LanguageService._();

  // ── Cari bahasa berdasarkan teks (nama, code, region) ────────
  static List<Language> search(String query) {
    if (query.trim().isEmpty) return allLanguages;
    final q = query.toLowerCase().trim();
    return allLanguages.where((lang) {
      return lang.name.toLowerCase().contains(q) ||
          lang.code.toLowerCase().contains(q) ||
          lang.region.toLowerCase().contains(q);
    }).toList();
  }

  // ── Filter berdasarkan region ────────────────────────────────
  static List<Language> filterByRegion(String region) {
    if (region == 'Semua') return allLanguages;
    return allLanguages.where((lang) => lang.region == region).toList();
  }

  // ── Search + filter region digabungkan ───────────────────────
  static List<Language> searchInRegion(String query, String region) {
    final byRegion = filterByRegion(region);
    if (query.trim().isEmpty) return byRegion;
    final q = query.toLowerCase().trim();
    return byRegion.where((lang) {
      return lang.name.toLowerCase().contains(q) ||
          lang.code.toLowerCase().contains(q);
    }).toList();
  }

  // ── Normalisasi kode: pastikan case & alias konsisten ────────
  static String normalize(String code) {
    const specialCases = {
      'zh-cn': 'zh-CN',
      'zh-tw': 'zh-TW',
      'iw': 'he',     // alias lama Hebrew
      'jw': 'jv',     // Jawa di Google Translate menggunakan 'jv'
    };
    final lower = code.toLowerCase();
    return specialCases[lower] ?? lower;
  }

  // ── Validasi sebelum melakukan terjemahan ────────────────────
  static TranslationValidationResult validateTranslation({
    required Language from,
    required Language to,
    required String text,
  }) {
    if (text.trim().isEmpty) {
      return const TranslationValidationResult(
        isValid: false,
        errorMessage: 'Teks tidak boleh kosong.',
      );
    }

    if (from.code != 'auto' && from.code == to.code) {
      return TranslationValidationResult(
        isValid: false,
        errorMessage:
            'Bahasa sumber dan tujuan tidak boleh sama (${from.name}).',
      );
    }

    return const TranslationValidationResult(isValid: true);
  }

  // ── Dapatkan Language berdasarkan code ───────────────────────
  static Language? findByCode(String code) {
    final normalized = normalize(code);
    try {
      return allLanguages.firstWhere(
        (l) => normalize(l.code) == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Konversi code → Speech locale ID (speech_to_text) ────────
  static String toSpeechLocale(String code) {
    const map = {
      // Deteksi Otomatis & Indonesia + Dialek Daerah
      'auto':  'id-ID',
      'id':    'id-ID',
      'jv':    'id-ID',
      'jw':    'id-ID',
      'su':    'id-ID',
      'ban':   'id-ID',
      'min':   'id-ID',
      'bug':   'id-ID',
      'ace':   'id-ID',
      'bjn':   'id-ID',
      'bbc':   'id-ID',
      'mad':   'id-ID',
      'sas':   'id-ID',
      'mak':   'id-ID',
      'iba':   'id-ID',
      'nia':   'id-ID',
      'bap':   'id-ID',
      'btk':   'id-ID',

      // Asia Timur & Dialek Tionghoa
      'zh-CN': 'zh-CN',
      'zh-TW': 'zh-TW',
      'yue':   'zh-HK',
      'hak':   'zh-CN',
      'nan':   'zh-TW',
      'bo':    'zh-CN',
      'ug':    'zh-CN',
      'ja':    'ja-JP',
      'ko':    'ko-KR',
      'mn':    'mn-MN',

      // Asia Tenggara
      'ms':    'ms-MY',
      'th':    'th-TH',
      'vi':    'vi-VN',
      'tl':    'fil-PH',
      'my':    'my-MM',
      'km':    'km-KH',
      'lo':    'lo-LA',
      'ceb':   'ceb-PH',
      'ilo':   'ilo-PH',
      'hmn':   'hmn',

      // Asia Selatan
      'hi':    'hi-IN',
      'bn':    'bn-BD',
      'ur':    'ur-PK',
      'pa':    'pa-IN',
      'ta':    'ta-IN',
      'te':    'te-IN',
      'ml':    'ml-IN',
      'kn':    'kn-IN',
      'gu':    'gu-IN',
      'mr':    'mr-IN',
      'ne':    'ne-NP',
      'si':    'si-LK',
      'or':    'or-IN',
      'sd':    'sd-IN',
      'as':    'as-IN',
      'lus':   'lus-IN',

      // Asia Tengah
      'kk':    'kk-KZ',
      'uz':    'uz-UZ',
      'ky':    'ky-KG',
      'tg':    'tg-TJ',
      'tk':    'tk-TM',

      // Timur Tengah
      'ar':    'ar-SA',
      'fa':    'fa-IR',
      'tr':    'tr-TR',
      'he':    'he-IL',
      'ku':    'ku-TR',
      'az':    'az-AZ',
      'ps':    'ps-AF',
      'hy':    'hy-AM',
      'ka':    'ka-GE',

      // Eropa
      'en':    'en-US',
      'fr':    'fr-FR',
      'de':    'de-DE',
      'es':    'es-ES',
      'it':    'it-IT',
      'pt':    'pt-BR',
      'ru':    'ru-RU',
      'nl':    'nl-NL',
      'pl':    'pl-PL',
      'uk':    'uk-UA',
      'el':    'el-GR',
      'sv':    'sv-SE',
      'no':    'nb-NO',
      'da':    'da-DK',
      'fi':    'fi-FI',
      'cs':    'cs-CZ',
      'hu':    'hu-HU',
      'ro':    'ro-RO',
      'bg':    'bg-BG',
      'sk':    'sk-SK',
      'hr':    'hr-HR',
      'sr':    'sr-RS',
      'sq':    'sq-AL',
      'et':    'et-EE',
      'lv':    'lv-LV',
      'lt':    'lt-LT',
      'be':    'be-BY',
      'bs':    'bs-BA',
      'mk':    'mk-MK',
      'sl':    'sl-SI',
      'is':    'is-IS',
      'ga':    'ga-IE',
      'cy':    'cy-GB',
      'mt':    'mt-MT',
      'lb':    'lb-LU',
      'ca':    'ca-ES',
      'gl':    'gl-ES',
      'eu':    'eu-ES',
      'co':    'co-FR',
      'fy':    'fy-NL',
      'gd':    'gd-GB',
      'eo':    'eo',
      'la':    'la',
      'yi':    'yi',
      'tt':    'tt-RU',

      // Afrika
      'sw':    'sw-KE',
      'af':    'af-ZA',
      'am':    'am-ET',
      'yo':    'yo-NG',
      'ig':    'ig-NG',
      'ha':    'ha-NG',
      'zu':    'zu-ZA',
      'xh':    'xh-ZA',
      'so':    'so-SO',
      'mg':    'mg-MG',
      'rw':    'rw-RW',
      'ny':    'ny-MW',
      'st':    'st-ZA',
      'sn':    'sn-ZW',
      'ts':    'ts-ZA',
      'ak':    'ak-GH',
      'om':    'om-ET',
      'ti':    'ti-ET',
      'ln':    'ln-CD',
      'lg':    'lg-UG',
      'bm':    'bm-ML',

      // Amerika & Oseania
      'ht':    'ht-HT',
      'gn':    'gn-PY',
      'ay':    'ay-BO',
      'qu':    'qu-PE',
      'haw':   'haw-US',
      'mi':    'mi-NZ',
      'sm':    'sm-WS',
    };
    final norm = normalize(code);
    return map[norm] ?? '$norm-${norm.toUpperCase()}';
  }

  // ── Konversi code → TTS language (flutter_tts) ───────────────
  static String toTtsLanguage(String code) {
    const map = {
      // Deteksi Otomatis & Indonesia
      'auto':  'id-ID',
      'id':    'id-ID',
      'jv':    'jv-ID',
      'jw':    'jv-ID',
      'su':    'su-ID',

      // Asia Timur
      'zh-CN': 'zh-CN',
      'zh-TW': 'zh-TW',
      'ja':    'ja-JP',
      'ko':    'ko-KR',
      'mn':    'mn-MN',

      // Asia Tenggara
      'ms':    'ms-MY',
      'th':    'th-TH',
      'vi':    'vi-VN',
      'tl':    'fil-PH',
      'my':    'my-MM',
      'km':    'km-KH',
      'lo':    'lo-LA',
      'ceb':   'ceb-PH',
      'ilo':   'ilo-PH',
      'hmn':   'hmn',

      // Asia Selatan
      'hi':    'hi-IN',
      'bn':    'bn-BD',
      'ur':    'ur-PK',
      'pa':    'pa-IN',
      'ta':    'ta-IN',
      'te':    'te-IN',
      'ml':    'ml-IN',
      'kn':    'kn-IN',
      'gu':    'gu-IN',
      'mr':    'mr-IN',
      'ne':    'ne-NP',
      'si':    'si-LK',
      'or':    'or-IN',
      'sd':    'sd-IN',
      'as':    'as-IN',
      'lus':   'lus-IN',

      // Asia Tengah
      'kk':    'kk-KZ',
      'uz':    'uz-UZ',
      'ky':    'ky-KG',
      'tg':    'tg-TJ',
      'tk':    'tk-TM',

      // Timur Tengah
      'ar':    'ar-SA',
      'fa':    'fa-IR',
      'tr':    'tr-TR',
      'he':    'he-IL',
      'ku':    'ku-TR',
      'az':    'az-AZ',
      'ps':    'ps-AF',
      'hy':    'hy-AM',
      'ka':    'ka-GE',

      // Eropa
      'en':    'en-US',
      'fr':    'fr-FR',
      'de':    'de-DE',
      'es':    'es-ES',
      'it':    'it-IT',
      'pt':    'pt-BR',
      'ru':    'ru-RU',
      'nl':    'nl-NL',
      'pl':    'pl-PL',
      'uk':    'uk-UA',
      'el':    'el-GR',
      'sv':    'sv-SE',
      'no':    'nb-NO',
      'da':    'da-DK',
      'fi':    'fi-FI',
      'cs':    'cs-CZ',
      'hu':    'hu-HU',
      'ro':    'ro-RO',
      'bg':    'bg-BG',
      'sk':    'sk-SK',
      'hr':    'hr-HR',
      'sr':    'sr-RS',
      'sq':    'sq-AL',
      'et':    'et-EE',
      'lv':    'lv-LV',
      'lt':    'lt-LT',
      'be':    'be-BY',
      'bs':    'bs-BA',
      'mk':    'mk-MK',
      'sl':    'sl-SI',
      'is':    'is-IS',
      'ga':    'ga-IE',
      'cy':    'cy-GB',
      'mt':    'mt-MT',
      'lb':    'lb-LU',
      'ca':    'ca-ES',
      'gl':    'gl-ES',
      'eu':    'eu-ES',
      'co':    'co-FR',
      'fy':    'fy-NL',
      'gd':    'gd-GB',
      'eo':    'eo',
      'la':    'la',
      'yi':    'yi',
      'tt':    'tt-RU',

      // Afrika
      'sw':    'sw-KE',
      'af':    'af-ZA',
      'am':    'am-ET',
      'yo':    'yo-NG',
      'ig':    'ig-NG',
      'ha':    'ha-NG',
      'zu':    'zu-ZA',
      'xh':    'xh-ZA',
      'so':    'so-SO',
      'mg':    'mg-MG',
      'rw':    'rw-RW',
      'ny':    'ny-MW',
      'st':    'st-ZA',
      'sn':    'sn-ZW',
      'ts':    'ts-ZA',
      'ak':    'ak-GH',
      'om':    'om-ET',
      'ti':    'ti-ET',
      'ln':    'ln-CD',
      'lg':    'lg-UG',
      'bm':    'bm-ML',

      // Amerika & Oseania
      'ht':    'ht-HT',
      'gn':    'gn-PY',
      'ay':    'ay-BO',
      'qu':    'qu-PE',
      'haw':   'haw-US',
      'mi':    'mi-NZ',
      'sm':    'sm-WS',
    };
    final norm = normalize(code);
    return map[norm] ?? '$norm-${norm.toUpperCase()}';
  }
}
