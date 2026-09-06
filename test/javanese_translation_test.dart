import 'package:flutter_test/flutter_test.dart';
import 'package:translator/translator.dart';
import 'package:app_terjemahan/services/language_service.dart';

void main() {
  test('Validasi bahasa Jawa dan Sunda', () async {
    final jwLang = LanguageService.findByCode('jv');
    expect(jwLang, isNotNull);
    expect(jwLang!.name, 'Jawa');
    expect(LanguageService.normalize('jw'), 'jv');
    expect(LanguageService.normalize('jv'), 'jv');

    final translator = GoogleTranslator();

    // Test terjemahan ID -> JV
    final resJv = await translator.translate('Selamat pagi, bagaimana kabarmu?', from: 'id', to: 'jv');
    expect(resJv.text.isNotEmpty, true);

    // Test terjemahan JV -> ID
    final resId = await translator.translate('Sugeng enjang, kepriye kabare?', from: 'jv', to: 'id');
    expect(resId.text.isNotEmpty, true);

    // Test terjemahan ID -> SU (Sunda)
    final resSu = await translator.translate('Selamat pagi', from: 'id', to: 'su');
    expect(resSu.text.isNotEmpty, true);
  });
}
