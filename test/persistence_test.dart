import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_terjemahan/services/history_service.dart';
import 'package:app_terjemahan/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Persistent state anti-hilang data verification', () async {
    // 1. Simpan state terjemahan aktif
    await SettingsService.setLastFromLang('jv');
    await SettingsService.setLastToLang('id');
    await SettingsService.setLastInputText('Sugeng enjang');
    await SettingsService.setLastTranslatedText('Selamat pagi');

    // 2. Baca kembali state (simulasi keluar aplikasi & buka kembali)
    final from = await SettingsService.getLastFromLang();
    final to = await SettingsService.getLastToLang();
    final input = await SettingsService.getLastInputText();
    final trans = await SettingsService.getLastTranslatedText();

    expect(from, 'jv');
    expect(to, 'id');
    expect(input, 'Sugeng enjang');
    expect(trans, 'Selamat pagi');

    // 3. Simpan Riwayat
    await HistoryService.addHistory(
      sourceText: 'Sugeng enjang',
      translatedText: 'Selamat pagi',
      fromCode: 'jv',
      fromName: 'Jawa',
      toCode: 'id',
      toName: 'Indonesia',
    );

    final history = await HistoryService.getHistory();
    expect(history.length, 1);
    expect(history.first.sourceText, 'Sugeng enjang');
    expect(history.first.translatedText, 'Selamat pagi');
  });
}
