import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeSpeechService {
  NativeSpeechService._();
  static const MethodChannel _channel =
      MethodChannel('com.example.app_terjemahan/speech');

  /// Memanggil dialog pengenalan suara Google resmi Android.
  /// 100% kompatibel di semua HP Android (Xiaomi/Poco HyperOS, Samsung, Vivo, Oppo)
  /// langsung menggunakan mesin Google Voice yang sama seperti di keyboard Gboard.
  static Future<String?> startListening({
    String locale = 'id-ID',
    String prompt = 'Bicara sekarang untuk menerjemahkan...',
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'startSpeechRecognition',
        {
          'locale': locale,
          'prompt': prompt,
        },
      );
      return result?.trim();
    } on PlatformException catch (e) {
      debugPrint('NativeSpeechService PlatformException: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('NativeSpeechService error: $e');
      return null;
    }
  }
}
