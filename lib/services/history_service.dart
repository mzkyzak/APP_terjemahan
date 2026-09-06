// Service riwayat terjemahan
import 'package:shared_preferences/shared_preferences.dart';
import '../models/translation_history.dart';

class HistoryService {
  HistoryService._();

  static const String _keyHistory = 'user_translation_history_list';
  static const int _maxItems = 100;

  // Ambil semua riwayat
  static Future<List<TranslationHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = prefs.getStringList(_keyHistory) ?? [];
      return stringList
          .map((item) => TranslationHistoryItem.fromJson(item))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      return [];
    }
  }

  // ── Tambah Item Riwayat Baru ────────────────────────────────
  static Future<void> addHistory({
    required String sourceText,
    required String translatedText,
    required String fromCode,
    required String fromName,
    required String toCode,
    required String toName,
  }) async {
    if (sourceText.trim().isEmpty || translatedText.trim().isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getHistory();

      // Hindari duplikasi persis dari terjemahan terakhir
      if (current.isNotEmpty &&
          current.first.sourceText.trim() == sourceText.trim() &&
          current.first.toCode == toCode) {
        return;
      }

      final newItem = TranslationHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sourceText: sourceText.trim(),
        translatedText: translatedText.trim(),
        fromCode: fromCode,
        fromName: fromName,
        toCode: toCode,
        toName: toName,
        timestamp: DateTime.now(),
      );

      final updatedList = [newItem, ...current];
      if (updatedList.length > _maxItems) {
        updatedList.removeRange(_maxItems, updatedList.length);
      }

      final stringList = updatedList.map((e) => e.toJson()).toList();
      await prefs.setStringList(_keyHistory, stringList);
    } catch (_) {}
  }

  // ── Hapus Satu Item Riwayat ─────────────────────────────────
  static Future<void> deleteHistoryItem(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getHistory();
      current.removeWhere((item) => item.id == id);
      final stringList = current.map((e) => e.toJson()).toList();
      await prefs.setStringList(_keyHistory, stringList);
    } catch (_) {}
  }

  // ── Hapus Semua Riwayat ─────────────────────────────────────
  static Future<void> clearAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyHistory);
    } catch (_) {}
  }
}
