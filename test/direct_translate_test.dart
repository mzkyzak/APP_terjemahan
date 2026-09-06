import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

Future<String> directGoogleTranslate(String text, {required String from, required String to}) async {
  final url = Uri.parse(
    'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$from&tl=$to&dt=t&q=${Uri.encodeComponent(text)}',
  );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final raw = jsonDecode(response.body);
    if (raw is List && raw.isNotEmpty && raw[0] is List) {
      final buffer = StringBuffer();
      for (final part in raw[0]) {
        if (part is List && part.isNotEmpty && part[0] != null) {
          buffer.write(part[0].toString());
        }
      }
      return buffer.toString();
    }
  }
  throw Exception('HTTP error ${response.statusCode}: ${response.body}');
}

void main() {
  test('Direct Google Translate works for all codes without LanguageNotSupportedException', () async {
    final resEn = await directGoogleTranslate('Halo apa kabar', from: 'id', to: 'en');
    expect(resEn.toLowerCase(), contains('hello'));

    final resJv = await directGoogleTranslate('Selamat pagi', from: 'id', to: 'jv');
    expect(resJv.isNotEmpty, true);

    final resBan = await directGoogleTranslate('Selamat pagi', from: 'id', to: 'ban');
    expect(resBan.isNotEmpty, true);

    final resMin = await directGoogleTranslate('Selamat pagi', from: 'id', to: 'min');
    expect(resMin.isNotEmpty, true);

    final resZh = await directGoogleTranslate('Selamat pagi', from: 'id', to: 'zh-CN');
    expect(resZh.isNotEmpty, true);
  });
}
