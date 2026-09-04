import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';
import 'models/language.dart';
import 'widgets/language_selector.dart';
import 'widgets/translation_input.dart';
import 'widgets/translation_result.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mzkyzak terjemahan',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
        brightness: Brightness.light,
        fontFamily: 'Inter', // Menambah kesan profesional jika tersedia
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final GoogleTranslator translator = GoogleTranslator();
  final TextEditingController textController = TextEditingController();

  Language fromLang = allLanguages[0]; // Auto
  Language toLang = allLanguages[2]; // English (default index change to match UI better)
  String translatedText = "";
  bool isLoading = false;

  void translate() async {
    final query = textController.text.trim();
    if (query.isEmpty) {
      setState(() => translatedText = "");
      return;
    }

    setState(() => isLoading = true);

    try {
      var translation = await translator.translate(
        query,
        from: fromLang.code,
        to: toLang.code,
      );

      setState(() {
        translatedText = translation.text;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        translatedText = "Terjadi kesalahan. Periksa koneksi internet Anda.";
        isLoading = false;
      });
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
    if (textController.text.isNotEmpty) translate();
  }

  void copyToClipboard() {
    if (translatedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Teks berhasil disalin!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      textController.text = data!.text!;
      translate();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'terjemahan mzkyzak',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            color: Color(0xFF1E1B4B),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEEF2FF),
                  Color(0xFFF5F3FF),
                  Color(0xFFFDF2F8),
                ],
              ),
            ),
          ),
          // Floating 3D-like background shapes
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.4),
                    const Color(0xFF6366F1).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEC4899).withOpacity(0.3),
                    const Color(0xFFEC4899).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Language Selector Row
                  Row(
                    children: [
                      Expanded(
                        child: LanguageSelector(
                          label: 'Dari',
                          selectedLanguage: fromLang,
                          languages: allLanguages,
                          onLanguageSelected: (lang) {
                            setState(() => fromLang = lang);
                            if (textController.text.isNotEmpty) translate();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              foregroundColor: const Color(0xFF6366F1),
                              padding: const EdgeInsets.all(12),
                            ),
                            onPressed: swapLanguages,
                            icon: const Icon(Icons.swap_horiz_rounded, size: 28),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LanguageSelector(
                          label: 'Ke',
                          selectedLanguage: toLang,
                          languages: allLanguages.where((l) => l.code != 'auto').toList(),
                          onLanguageSelected: (lang) {
                            setState(() => toLang = lang);
                            if (textController.text.isNotEmpty) translate();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Input Area
                  TranslationInput(
                    controller: textController,
                    isLoading: isLoading,
                    onClear: () {
                      textController.clear();
                      setState(() => translatedText = "");
                    },
                    onPaste: pasteFromClipboard,
                    onTranslate: translate,
                  ),

                  // Result Area
                  TranslationResult(
                    text: translatedText,
                    languageName: toLang.name,
                    languageFlag: toLang.flag,
                    onCopy: copyToClipboard,
                  ),

                  const SizedBox(height: 60),
                  // Footer Branding
                  Opacity(
                    opacity: 0.7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, size: 16, color: Color(0xFF6366F1)),
                          const SizedBox(width: 8),
                          Text(
                            'Powered by mzkyzak',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.indigo.shade900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
