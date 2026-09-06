// Model data riwayat terjemahan
import 'dart:convert';

class TranslationHistoryItem {
  final String id;
  final String sourceText;
  final String translatedText;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final DateTime timestamp;

  TranslationHistoryItem({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceText': sourceText,
      'translatedText': translatedText,
      'fromCode': fromCode,
      'fromName': fromName,
      'toCode': toCode,
      'toName': toName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory TranslationHistoryItem.fromMap(Map<String, dynamic> map) {
    return TranslationHistoryItem(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      sourceText: map['sourceText'] ?? '',
      translatedText: map['translatedText'] ?? '',
      fromCode: map['fromCode'] ?? 'auto',
      fromName: map['fromName'] ?? 'Deteksi Otomatis',
      toCode: map['toCode'] ?? 'en',
      toName: map['toName'] ?? 'Inggris',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TranslationHistoryItem.fromJson(String source) =>
      TranslationHistoryItem.fromMap(jsonDecode(source));
}
