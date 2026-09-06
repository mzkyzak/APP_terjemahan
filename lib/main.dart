import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'models/language.dart';
import 'services/language_service.dart';
import 'services/translation_service.dart';
import 'services/haptic_service.dart';
import 'services/settings_service.dart';
import 'services/user_profile_service.dart';
import 'services/history_service.dart';
import 'services/native_speech_service.dart';
import 'widgets/history_bottom_sheet.dart';
import 'widgets/language_bar.dart';
import 'widgets/translation_input.dart';
import 'widgets/translation_result.dart';
import 'widgets/star_field.dart';
import 'screens/settings_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SettingsService.getThemeOption().then((option) {
      switch (option) {
        case 'system':
          MyApp.themeNotifier.value = ThemeMode.system;
          break;
        case 'light':
          MyApp.themeNotifier.value = ThemeMode.light;
          break;
        default:
          MyApp.themeNotifier.value = ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Terjemahan mzkyzak',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF6366F1),
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF6366F1),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F172A),
          ),
          themeMode: currentMode,
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.g_translate_rounded, color: Color(0xFF818CF8), size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              _selectedIndex == 0 ? 'Terjemahan mzkyzak' : 'Pengaturan',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient & Stars
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF020617)]
                    : const [Color(0xFFF8FAFC), Color(0xFFE0E7FF), Color(0xFFEEF2FF)],
              ),
            ),
          ),
          if (isDark) const StarField(),
          
          // Glowing Ambient Orbs (Electric Blue & Crimson Red Neon - 120 FPS Optimized)
          Positioned(
            top: 80,
            left: -60,
            child: RepaintBoundary(
              child: _GlowingOrb(
                color: isDark
                    ? const Color(0xFF2563EB).withValues(alpha: 0.22)
                    : const Color(0xFF3B82F6).withValues(alpha: 0.16),
                size: 320,
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            right: -60,
            child: RepaintBoundary(
              child: _GlowingOrb(
                color: isDark
                    ? const Color(0xFFEF4444).withValues(alpha: 0.20)
                    : const Color(0xFFF43F5E).withValues(alpha: 0.14),
                size: 280,
              ),
            ),
          ),

          // Content
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: const [
              TranslatorView(),
              SettingsScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      height: 68,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.translate_rounded, 'Terjemahan', isDark),
              _buildNavItem(1, Icons.tune_rounded, 'Pengaturan', isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFF2563EB).withValues(alpha: 0.35),
                    const Color(0xFFEF4444).withValues(alpha: 0.25),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF1D4ED8))
                  : (isDark ? Colors.white54 : Colors.black54),
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GlowingOrb extends StatefulWidget {
  final Color color;
  final double size;

  const _GlowingOrb({required this.color, required this.size});

  @override
  State<_GlowingOrb> createState() => _GlowingOrbState();
}

class _GlowingOrbState extends State<_GlowingOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.88, end: 1.12).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              widget.color,
              widget.color.withValues(alpha: 0.4),
              Colors.transparent,
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
      ),
    );
  }
}

class TranslatorView extends StatefulWidget {
  const TranslatorView({super.key});

  @override
  State<TranslatorView> createState() => _TranslatorViewState();
}

class _TranslatorViewState extends State<TranslatorView> {
  final GoogleTranslator translator = GoogleTranslator();
  final TextEditingController textController = TextEditingController();
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  Timer? _debounce;

  Language fromLang = LanguageService.findByCode('auto') ?? allLanguages.first;
  Language toLang = LanguageService.findByCode('en') ?? allLanguages[1];
  String translatedText = "";
  bool isLoading = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initTts();
    _initSpeech();
    _restoreSavedState();
  }

  Future<void> _restoreSavedState() async {
    final fromCode = await SettingsService.getLastFromLang();
    final toCode = await SettingsService.getLastToLang();
    final lastInput = await SettingsService.getLastInputText();
    final lastTranslated = await SettingsService.getLastTranslatedText();

    if (mounted) {
      setState(() {
        if (fromCode.isNotEmpty) {
          final foundFrom = LanguageService.findByCode(fromCode);
          if (foundFrom != null) fromLang = foundFrom;
        }
        if (toCode.isNotEmpty) {
          final foundTo = LanguageService.findByCode(toCode);
          if (foundTo != null) toLang = foundTo;
        }
        if (lastInput.isNotEmpty) {
          textController.text = lastInput;
        }
        if (lastTranslated.isNotEmpty) {
          translatedText = lastTranslated;
        }
      });
    }
  }

  void _initTts() async {
    await _flutterTts.awaitSpeakCompletion(true);
    try {
      final engines = await _flutterTts.getEngines;
      if (engines is List && engines.contains("com.google.android.tts")) {
        await _flutterTts.setEngine("com.google.android.tts");
      }
    } catch (_) {}
    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isSpeaking = true);
    });
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _flutterTts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _flutterTts.setErrorHandler((msg) {
      debugPrint("TTS error: $msg");
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<bool> _initSpeech() async {
    if (_speech.isAvailable) return true;
    try {
      bool available = await _speech.initialize(
        debugLogging: true,
        finalTimeout: const Duration(seconds: 4),
        options: [
          stt.SpeechToText.androidAlwaysUseStop,
          stt.SpeechToText.androidNoBluetooth,
        ],
        onStatus: (status) {
          debugPrint("STT onStatus: $status");
          if (status == 'listening') {
            if (mounted && !_isListening) {
              setState(() => _isListening = true);
            }
          } else if (status == 'done' || status == 'notListening') {
            if (mounted && _isListening) {
              setState(() => _isListening = false);
              if (textController.text.trim().isNotEmpty) translate();
            }
          }
        },
        onError: (errorNotification) {
          debugPrint("STT onError: ${errorNotification.errorMsg}");
          if (mounted) {
            String rawErr = errorNotification.errorMsg.toLowerCase();
            if (rawErr.contains('error_language_unavailable') || rawErr.contains('language')) {
              debugPrint("STT error_language_unavailable: attempting fallback to id-ID");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎙️ Paket suara bahasa ini belum tersedia di HP. Beralih ke Bahasa Indonesia...'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Color(0xFF1E293B),
                  duration: Duration(seconds: 3),
                ),
              );
              final fallbackLocale = fromLang.code == 'en' ? 'en-US' : 'id-ID';
              _startListeningWithLocale(fallbackLocale, isFallback: true);
              return;
            }
            setState(() => _isListening = false);
            String msg = errorNotification.errorMsg;
            if (rawErr.contains('error_permission')) {
              msg = 'Izin mikrofon belum aktif.';
            } else if (rawErr.contains('error_no_match')) {
              msg = 'Suara tidak terdeteksi. Bicara lebih dekat ke mikrofon.';
            } else if (rawErr.contains('error_speech_timeout')) {
              msg = 'Waktu mendengarkan habis.';
            } else if (rawErr.contains('error_network')) {
              msg = 'Koneksi internet diperlukan untuk pengenalan suara.';
            } else if (rawErr.contains('error_busy') || rawErr.contains('error_server')) {
              msg = 'Layanan suara sedang sibuk. Silakan coba sesaat lagi.';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎙️ $msg'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF1E293B),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      );
      return available;
    } catch (e) {
      debugPrint("STT initialize error: $e");
      return false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _flutterTts.stop();
    textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (text.trim().isEmpty) {
      setState(() => translatedText = "");
      SettingsService.setLastInputText('');
      SettingsService.setLastTranslatedText('');
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      translate();
    });
  }

  void translate() async {
    final query = textController.text.trim();
    if (query.isEmpty) {
      setState(() => translatedText = "");
      SettingsService.setLastInputText('');
      SettingsService.setLastTranslatedText('');
      return;
    }

    // Validasi sebelum request ke engine
    final validation = LanguageService.validateTranslation(
      from: fromLang,
      to: toLang,
      text: query,
    );
    if (!validation.isValid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('⚠️ ${validation.errorMessage}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF7C3AED),
          duration: const Duration(seconds: 3),
        ));
      }
      return;
    }

    setState(() => isLoading = true);
    try {
      var resText = await TranslationService.translate(
        text: query,
        fromCode: fromLang.code,
        toCode: toLang.code,
      );
      if (mounted) {
        setState(() {
          translatedText = resText;
          isLoading = false;
        });
        // Simpan state aktif ke SharedPreferences agar tidak hilang saat keluar/recents
        SettingsService.setLastInputText(query);
        SettingsService.setLastTranslatedText(resText);
        SettingsService.setLastFromLang(fromLang.code);
        SettingsService.setLastToLang(toLang.code);
        
        // Increment translation count in user profile
        UserProfileService.incrementTranslationCount();
        // Simpan ke riwayat terjemahan
        HistoryService.addHistory(
          sourceText: query,
          translatedText: resText,
          fromCode: fromLang.code,
          fromName: fromLang.name,
          toCode: toLang.code,
          toName: toLang.name,
        );
      }
    } catch (e) {
      if (mounted) {
        final errStr = e.toString().toLowerCase();
        String errorDisplay;
        if (errStr.contains('socket') ||
            errStr.contains('connection') ||
            errStr.contains('network') ||
            errStr.contains('timeout') ||
            errStr.contains('clientexception')) {
          errorDisplay = "Terjadi kesalahan. Periksa koneksi internet Anda.";
        } else if (errStr.contains('languagenotsupported') ||
            errStr.contains('not supported') ||
            errStr.contains('tidak dapat diterjemahkan')) {
          errorDisplay =
              "Bahasa ini memerlukan mesin Cloud API Key di Pengaturan.";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Gunakan Cloud API Key (DeepL / OpenAI / Google) di Pengaturan.'),
              backgroundColor: const Color(0xFF6366F1),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Pengaturan',
                textColor: Colors.amber,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ),
          );
        } else {
          var msg = e.toString().replaceAll('Exception: ', '').replaceAll('Instance of ', '');
          errorDisplay = "Gagal menerjemahkan: $msg";
        }

        setState(() {
          translatedText = errorDisplay;
          isLoading = false;
        });
      }
    }
  }

  void toggleListen() async {
    HapticService.selectionClick();
    FocusScope.of(context).unfocus();

    if (_isListening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
      if (textController.text.trim().isNotEmpty) translate();
      return;
    }

    // 1. Cek & minta izin mikrofon
    var micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      micStatus = await Permission.microphone.request();
    }

    if (!micStatus.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Izin mikrofon diperlukan. Aktifkan di pengaturan HP.'),
          action: SnackBarAction(
            label: 'Pengaturan',
            textColor: const Color(0xFFA5B4FC),
            onPressed: () => openAppSettings(),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1E293B),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final speechLocale = LanguageService.toSpeechLocale(fromLang.code);
    setState(() => _isListening = true);

    try {
      // 2. Jalankan Pengenalan Suara Google Resmi (Sama persis seperti di Keyboard Gboard)
      final text = await NativeSpeechService.startListening(
        locale: speechLocale,
        prompt: 'Bicara sekarang (${fromLang.name})...',
      );

      if (mounted) {
        setState(() => _isListening = false);
        if (text != null && text.isNotEmpty) {
          textController.text = text;
          textController.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
          translate();
        }
      }
    } catch (e) {
      debugPrint("Native speech error: $e, falling back to STT listener");
      if (mounted) {
        _startListeningWithLocale(speechLocale);
      }
    }
  }

  void _startListeningWithLocale(String localeId, {bool isFallback = false}) async {
    try {
      String? targetLocale = localeId;

      try {
        final system = await _speech.systemLocale();
        final locales = await _speech.locales();
        debugPrint("STT Available locales count: ${locales.length}, system: ${system?.localeId}");
        if (locales.isNotEmpty) {
          final cleanTarget = localeId.replaceAll('_', '-').toLowerCase();
          final exactMatch = locales.where(
            (l) => l.localeId.replaceAll('_', '-').toLowerCase() == cleanTarget,
          );
          if (exactMatch.isNotEmpty) {
            targetLocale = exactMatch.first.localeId;
          } else {
            final base = cleanTarget.split('-').first;
            final baseMatch = locales.where(
              (l) => l.localeId.toLowerCase().startsWith(base),
            );
            if (baseMatch.isNotEmpty) {
              targetLocale = baseMatch.first.localeId;
            } else if (system != null) {
              targetLocale = system.localeId;
            }
          }
        } else if (system != null) {
          targetLocale = system.localeId;
        }
      } catch (e) {
        debugPrint("Locale check error: $e");
      }

      debugPrint("STT Calling _speech.listen with locale: $targetLocale");
      bool started = await _speech.listen(
        onResult: (val) {
          debugPrint("STT onResult: recognizedWords='${val.recognizedWords}', final=${val.finalResult}");
          if (mounted) {
            final words = val.recognizedWords;
            if (words.isNotEmpty) {
              setState(() {
                textController.text = words;
                textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: words.length),
                );
              });
              if (val.finalResult) {
                translate();
              }
            }
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: targetLocale,
          listenMode: stt.ListenMode.deviceDefault,
          listenFor: const Duration(seconds: 45),
          pauseFor: const Duration(seconds: 5),
          cancelOnError: false,
          partialResults: true,
          onDevice: false,
        ),
      );
      debugPrint("STT _speech.listen started: $started");
      if (!started && mounted) {
        setState(() => _isListening = false);
      }
    } catch (e) {
      debugPrint("STT listen error: $e");
      if (!isFallback && mounted) {
        _startListeningWithLocale('id-ID', isFallback: true);
      } else {
        if (mounted) setState(() => _isListening = false);
      }
    }
  }

  void toggleSpeak() async {
    final textToSpeak = translatedText.trim();
    if (textToSpeak.isEmpty ||
        textToSpeak.startsWith("Terjadi kesalahan") ||
        textToSpeak.startsWith("Gagal") ||
        textToSpeak.startsWith("Bahasa ini")) {
      return;
    }

    if (_isSpeaking) {
      await _flutterTts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }

    HapticService.lightImpact();
    setState(() => _isSpeaking = true);

    // Baca gender real-time setiap kali tombol speaker ditekan
    final voiceGender = await SettingsService.getVoiceGender();
    final isMale = voiceGender == 'male';

    // Bangun kode BCP-47 yang benar untuk bahasa target
    final ttsLanguage = LanguageService.toTtsLanguage(toLang.code);

    try {
      // Set Google TTS Engine jika ada
      try {
        final engines = await _flutterTts.getEngines;
        if (engines is List && engines.contains('com.google.android.tts')) {
          await _flutterTts.setEngine('com.google.android.tts');
        }
      } catch (_) {}

      // ── Pilih bahasa TTS dengan fallback chain ─────────────────
      var langAvailable = await _flutterTts.isLanguageAvailable(ttsLanguage);
      if (langAvailable == 1 || langAvailable == true) {
        await _flutterTts.setLanguage(ttsLanguage);
      } else {
        final base = ttsLanguage.split('-').first.toLowerCase();
        var baseAvailable = await _flutterTts.isLanguageAvailable(base);
        if (baseAvailable == 1 || baseAvailable == true) {
          await _flutterTts.setLanguage(base);
        } else {
          await _flutterTts.setLanguage('id-ID');
        }
      }

      // ── Pemilihan Suara Pria/Wanita (Universal Multi-Language 100% Earth Support) ──
      try {
        final voices = await _flutterTts.getVoices;
        if (voices is List && voices.isNotEmpty) {
          final targetPrefix = ttsLanguage.split('-').first.toLowerCase();

          final matchingVoices = voices.where((v) {
            if (v is Map) {
              final locale = (v['locale'] ?? '').toString().toLowerCase();
              return locale.startsWith(targetPrefix);
            }
            return false;
          }).toList();

          final searchList = matchingVoices.isNotEmpty
              ? matchingVoices
              : voices.where((v) => v is Map && (v['locale'] ?? '').toString().toLowerCase().startsWith('id')).toList();

          if (searchList.isNotEmpty) {
            Map? picked;

            // Layer 1: Explicit 'gender' field check (supports 'male', 'male_heavy', 'female', etc.)
            for (final v in searchList) {
              if (v is Map) {
                final g = (v['gender'] ?? '').toString().toLowerCase();
                final isMaleGender = (g.contains('male') && !g.contains('female')) || g == '1';
                final isFemaleGender = g.contains('female') || g == '2';
                if (isMale ? isMaleGender : isFemaleGender) {
                  picked = v; break;
                }
              }
            }

            // Layer 2: Universal Language Pattern Matching
            if (picked == null) {
              for (final v in searchList) {
                if (v is Map) {
                  final name = (v['name'] ?? '').toString().toLowerCase();
                  if (targetPrefix == 'id') {
                    // Indonesian Specifics
                    final match = isMale
                        ? (name.contains('i-network') || name.contains('i-local') || name.contains('fic') ||
                           name.contains('male') || name.contains('pria') || name.contains('cowok') || name.contains('cowo'))
                        : (name.contains('dfz') || name.contains('female') || name.contains('wanita') || name.contains('cewek') || name.contains('cewe'));
                    if (match) { picked = v; break; }
                  } else {
                    // All International Languages (English, Chinese, Japanese, Arabic, Spanish, etc.)
                    final match = isMale
                        ? (name.contains('male') || name.contains('#m') || name.contains('_m') || name.contains('sfg') || name.contains('iob') || name.contains('jol') ||
                           name.contains('-b-') || name.contains('-d-') || name.contains('-g-') || name.contains('-j-') ||
                           name.contains('b-network') || name.contains('d-network') || name.contains('g-network') || name.contains('j-network'))
                        : (name.contains('female') || name.contains('#f') || name.contains('_f') || name.contains('tpf') || name.contains('iom') || name.contains('lpf') ||
                           name.contains('-a-') || name.contains('-c-') || name.contains('-e-') || name.contains('-f-') || name.contains('-h-') ||
                           name.contains('a-network') || name.contains('c-network') || name.contains('e-network') || name.contains('f-network') || name.contains('h-network'));
                    if (match) { picked = v; break; }
                  }
                }
              }
            }

            // Layer 3: Exclusion fallback
            if (picked == null) {
              for (final v in searchList) {
                if (v is Map) {
                  final name = (v['name'] ?? '').toString().toLowerCase();
                  final isOpposite = isMale
                      ? (name.contains('female') || name.contains('tpf') || name.contains('iom') || name.contains('lpf') || name.contains('wanita') || name.contains('cewek'))
                      : (name.contains('male') || name.contains('sfg') || name.contains('iob') || name.contains('jol') || name.contains('pria') || name.contains('cowok'));
                  if (!isOpposite) { picked = v; break; }
                }
              }
            }

            if (picked != null && picked['name'] != null) {
              await _flutterTts.setVoice({
                "name": picked['name'].toString(),
                "locale": picked['locale']?.toString() ?? ttsLanguage,
              });
              debugPrint("[TTS] Main speaking lang=$ttsLanguage voice=${picked['name']} isMale=$isMale");
            }
          }
        }
      } catch (e) {
        debugPrint("[TTS] main voice selection error: $e");
      }

      // ── Parameter Suara & Pitch Calibration ──────────────────────────────
      // Male pitch: 0.58 (natural bass male), Female pitch: 1.18 (bright clear female)
      final double targetPitch = isMale ? 0.58 : 1.18;

      await _flutterTts.setSpeechRate(0.38); // 0.38 = tempo santai, pelan & jelas
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(targetPitch);
      await _flutterTts.speak(textToSpeak);

    } catch (e) {
      debugPrint("[TTS] speak error: $e — fallback id-ID");
      try {
        await _flutterTts.setLanguage('id-ID');
        await _flutterTts.setPitch(isMale ? 0.70 : 1.15);
        await _flutterTts.speak(textToSpeak);
      } catch (_) {
        if (mounted) setState(() => _isSpeaking = false);
      }
    }
  }

  void swapLanguages() {
    if (fromLang.code == 'auto') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih bahasa spesifik untuk menukar.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      final temp = fromLang;
      fromLang = toLang;
      toLang = temp;
    });
    SettingsService.setLastFromLang(fromLang.code);
    SettingsService.setLastToLang(toLang.code);
    if (textController.text.isNotEmpty) translate();
  }

  void copyToClipboard() {
    if (translatedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teks terjemahan berhasil disalin!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF6366F1),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      textController.text = data.text!;
      translate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Floating Glassmorphism Language Bar
            LanguageBar(
              fromLang: fromLang,
              toLang: toLang,
              languages: allLanguages,
              onFromSelected: (lang) {
                setState(() => fromLang = lang);
                SettingsService.setLastFromLang(lang.code);
                if (textController.text.isNotEmpty) translate();
              },
              onToSelected: (lang) {
                setState(() => toLang = lang);
                SettingsService.setLastToLang(lang.code);
                if (textController.text.isNotEmpty) translate();
              },
              onSwap: swapLanguages,
            ),
            const SizedBox(height: 20),
            TranslationInput(
              controller: textController,
              onChanged: _onTextChanged,
              isLoading: isLoading,
              isListening: _isListening,
              onListen: toggleListen,
              onClear: () {
                textController.clear();
                setState(() => translatedText = "");
                SettingsService.setLastInputText('');
                SettingsService.setLastTranslatedText('');
              },
              onPaste: pasteFromClipboard,
            ),
            if (translatedText.isNotEmpty) const SizedBox(height: 20),
            TranslationResult(
              text: translatedText,
              languageName: toLang.name,
              languageFlag: toLang.flag,
              isSpeaking: _isSpeaking,
              onSpeak: toggleSpeak,
              onCopy: copyToClipboard,
            ),
            const SizedBox(height: 24),
            // Quick History Bar
            InkWell(
              onTap: () {
                HistoryBottomSheet.show(
                  context,
                  onSelectHistory: (item) {
                    setState(() {
                      textController.text = item.sourceText;
                      translatedText = item.translatedText;
                      final f = LanguageService.findByCode(item.fromCode);
                      if (f != null) fromLang = f;
                      final t = LanguageService.findByCode(item.toCode);
                      if (t != null) toLang = t;
                    });
                    SettingsService.setLastInputText(item.sourceText);
                    SettingsService.setLastTranslatedText(item.translatedText);
                    SettingsService.setLastFromLang(item.fromCode);
                    SettingsService.setLastToLang(item.toCode);
                  },
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3), width: 1.2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history_rounded, size: 18, color: Color(0xFF818CF8)),
                    SizedBox(width: 8),
                    Text(
                      'Lihat Riwayat Terjemahan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA5B4FC),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFA5B4FC)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Opacity(
              opacity: 0.75,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Color(0xFFA5B4FC)),
                    SizedBox(width: 8),
                    Text(
                      'Powered by mzkyzak mobile✌️💻',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
