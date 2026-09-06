// Halaman pengaturan
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/animated_border.dart';
import '../services/translation_service.dart';
import '../services/settings_service.dart';
import '../services/haptic_service.dart';
import '../services/user_profile_service.dart';
import '../main.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoDetect = true;
  bool _hapticFeedback = true;
  String _themeOption = 'dark'; // 'system', 'dark', 'light'
  String _voiceGender = 'male'; // 'male' or 'female'
  String _currentApiKey = '';
  TranslationProvider _currentProvider = TranslationProvider.googleFree;
  String _displayName = 'pengguna';

  @override
  void initState() {
    super.initState();
    _loadAllSettings();
  }

  Future<void> _loadAllSettings() async {
    final key = await TranslationService.getApiKey();
    final provider = await TranslationService.getProvider();
    final autoDetect = await SettingsService.getAutoDetect();
    final haptic = await SettingsService.getHapticEnabled();
    final themeOption = await SettingsService.getThemeOption();
    final voiceGender = await SettingsService.getVoiceGender();
    final name = await UserProfileService.getDisplayName();

    if (mounted) {
      setState(() {
        _currentApiKey = key;
        _currentProvider = provider;
        _autoDetect = autoDetect;
        _hapticFeedback = haptic;
        _themeOption = themeOption;
        _voiceGender = voiceGender;
        _displayName = name;
      });
    }
  }

  // ── 1. PROFIL PENGGUNA ─────────────────────────────────────
  void _openProfile() {
    HapticService.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    ).then((_) => _loadAllSettings()); // Refresh after returning
  }

  // ── 2. MESIN TERJEMAHAN ────────────────────────────────────
  void _showEngineDialog(BuildContext context) {
    HapticService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.4), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.psychology_rounded, color: Color(0xFF818CF8), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mesin Terjemahan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Harus mengaktifkan Provider: ${_getProviderLabel(_currentProvider)}',
                style: const TextStyle(color: Color(0xFFA5B4FC), fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              const Text(
                'Karena model ini untuk pemrosesan bahasa alami (NLP) tingkat lanjut untuk menghasilkan terjemahan yang akurat, natural, dan sesuai konteks secara real-time.',
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text(
                'Ganti mesin terjemahan melalui menu "Kunci API Cloud" di bawah.',
                style: TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Paham Gak?', style: TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _getProviderLabel(TranslationProvider provider) {
    switch (provider) {
      case TranslationProvider.googleFree:
        return '🌐 Google Translate (Gratis)';
      case TranslationProvider.googleCloud:
        return '☁️ Google Cloud API';
      case TranslationProvider.deepl:
        return '⚡ DeepL API';
      case TranslationProvider.openAi:
        return '🤖 OpenAI GPT-4o-mini';
    }
  }

  // ── 3. DETEKSI BAHASA OTOMATIS ─────────────────────────────
  void _toggleAutoDetect(bool value) async {
    HapticService.lightImpact();
    setState(() => _autoDetect = value);
    await SettingsService.setAutoDetect(value);
  }

  // ── 4. DARK / LIGHT MODE ───────────────────────────────────
  void _showThemeSelector() {
    HapticService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.4), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.palette_rounded, color: Color(0xFF818CF8), size: 26),
              SizedBox(width: 10),
              Text('Pilih Tema', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(ctx, 'system', Icons.brightness_auto_rounded, 'Ikuti Sistem', 'Otomatis sesuai pengaturan HP'),
              const SizedBox(height: 8),
              _buildThemeOption(ctx, 'dark', Icons.dark_mode_rounded, 'Mode Gelap', 'Nyaman di mata, hemat baterai'),
              const SizedBox(height: 8),
              _buildThemeOption(ctx, 'light', Icons.light_mode_rounded, 'Mode Cerah', 'Kristal terang & bersih'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext ctx, String option, IconData icon, String title, String subtitle) {
    final isSelected = _themeOption == option;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          HapticService.selectionClick();
          setState(() => _themeOption = option);
          await SettingsService.setThemeOption(option);

          switch (option) {
            case 'system':
              MyApp.themeNotifier.value = ThemeMode.system;
              break;
            case 'dark':
              MyApp.themeNotifier.value = ThemeMode.dark;
              break;
            case 'light':
              MyApp.themeNotifier.value = ThemeMode.light;
              break;
          }

          if (ctx.mounted) Navigator.pop(ctx);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF818CF8).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFFA5B4FC) : Colors.white54, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
                    Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeLabel() {
    switch (_themeOption) {
      case 'system':
        return 'Ikuti Sistem (Otomatis)';
      case 'light':
        return 'Mode Cerah (Kristal & Terang)';
      default:
        return 'Mode Gelap (Indera Visual Nyaman)';
    }
  }

  IconData _getThemeIcon() {
    switch (_themeOption) {
      case 'system':
        return Icons.brightness_auto_rounded;
      case 'light':
        return Icons.light_mode_outlined;
      default:
        return Icons.dark_mode_outlined;
    }
  }

  // ── 5. HAPTIC FEEDBACK ─────────────────────────────────────
  void _toggleHaptic(bool value) async {
    setState(() => _hapticFeedback = value);
    await SettingsService.setHapticEnabled(value);
    if (value) HapticService.mediumImpact(); // Demo getar saat diaktifkan
  }

  // ── SUARA SPEAKER (PRIA / WANITA) ───────────────────────────
  /// Mainkan preview TTS singkat saat user pilih gender suara
  Future<void> _previewVoice(String gender) async {
    final isMale = gender == 'male';
    final tts = FlutterTts();
    try {
      // Coba set Google TTS engine
      try {
        final engines = await tts.getEngines;
        if (engines is List && engines.contains('com.google.android.tts')) {
          await tts.setEngine('com.google.android.tts');
        }
      } catch (_) {}

      await tts.setLanguage('id-ID');

      // Cari voice yang cocok (Universal Multi-Language Engine)
      try {
        final voices = await tts.getVoices;
        if (voices is List && voices.isNotEmpty) {
          final matching = voices.where((v) =>
            v is Map && (v['locale'] ?? '').toString().toLowerCase().startsWith('id')
          ).toList();
          if (matching.isNotEmpty) {
            Map? picked;
            // Layer 1: Explicit 'gender' field check
            for (final v in matching) {
              if (v is Map) {
                final g = (v['gender'] ?? '').toString().toLowerCase();
                if (isMale ? (g == 'male' || g == '1') : (g == 'female' || g == '2')) {
                  picked = v; break;
                }
              }
            }
            // Layer 2: Universal Pattern Matching
            if (picked == null) {
              for (final v in matching) {
                if (v is Map) {
                  final name = (v['name'] ?? '').toString().toLowerCase();
                  final match = isMale
                      ? (name.contains('i-network') || name.contains('i-local') || name.contains('fic') ||
                         name.contains('male') || name.contains('pria') || name.contains('cowok') || name.contains('cowo'))
                      : (name.contains('dfz') || name.contains('female') || name.contains('wanita') || name.contains('cewek') || name.contains('cewe'));
                  if (match) { picked = v; break; }
                }
              }
            }
            // Layer 3: Exclusion Fallback
            if (picked == null) {
              for (final v in matching) {
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
              await tts.setVoice({'name': picked['name'].toString(), 'locale': picked['locale'].toString()});
            }
          }
        }
      } catch (_) {}

      final double targetPitch = isMale ? 0.70 : 1.15;

      await tts.setSpeechRate(0.38); // 0.38 = tempo santai, pelan & jelas
      await tts.setVolume(1.0);
      await tts.setPitch(targetPitch);
      await tts.speak(isMale
          ? 'Halo, ini suara cowok. Cocok buat Lu?'
          : 'Halo, ini suara cewek. Cocok buat Lu?');
    } catch (e) {
      debugPrint('[SettingsTTS] preview error: $e');
    }
  }

  void _showVoiceGenderSelector() {
    HapticService.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'Pilih Suara Pembacaan (Speaker)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Ketuk pilihan untuk preview suaranya 🔊',
                        style: TextStyle(fontSize: 12, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // ── Opsi Pria ────────────────────────────────────
                    ListTile(
                      leading: const Icon(Icons.male_rounded, color: Color(0xFF60A5FA), size: 28),
                      title: const Text('Suara Pria (Cowok)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Intonasi maskulin, berat, wibawa dan natural', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      trailing: _voiceGender == 'male'
                          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF60A5FA))
                          : const Icon(Icons.play_circle_outline_rounded, color: Colors.white38, size: 22),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      tileColor: _voiceGender == 'male'
                          ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                          : null,
                      onTap: () async {
                        HapticService.selectionClick();
                        await SettingsService.setVoiceGender('male');
                        setState(() => _voiceGender = 'male');
                        setSheet(() {});
                        _previewVoice('male'); // Preview suara pria langsung
                      },
                    ),
                    const SizedBox(height: 8),
                    // ── Opsi Wanita ──────────────────────────────────
                    ListTile(
                      leading: const Icon(Icons.female_rounded, color: Color(0xFFF472B6), size: 28),
                      title: const Text('Suara Wanita (Cewek)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Intonasi feminin, lembut, ramah dan jernih', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      trailing: _voiceGender == 'female'
                          ? const Icon(Icons.check_circle_rounded, color: Color(0xFFF472B6))
                          : const Icon(Icons.play_circle_outline_rounded, color: Colors.white38, size: 22),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      tileColor: _voiceGender == 'female'
                          ? const Color(0xFFEC4899).withValues(alpha: 0.15)
                          : null,
                      onTap: () async {
                        HapticService.selectionClick();;
                        await SettingsService.setVoiceGender('female');
                        setState(() => _voiceGender = 'female');
                        setSheet(() {});
                        _previewVoice('female'); // Preview suara wanita langsung
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Simpan & Tutup'),
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF818CF8)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── 6. API KEY CLOUD ───────────────────────────────────────
  void _showApiKeyDialog(BuildContext context) async {
    final currentKey = await TranslationService.getApiKey();
    final currentProvider = await TranslationService.getProvider();
    final keyController = TextEditingController(text: currentKey);
    TranslationProvider selectedProvider = currentProvider;
    bool isTesting = false;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.96),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.4), width: 1.5),
            ),
            title: const Row(
              children: [
                Icon(Icons.key_rounded, color: Color(0xFF818CF8), size: 26),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Kunci API Cloud',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih mesin penerjemah yang ingin digunakan:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TranslationProvider>(
                      initialValue: selectedProvider,
                      dropdownColor: const Color(0xFF1E293B),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Penyedia Layanan',
                        labelStyle: const TextStyle(color: Color(0xFFA5B4FC)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
                      ),
                      items: const [
                        DropdownMenuItem(value: TranslationProvider.googleFree, child: Text('🌐 Bawaan (100% Gratis & Unlimited)')),
                        DropdownMenuItem(value: TranslationProvider.deepl, child: Text('⚡ DeepL API (Free 500k Karakter)')),
                        DropdownMenuItem(value: TranslationProvider.openAi, child: Text('🤖 OpenAI GPT-4o Mini')),
                        DropdownMenuItem(value: TranslationProvider.googleCloud, child: Text('☁️ Google Cloud Translation v2')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedProvider = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Panduan Dinamis Sesuai Provider Terpilih
                    _buildProviderGuideCard(ctx, selectedProvider),

                    if (selectedProvider != TranslationProvider.googleFree) ...[
                      const SizedBox(height: 14),
                      TextField(
                        controller: keyController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        onChanged: (_) => setDialogState(() {}),
                        decoration: InputDecoration(
                          labelText: 'API Key Rahasia',
                          labelStyle: const TextStyle(color: Color(0xFFA5B4FC)),
                          hintText: 'Tempelkan API key di sini...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (keyController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear_rounded, color: Colors.white54, size: 20),
                                  onPressed: () {
                                    keyController.clear();
                                    setDialogState(() {});
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.paste_rounded, color: Color(0xFFA5B4FC), size: 20),
                                tooltip: 'Tempel dari Clipboard',
                                onPressed: () async {
                                  final data = await Clipboard.getData('text/plain');
                                  if (data?.text != null && data!.text!.trim().isNotEmpty) {
                                    keyController.text = data.text!.trim();
                                    setDialogState(() {});
                                    if (ctx.mounted) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text('📋 API key berhasil ditempel!'),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Test Connection Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: isTesting
                              ? const SizedBox(
                                  width: 16, height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFA5B4FC)),
                                )
                              : const Icon(Icons.wifi_tethering_rounded, size: 18),
                          label: Text(isTesting ? 'Menguji Koneksi...' : 'Test Koneksi API'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFA5B4FC),
                            side: const BorderSide(color: Color(0xFF6366F1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: isTesting
                              ? null
                              : () async {
                                  setDialogState(() => isTesting = true);
                                  await TranslationService.setApiKey(keyController.text.trim());
                                  await TranslationService.setProvider(selectedProvider);
                                  final result = await SettingsService.testApiConnection();
                                  setDialogState(() => isTesting = false);
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                      content: Text(result.success ? '✅ ${result.message}' : '❌ ${result.message}'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: result.success ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                    ));
                                  }
                                },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  await TranslationService.setApiKey(keyController.text.trim());
                  await TranslationService.setProvider(selectedProvider);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    _loadAllSettings();
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Konfigurasi API berhasil disimpan!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── PANDUAN API PROVIDER (GLASSMORPHIC) ────────────────────
  Widget _buildProviderGuideCard(BuildContext context, TranslationProvider provider) {
    switch (provider) {
      case TranslationProvider.googleFree:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                  SizedBox(width: 8),
                  Text(
                    '100% Gratis & Bebas Kuota',
                    style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'Mesin bawaan sudah aktif otomatis tanpa perlu API key apa pun. lu dapat langsung menerjemahkan semua bahasa dunia dan bahasa daerah.',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        );

      case TranslationProvider.deepl:
        return _buildCloudGuideBox(
          context: context,
          brandColor: const Color(0xFF38BDF8),
          badgeText: 'GRATIS 500.000 KARAKTER / BULAN',
          websiteUrl: 'https://www.deepl.com/pro-api',
          websiteLabel: 'Website DeepL API Free',
          steps: const [
            '1. Buka situs resmi DeepL API (klik tombol di bawah).',
            '2. Buat akun & pilih paket "DeepL API Free" (Gratis 0\$).',
            '3. Masuk menu Akun > salin "Authentication Key for DeepL API" (kunci berakhiran :fx).',
            '4. Tempel kunci tersebut pada kolom input di bawah.',
          ],
        );

      case TranslationProvider.openAi:
        return _buildCloudGuideBox(
          context: context,
          brandColor: const Color(0xFF10A37F),
          badgeText: 'AI NEURAL GPT-4O',
          websiteUrl: 'https://platform.openai.com/api-keys',
          websiteLabel: 'Website OpenAI API Keys',
          steps: const [
            '1. Buka dashboard OpenAI (klik tombol di bawah).',
            '2. Login / Buat akun di platform.openai.com.',
            '3. Klik menu "API Keys" > "+ Create new secret key".',
            '4. Salin kunci (diawali sk-...) dan tempel di kolom input.',
          ],
        );

      case TranslationProvider.googleCloud:
        return _buildCloudGuideBox(
          context: context,
          brandColor: const Color(0xFF818CF8),
          badgeText: 'FREE TIER 500.000 KARAKTER',
          websiteUrl: 'https://console.cloud.google.com/apis/credentials',
          websiteLabel: 'Google Cloud Console',
          steps: const [
            '1. Buka Google Cloud Console (klik tombol di bawah).',
            '2. Aktifkan layanan "Cloud Translation API" pada project Anda.',
            '3. Masuk menu "Credentials" > Klik "+ CREATE CREDENTIALS" > "API key".',
            '4. Salin API key Google Cloud lalu tempel di kolom input.',
          ],
        );
    }
  }

  Widget _buildCloudGuideBox({
    required BuildContext context,
    required Color brandColor,
    required String badgeText,
    required String websiteUrl,
    required String websiteLabel,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: brandColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: brandColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Panduan Cara Mendapatkan API Key:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          for (final step in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                step,
                style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_browser_rounded, size: 14),
                  label: Text(websiteLabel, style: const TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandColor.withValues(alpha: 0.25),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: brandColor.withValues(alpha: 0.5)),
                    ),
                  ),
                  onPressed: () async {
                    final uri = Uri.parse(websiteUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Salin Link Website',
                icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: websiteUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🔗 Link disalin: $websiteUrl'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 7. TENTANG APLIKASI ────────────────────────────────────
  void _showAboutDialog(BuildContext context) {
    HapticService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.4), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.g_translate_rounded, color: Color(0xFF818CF8), size: 28),
              SizedBox(width: 12),
              Text(
                'Terjemahan mzkyzak',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'Versi 2.0.0+2 (Build 2026)',
                    style: TextStyle(color: Color(0xFFA5B4FC), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mzkyzak Translator merupakan aplikasi penerjemah gratis yang '
                  'dirancang untuk membantu menerjemahkan berbagai bahasa daerah '
                  'dan bahasa global secara otomatis. Nikmati pengalaman menerjemahkan '
                  'yang praktis dan mudah digunakan dengan Mzkyzak Translator. '
                  'Gunakan mesin penerjemahan gratis tanpa API key, atau aktifkan '
                  'Cloud API untuk mendapatkan dukungan bahasa yang lebih luas. '
                  'Dibuat dan dikembangkan oleh Mzkyzak (Taufiq Ikhsan Muzaky) '
                  'dengan tujuan menghadirkan penerjemahan yang cepat, sederhana, '
                  'dan mudah diakses oleh semua pengguna.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 12),
                const Text(
                  'FITUR & TEKNOLOGI UNGGULAN',
                  style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                ),
                const SizedBox(height: 10),
                _buildFeatureBadge(
                  Icons.auto_awesome_rounded,
                  const Color(0xFF818CF8),
                  'Desain UI Glassmorphism',
                  'Tampilan modern, frosted glass & animasi responsif 120 FPS',
                ),
                _buildFeatureBadge(
                  Icons.speed_rounded,
                  const Color(0xFF10B981),
                  'Performa Stabil & Responsif',
                  'Optimasi render Native AOT cepat, stabil dan tanpa lag',
                ),
                _buildFeatureBadge(
                  Icons.cloud_done_rounded,
                  const Color(0xFF38BDF8),
                  'Multi-Engine Hybrid Cloud',
                  'Support Google Cloud, DeepL, OpenAI & Mesin Gratis',
                ),
                _buildFeatureBadge(
                  Icons.mic_rounded,
                  const Color(0xFFEC4899),
                  'Suara Alami STT & TTS',
                  'Input suara mikrofon & suara bakal asli per bahasa',
                ),
                _buildFeatureBadge(
                  Icons.verified_rounded,
                  const Color(0xFFF59E0B),
                  'Lisensi Resmi & Bebas Iklan',
                  '100% gratis digunakan untuk seluruh bahasa daerah dan dunia',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup', style: TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, Color color, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Banner Header Pengaturan
            AnimatedBorderContainer(
              borderRadius: 24,
              borderWidth: 1.5,
              duration: const Duration(seconds: 6),
              colors: const [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF818CF8)],
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withValues(alpha: 0.25),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengaturan & Konfigurasi',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kustomisasi pengalaman aplikasi terjemahan Anda.',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── 1. Profil Pengguna ──
            _buildGlassTile(
              icon: Icons.person_outline_rounded,
              title: 'Profil Pengguna',
              subtitle: _displayName,
              badge: 'PRO',
              badgeColor: Colors.amber,
              onTap: _openProfile,
            ),
            const SizedBox(height: 16),

            // ── 2. Mesin Terjemahan ──
            _buildGlassTile(
              icon: Icons.translate_rounded,
              title: 'Mesin Terjemahan',
              subtitle: _getProviderLabel(_currentProvider),
              onTap: () => _showEngineDialog(context),
            ),
            const SizedBox(height: 16),

            // ── 3. Deteksi Bahasa Otomatis ──
            _buildGlassTile(
              icon: Icons.auto_awesome_rounded,
              title: 'Deteksi Bahasa Otomatis',
              subtitle: _autoDetect
                  ? 'Aktif — Mengenali bahasa input otomatis'
                  : 'Nonaktif — Pilih bahasa sumber manual',
              trailing: Switch(
                value: _autoDetect,
                activeThumbColor: const Color(0xFF818CF8),
                onChanged: _toggleAutoDetect,
              ),
            ),
            const SizedBox(height: 16),

            // ── 4. Dark / Light Mode ──
            _buildGlassTile(
              icon: _getThemeIcon(),
              title: 'Tampilan Tema',
              subtitle: _getThemeLabel(),
              onTap: _showThemeSelector,
            ),
            const SizedBox(height: 16),

            // ── 5. Haptic Feedback ──
            _buildGlassTile(
              icon: Icons.vibration_rounded,
              title: 'Respon Getar (Haptic)',
              subtitle: _hapticFeedback
                  ? 'Aktif — Getar saat tombol ditekan'
                  : 'Nonaktif — Tanpa umpan balik getar',
              trailing: Switch(
                value: _hapticFeedback,
                activeThumbColor: const Color(0xFF818CF8),
                onChanged: _toggleHaptic,
              ),
            ),
            const SizedBox(height: 16),

            // ── Suara Pembacaan (Pria / Wanita) ──
            _buildGlassTile(
              icon: _voiceGender == 'male' ? Icons.record_voice_over_rounded : Icons.voice_chat_rounded,
              title: 'Suara Pembacaan (Speaker)',
              subtitle: _voiceGender == 'male' ? 'Suara Pria (Cowok) 👨' : 'Suara Wanita (Cewek) 👩',
              badge: _voiceGender == 'male' ? 'COWOK' : 'CEWEK',
              badgeColor: _voiceGender == 'male' ? const Color(0xFF3B82F6) : const Color(0xFFEC4899),
              onTap: _showVoiceGenderSelector,
            ),
            const SizedBox(height: 16),

            // ── 6. API Key Cloud ──
            _buildGlassTile(
              icon: Icons.key_rounded,
              title: 'Kunci API Cloud',
              subtitle: _currentApiKey.isEmpty
                  ? 'Gratis — Mesin bawaan aktif'
                  : '${_currentProvider.name.toUpperCase()} terhubung',
              badge: _currentApiKey.isNotEmpty ? 'CLOUD' : 'GRATIS',
              badgeColor: _currentApiKey.isNotEmpty ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
              onTap: () => _showApiKeyDialog(context),
            ),
            const SizedBox(height: 16),

            // ── 7. Tentang Aplikasi ──
            _buildGlassTile(
              icon: Icons.info_outline_rounded,
              title: 'Tentang Aplikasi',
              subtitle: 'Versi 2.0.0+2 — Terjemahan mzkyzak',
              onTap: () => _showAboutDialog(context),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  GLASS TILE COMPONENT
  // ══════════════════════════════════════════════════════════════
  Widget _buildGlassTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    String? badge,
    Color? badgeColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                ),
                child: Icon(icon, color: const Color(0xFF38BDF8), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (badgeColor ?? Colors.blue).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: (badgeColor ?? Colors.blue).withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: badgeColor ?? Colors.blue,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (trailing != null)
                trailing
              else if (onTap != null)
                const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
