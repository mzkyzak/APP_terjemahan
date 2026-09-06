// Daftar bahasa resmi dan daerah
class Language {
  final String code;
  final String name;
  final String flag;
  final String region;

  const Language({
    required this.code,
    required this.name,
    required this.flag,
    this.region = 'Global',
  });
}

const List<Language> allLanguages = [
  // ── DETEKSI OTOMATIS ──────────────────────────────────────────
  Language(code: 'auto', name: 'Deteksi Otomatis', flag: '🌐', region: 'Semua'),

  // ── INDONESIA & BAHASA DAERAH ──────────────────────────────────
  Language(code: 'id',  name: 'Indonesia',          flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'jv',  name: 'Jawa',               flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'su',  name: 'Sunda',              flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'ban', name: 'Bali',               flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'min', name: 'Minangkabau',        flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'bug', name: 'Bugis',              flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'ace', name: 'Aceh',               flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'bjn', name: 'Banjar',             flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'bbc', name: 'Batak Toba',         flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'mad', name: 'Madura',             flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'sas', name: 'Sasak (Lombok)',     flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'mak', name: 'Makassar',           flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'iba', name: 'Dayak / Iban',       flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'nia', name: 'Nias',               flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'bap', name: 'Papua (Bantawa)',    flag: '🇮🇩', region: 'Indonesia'),
  Language(code: 'btk', name: 'Batak Karo',         flag: '🇮🇩', region: 'Indonesia'),

  // ── ASIA TIMUR & TIONGHOA ─────────────────────────────────────
  Language(code: 'zh-CN', name: 'Tionghoa (Mandarin Sederhana)',  flag: '🇨🇳', region: 'Asia Timur'),
  Language(code: 'zh-TW', name: 'Tionghoa (Mandarin Tradisional)',flag: '🇹🇼', region: 'Asia Timur'),
  Language(code: 'yue',   name: 'Kantonis (Cantonese)',            flag: '🇭🇰', region: 'Asia Timur'),
  Language(code: 'hak',   name: 'Kek / Hakka',                     flag: '🇨🇳', region: 'Asia Timur'),
  Language(code: 'nan',   name: 'Hokkien (Min Nan)',               flag: '🇨🇳', region: 'Asia Timur'),
  Language(code: 'bo',    name: 'Tibet (Tibetan)',                 flag: '🇨🇳', region: 'Asia Timur'),
  Language(code: 'ug',    name: 'Uyghur',                          flag: '🇨🇳', region: 'Asia Timur'),
  Language(code: 'ja',    name: 'Jepang',                          flag: '🇯🇵', region: 'Asia Timur'),
  Language(code: 'ko',    name: 'Korea',                           flag: '🇰🇷', region: 'Asia Timur'),
  Language(code: 'mn',    name: 'Mongolia',                        flag: '🇲🇳', region: 'Asia Timur'),

  // ── ASIA TENGGARA ─────────────────────────────────────────────
  Language(code: 'ms',  name: 'Melayu',                 flag: '🇲🇾', region: 'Asia Tenggara'),
  Language(code: 'th',  name: 'Thailand',               flag: '🇹🇭', region: 'Asia Tenggara'),
  Language(code: 'vi',  name: 'Vietnam',                flag: '🇻🇳', region: 'Asia Tenggara'),
  Language(code: 'tl',  name: 'Filipino (Tagalog)',     flag: '🇵🇭', region: 'Asia Tenggara'),
  Language(code: 'my',  name: 'Burma (Myanmar)',        flag: '🇲🇲', region: 'Asia Tenggara'),
  Language(code: 'km',  name: 'Khmer (Kamboja)',        flag: '🇰🇭', region: 'Asia Tenggara'),
  Language(code: 'lo',  name: 'Lao (Laos)',             flag: '🇱🇦', region: 'Asia Tenggara'),
  Language(code: 'ceb', name: 'Cebuano',                flag: '🇵🇭', region: 'Asia Tenggara'),
  Language(code: 'ilo', name: 'Ilocano',                flag: '🇵🇭', region: 'Asia Tenggara'),
  Language(code: 'hmn', name: 'Hmong',                  flag: '🇱🇦', region: 'Asia Tenggara'),
  Language(code: 'tet', name: 'Tetum (Timor Leste)',    flag: '🇹🇱', region: 'Asia Tenggara'),

  // ── ASIA SELATAN ──────────────────────────────────────────────
  Language(code: 'hi',  name: 'Hindi',            flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'bn',  name: 'Bengali',          flag: '🇧🇩', region: 'Asia Selatan'),
  Language(code: 'ur',  name: 'Urdu',             flag: '🇵🇰', region: 'Asia Selatan'),
  Language(code: 'pa',  name: 'Punjabi',          flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'ta',  name: 'Tamil',            flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'te',  name: 'Telugu',           flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'ml',  name: 'Malayalam',        flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'kn',  name: 'Kannada',          flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'gu',  name: 'Gujarati',         flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'mr',  name: 'Marathi',          flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'ne',  name: 'Nepali',           flag: '🇳🇵', region: 'Asia Selatan'),
  Language(code: 'si',  name: 'Sinhala (Sri Lanka)', flag: '🇱🇰', region: 'Asia Selatan'),
  Language(code: 'or',  name: 'Odia (Oriya)',     flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'sd',  name: 'Sindhi',           flag: '🇵🇰', region: 'Asia Selatan'),
  Language(code: 'as',  name: 'Assamese',         flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'lus', name: 'Mizo',             flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'bho', name: 'Bhojpuri',         flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'mai', name: 'Maithili',          flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'doi', name: 'Dogri',            flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'ks',  name: 'Kashmiri',         flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'sa',  name: 'Sanskerta',        flag: '🇮🇳', region: 'Asia Selatan'),
  Language(code: 'sat', name: 'Santali',          flag: '🇮🇳', region: 'Asia Selatan'),

  // ── ASIA TENGAH ───────────────────────────────────────────────
  Language(code: 'kk', name: 'Kazakh',           flag: '🇰🇿', region: 'Asia Tengah'),
  Language(code: 'uz', name: 'Uzbek',            flag: '🇺🇿', region: 'Asia Tengah'),
  Language(code: 'ky', name: 'Kirgiz',           flag: '🇰🇬', region: 'Asia Tengah'),
  Language(code: 'tg', name: 'Tajik',            flag: '🇹🇯', region: 'Asia Tengah'),
  Language(code: 'tk', name: 'Turkmen',          flag: '🇹🇲', region: 'Asia Tengah'),

  // ── TIMUR TENGAH & KAUKASUS ───────────────────────────────────
  Language(code: 'ar', name: 'Arab',              flag: '🇸🇦', region: 'Timur Tengah'),
  Language(code: 'fa', name: 'Persia (Farsi)',    flag: '🇮🇷', region: 'Timur Tengah'),
  Language(code: 'tr', name: 'Turki',             flag: '🇹🇷', region: 'Timur Tengah'),
  Language(code: 'he', name: 'Ibrani (Hebrew)',   flag: '🇮🇱', region: 'Timur Tengah'),
  Language(code: 'ku', name: 'Kurdi (Kurmanji)',  flag: '🇮🇶', region: 'Timur Tengah'),
  Language(code: 'ckb',name: 'Kurdi (Sorani)',    flag: '🇮🇶', region: 'Timur Tengah'),
  Language(code: 'az', name: 'Azerbaijan',        flag: '🇦🇿', region: 'Timur Tengah'),
  Language(code: 'ps', name: 'Pashto',            flag: '🇦🇫', region: 'Timur Tengah'),
  Language(code: 'hy', name: 'Armenia',           flag: '🇦🇲', region: 'Timur Tengah'),
  Language(code: 'ka', name: 'Georgia',           flag: '🇬🇪', region: 'Timur Tengah'),

  // ── EROPA BARAT & UTARA ───────────────────────────────────────
  Language(code: 'en', name: 'Inggris (US/UK)',   flag: '🇬🇧', region: 'Eropa'),
  Language(code: 'fr', name: 'Prancis',           flag: '🇫🇷', region: 'Eropa'),
  Language(code: 'de', name: 'Jerman',            flag: '🇩🇪', region: 'Eropa'),
  Language(code: 'es', name: 'Spanyol',           flag: '🇪🇸', region: 'Eropa'),
  Language(code: 'it', name: 'Italia',            flag: '🇮🇹', region: 'Eropa'),
  Language(code: 'pt', name: 'Portugis',          flag: '🇵🇹', region: 'Eropa'),
  Language(code: 'nl', name: 'Belanda',           flag: '🇳🇱', region: 'Eropa'),
  Language(code: 'sv', name: 'Swedia',            flag: '🇸🇪', region: 'Eropa'),
  Language(code: 'no', name: 'Norwegia',          flag: '🇳🇴', region: 'Eropa'),
  Language(code: 'da', name: 'Denmark',           flag: '🇩🇰', region: 'Eropa'),
  Language(code: 'fi', name: 'Finlandia',         flag: '🇫🇮', region: 'Eropa'),
  Language(code: 'is', name: 'Islandia',          flag: '🇮🇸', region: 'Eropa'),
  Language(code: 'ga', name: 'Irlandia (Gaelic)', flag: '🇮🇪', region: 'Eropa'),
  Language(code: 'cy', name: 'Wales (Welsh)',     flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', region: 'Eropa'),
  Language(code: 'mt', name: 'Malta',             flag: '🇲🇹', region: 'Eropa'),
  Language(code: 'lb', name: 'Luksemburg',        flag: '🇱🇺', region: 'Eropa'),
  Language(code: 'ca', name: 'Katalan',           flag: '🇪🇸', region: 'Eropa'),
  Language(code: 'gl', name: 'Galisia',           flag: '🇪🇸', region: 'Eropa'),
  Language(code: 'eu', name: 'Basque',            flag: '🇪🇸', region: 'Eropa'),
  Language(code: 'co', name: 'Korsika',           flag: '🇫🇷', region: 'Eropa'),
  Language(code: 'fy', name: 'Frisia',            flag: '🇳🇱', region: 'Eropa'),
  Language(code: 'gd', name: 'Gaelik Skotlandia', flag: '🏴󠁧󠁢󠁳󠁣󠁴󠁿', region: 'Eropa'),
  Language(code: 'eo', name: 'Esperanto',         flag: '🌍', region: 'Eropa'),
  Language(code: 'la', name: 'Latin',             flag: '🇻🇦', region: 'Eropa'),

  // ── EROPA TIMUR & BALKAN ──────────────────────────────────────
  Language(code: 'ru', name: 'Rusia',             flag: '🇷🇺', region: 'Eropa'),
  Language(code: 'pl', name: 'Polandia',          flag: '🇵🇱', region: 'Eropa'),
  Language(code: 'uk', name: 'Ukraina',           flag: '🇺🇦', region: 'Eropa'),
  Language(code: 'el', name: 'Yunani',            flag: '🇬🇷', region: 'Eropa'),
  Language(code: 'cs', name: 'Ceko',              flag: '🇨🇿', region: 'Eropa'),
  Language(code: 'hu', name: 'Hongaria',          flag: '🇭🇺', region: 'Eropa'),
  Language(code: 'ro', name: 'Rumania',           flag: '🇷🇴', region: 'Eropa'),
  Language(code: 'bg', name: 'Bulgaria',          flag: '🇧🇬', region: 'Eropa'),
  Language(code: 'sk', name: 'Slowakia',          flag: '🇸🇰', region: 'Eropa'),
  Language(code: 'hr', name: 'Kroasia',           flag: '🇭🇷', region: 'Eropa'),
  Language(code: 'sr', name: 'Serbia',            flag: '🇷🇸', region: 'Eropa'),
  Language(code: 'sq', name: 'Albania',           flag: '🇦🇱', region: 'Eropa'),
  Language(code: 'et', name: 'Estonia',           flag: '🇪🇪', region: 'Eropa'),
  Language(code: 'lv', name: 'Latvia',            flag: '🇱🇻', region: 'Eropa'),
  Language(code: 'lt', name: 'Lituania',          flag: '🇱🇹', region: 'Eropa'),
  Language(code: 'be', name: 'Belarusia',         flag: '🇧🇾', region: 'Eropa'),
  Language(code: 'bs', name: 'Bosnia',            flag: '🇧🇦', region: 'Eropa'),
  Language(code: 'mk', name: 'Makedonia',         flag: '🇲🇰', region: 'Eropa'),
  Language(code: 'sl', name: 'Slowenia',          flag: '🇸🇮', region: 'Eropa'),
  Language(code: 'yi', name: 'Yiddish',           flag: '🇮🇱', region: 'Eropa'),
  Language(code: 'tt', name: 'Tatar',             flag: '🇷🇺', region: 'Eropa'),

  // ── AFRIKA ────────────────────────────────────────────────────
  Language(code: 'sw', name: 'Swahili',           flag: '🇰🇪', region: 'Afrika'),
  Language(code: 'af', name: 'Afrikaans',         flag: '🇿🇦', region: 'Afrika'),
  Language(code: 'am', name: 'Amharik',           flag: '🇪🇹', region: 'Afrika'),
  Language(code: 'yo', name: 'Yoruba',            flag: '🇳🇬', region: 'Afrika'),
  Language(code: 'ig', name: 'Igbo',              flag: '🇳🇬', region: 'Afrika'),
  Language(code: 'ha', name: 'Hausa',             flag: '🇳🇬', region: 'Afrika'),
  Language(code: 'zu', name: 'Zulu',              flag: '🇿🇦', region: 'Afrika'),
  Language(code: 'xh', name: 'Xhosa',             flag: '🇿🇦', region: 'Afrika'),
  Language(code: 'so', name: 'Somalia',           flag: '🇸🇴', region: 'Afrika'),
  Language(code: 'mg', name: 'Malagasy',          flag: '🇲🇬', region: 'Afrika'),
  Language(code: 'rw', name: 'Kinyarwanda',       flag: '🇷🇼', region: 'Afrika'),
  Language(code: 'ny', name: 'Chichewa',          flag: '🇲🇼', region: 'Afrika'),
  Language(code: 'st', name: 'Sesotho',           flag: '🇱🇸', region: 'Afrika'),
  Language(code: 'sn', name: 'Shona',             flag: '🇿🇼', region: 'Afrika'),
  Language(code: 'ts', name: 'Tsonga',            flag: '🇿🇦', region: 'Afrika'),
  Language(code: 'ak', name: 'Twi',               flag: '🇬🇭', region: 'Afrika'),
  Language(code: 'om', name: 'Oromo',             flag: '🇪🇹', region: 'Afrika'),
  Language(code: 'ti', name: 'Tigrinya',          flag: '🇪🇷', region: 'Afrika'),
  Language(code: 'ln', name: 'Lingala',           flag: '🇨🇩', region: 'Afrika'),
  Language(code: 'lg', name: 'Luganda',           flag: '🇺🇬', region: 'Afrika'),
  Language(code: 'bm', name: 'Bambara',           flag: '🇲🇱', region: 'Afrika'),

  // ── AMERIKA ───────────────────────────────────────────────────
  Language(code: 'ht',  name: 'Haiti Creole',     flag: '🇭🇹', region: 'Amerika'),
  Language(code: 'gn',  name: 'Guarani',          flag: '🇵🇾', region: 'Amerika'),
  Language(code: 'ay',  name: 'Aymara',           flag: '🇧🇴', region: 'Amerika'),
  Language(code: 'qu',  name: 'Quechua',          flag: '🇵🇪', region: 'Amerika'),

  // ── OSEANIA ───────────────────────────────────────────────────
  Language(code: 'haw', name: 'Hawaii',           flag: '🇺🇸', region: 'Oseania'),
  Language(code: 'mi',  name: 'Maori',            flag: '🇳🇿', region: 'Oseania'),
  Language(code: 'sm',  name: 'Samoa',            flag: '🇼🇸', region: 'Oseania'),
];

// Wilayah untuk tab filter
const List<String> languageRegions = [
  'Semua',
  'Indonesia',
  'Asia Timur',
  'Asia Tenggara',
  'Asia Selatan',
  'Asia Tengah',
  'Timur Tengah',
  'Eropa',
  'Afrika',
  'Amerika',
  'Oseania',
];
