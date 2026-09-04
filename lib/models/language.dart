class Language {
  final String code;
  final String name;
  final String flag;

  const Language({
    required this.code,
    required this.name,
    required this.flag,
  });
}

const List<Language> allLanguages = [
  Language(code: 'auto', name: 'Deteksi Otomatis', flag: '🌐'),
  Language(code: 'id', name: 'Indonesia', flag: '🇮🇩'),
  Language(code: 'en', name: 'Inggris', flag: '🇬🇧'),
  Language(code: 'ar', name: 'Arab', flag: '🇸🇦'),
  Language(code: 'ja', name: 'Jepang', flag: '🇯🇵'),
  Language(code: 'ko', name: 'Korea', flag: '🇰🇷'),
  Language(code: 'zh-cn', name: 'Mandarin', flag: '🇨🇳'),
  Language(code: 'es', name: 'Spanyol', flag: '🇪🇸'),
  Language(code: 'fr', name: 'Prancis', flag: '🇫🇷'),
  Language(code: 'de', name: 'Jerman', flag: '🇩🇪'),
  Language(code: 'ru', name: 'Rusia', flag: '🇷🇺'),
  Language(code: 'it', name: 'Italia', flag: '🇮🇹'),
  Language(code: 'nl', name: 'Belanda', flag: '🇳🇱'),
  Language(code: 'pt', name: 'Portugis', flag: '🇵🇹'),
  Language(code: 'th', name: 'Thailand', flag: '🇹🇭'),
  Language(code: 'vi', name: 'Vietnam', flag: '🇻🇳'),
];
