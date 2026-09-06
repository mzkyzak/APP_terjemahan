// Halaman profil pengguna
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/language.dart';
import '../services/haptic_service.dart';
import '../services/user_profile_service.dart';
import '../widgets/animated_border.dart';
import '../widgets/history_bottom_sheet.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _displayName = 'kasih nama lu';
  String _primaryLanguage = 'Indonesia';
  String _primaryLangCode = 'id';
  int _translationCount = 0;
  String _createdAt = '';
  bool _isPro = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfileService.getProfile();
    if (mounted) {
      setState(() {
        _displayName = profile['displayName'] as String;
        _primaryLanguage = profile['primaryLanguage'] as String;
        _primaryLangCode = profile['primaryLanguageCode'] as String;
        _translationCount = profile['translationCount'] as int;
        _createdAt = profile['createdAt'] as String;
        _isPro = profile['isPro'] as bool;
        _isLoading = false;
      });
    }
  }

  // ── Ubah Nama Pengguna ─────────────────────────────────────
  void _editDisplayName() {
    HapticService.lightImpact();
    final controller = TextEditingController(text: _displayName);
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: const Color(0xFF6366F1).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_rounded, color: Color(0xFF818CF8), size: 24),
              SizedBox(width: 10),
              Text(
                'Ubah Nama Profil',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama ini digunakan sebagai identitas profil punya lu:',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                maxLength: 30,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Contoh: mzkyzak developer',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  counterStyle: const TextStyle(color: Colors.white38),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF818CF8), width: 1.5),
                  ),
                ),
              ),
            ],
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
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  HapticService.mediumImpact();
                  await UserProfileService.setDisplayName(name);
                  if (ctx.mounted) Navigator.pop(ctx);
                  _loadProfile();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Nama profil berhasil diubah menjadi "$name"'),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Ubah Bahasa Utama ──────────────────────────────────────
  void _editPrimaryLanguage() {
    HapticService.lightImpact();
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final totalCount = allLanguages.where((l) => l.code != 'auto').length;
          // Filter bahasa
          final filteredLanguages = allLanguages.where((l) {
            if (l.code == 'auto') return false;
            if (searchQuery.isEmpty) return true;
            final q = searchQuery.toLowerCase();
            return l.name.toLowerCase().contains(q) || l.code.toLowerCase().contains(q);
          }).toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.78,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.96),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.public_rounded, color: Color(0xFF818CF8), size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Total Bahasa ($totalCount Bahasa)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white54),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                // Informative Banner: Free ~140+ Languages vs Full Cloud API Key
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.25)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFFA5B4FC), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Gratis: ~140+ Bahasa populer & daerah langsung aktif. Gunakan Cloud API Key di Pengaturan untuk dukungan 100% semua bahasa.',
                            style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Search Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (val) => setModalState(() => searchQuery = val),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cari bahasa (Indonesia, Inggris, dll)...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF818CF8)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Quick selection bar for Indonesia & Inggris
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickLangButton(
                          title: '🇮🇩 Indonesia',
                          code: 'id',
                          name: 'Indonesia',
                          isSelected: _primaryLangCode == 'id',
                          onSelect: (name, code) async {
                            HapticService.selectionClick();
                            await UserProfileService.setPrimaryLanguage(name, code: code);
                            if (ctx.mounted) Navigator.pop(ctx);
                            _loadProfile();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickLangButton(
                          title: '🇬🇧 English',
                          code: 'en',
                          name: 'Inggris (US/UK)',
                          isSelected: _primaryLangCode == 'en',
                          onSelect: (name, code) async {
                            HapticService.selectionClick();
                            await UserProfileService.setPrimaryLanguage(name, code: code);
                            if (ctx.mounted) Navigator.pop(ctx);
                            _loadProfile();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 20),
                // Language List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredLanguages.length,
                    itemBuilder: (ctx, i) {
                      final lang = filteredLanguages[i];
                      final isSelected = lang.name == _primaryLanguage || lang.code == _primaryLangCode;
                      return ListTile(
                        leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                        title: Text(
                          lang.name,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFA5B4FC) : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '${lang.region} • [${lang.code}]',
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22)
                            : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        onTap: () async {
                          HapticService.selectionClick();
                          await UserProfileService.setPrimaryLanguage(lang.name, code: lang.code);
                          if (ctx.mounted) Navigator.pop(ctx);
                          _loadProfile();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🌐 Bahasa utama diubah ke "${lang.name}"'),
                                backgroundColor: const Color(0xFF6366F1),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickLangButton({
    required String title,
    required String code,
    required String name,
    required bool isSelected,
    required Function(String name, String code) onSelect,
  }) {
    return InkWell(
      onTap: () => onSelect(name, code),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF818CF8) : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── Info Fitur PRO Modal ───────────────────────────────────
  void _showProDetails() {
    HapticService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.amber, width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 26),
              SizedBox(width: 10),
              Text('Penjelasan fitur ini', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProFeatureRow(Icons.all_inclusive_rounded, 'Mode Gratis Bawaan: ~140+ Bahasa populer & daerah tanpa batas'),
              _buildProFeatureRow(Icons.vpn_key_rounded, 'Harus masukin Mode Cloud API (Opsional): Dukungan 100% semua bahasa dunia (DeepL & OpenAI GPT)'),
              _buildProFeatureRow(Icons.speed_rounded, 'Akselerasi Terjemahan Multi-Endpoint Direct API'),
              _buildProFeatureRow(Icons.mic_rounded, 'Speech-to-Text & Text-to-Speech Suara Asli'),
              _buildProFeatureRow(Icons.block_rounded, 'Bebas Iklan & Tanpa Batas Kuota Harian'),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF10B981), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  // ── Reset Counter Terjemahan ───────────────────────────────
  void _confirmResetCounter() {
    HapticService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Reset Hitungan Terjemahan?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            'Hitungan riwayat terjemahan akan dikembalikan menjadi 0.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                HapticService.mediumImpact();
                await UserProfileService.resetTranslationCount();
                if (ctx.mounted) Navigator.pop(ctx);
                _loadProfile();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reset Seluruh Profil ───────────────────────────────────
  void _confirmResetProfile() {
    HapticService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.redAccent, width: 1.2),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
              SizedBox(width: 8),
              Text('Reset Data Profil?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Nama dan preferensi profil akan dikembalikan ke setelan awal. Tanggal awal bergabung tetap tersimpan.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                HapticService.heavyImpact();
                await UserProfileService.resetProfile();
                if (ctx.mounted) Navigator.pop(ctx);
                _loadProfile();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profil telah di-reset ke setelan awal.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              child: const Text('Ya, Reset Profil'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : const Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
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
          // Content
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Column(
                      children: [
                        // Avatar & Name Card
                        AnimatedBorderContainer(
                          borderRadius: 28,
                          borderWidth: 1.5,
                          duration: const Duration(seconds: 5),
                          colors: const [Color(0xFF818CF8), Color(0xFFEC4899), Color(0xFF818CF8)],
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF6366F1).withValues(alpha: 0.25),
                                  const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                                    ),
                                    border: Border.all(color: Colors.white24, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      _displayName.isNotEmpty ? _displayName[0].toUpperCase() : 'P',
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                // Name + Edit Icon
                                InkWell(
                                  onTap: _editDisplayName,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _displayName,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.edit_rounded,
                                          color: Colors.white.withValues(alpha: 0.7),
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // PRO Badge
                                InkWell(
                                  onTap: _showProDetails,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber.withValues(alpha: 0.35),
                                          Colors.orange.withValues(alpha: 0.25),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.amber.withValues(alpha: 0.6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 18),
                                        const SizedBox(width: 6),
                                        Text(
                                          _isPro ? 'PENGGUNA PRO AKTIF' : 'PENGGUNA STANDAR',
                                          style: const TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 14),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticService.lightImpact();
                                  HistoryBottomSheet.show(context);
                                },
                                onLongPress: _confirmResetCounter,
                                borderRadius: BorderRadius.circular(20),
                                child: _buildStatCard(
                                  icon: Icons.history_rounded,
                                  label: 'Terjemahan History',
                                  value: _translationCount.toString(),
                                  color: const Color(0xFF6366F1),
                                  subLabel: 'Tap lihat riwayat',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.public_rounded,
                                label: 'Total Bahasa kepakai',
                                value: '${allLanguages.where((l) => l.code != 'auto').length}',
                                color: const Color(0xFF10B981),
                                subLabel: 'Global & Daerah',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Profile Details Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'INFORMASI AKUN & FITUR',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: const Color(0xFFA5B4FC).withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        _buildInfoTile(
                          icon: Icons.language_rounded,
                          title: 'Total Bahasa Tersedia',
                          value: '${allLanguages.where((l) => l.code != 'auto').length} Bahasa',
                          subtitle: 'Preferensi saat ini: $_primaryLanguage (Tap lihat daftar)',
                          onTap: _editPrimaryLanguage,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoTile(
                          icon: Icons.calendar_today_rounded,
                          title: 'Bergabung Sejak',
                          value: _formatDate(_createdAt),
                          subtitle: 'Waktu pertama kali aplikasi diinstal / digunakan',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoTile(
                          icon: Icons.verified_user_rounded,
                          title: 'Status Lisensi',
                          value: 'telah aktif (Lifetime Access)',
                          valueColor: const Color(0xFF10B981),
                          subtitle: 'Semua fitur premium & 200+ bahasa terbuka',
                          onTap: _showProDetails,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoTile(
                          icon: Icons.key_rounded,
                          title: 'Mesin & API Key Cloud',
                          value: 'Kelola di Pengaturan',
                          subtitle: 'Opsional: DeepL, OpenAI, Google Cloud API',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SettingsScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildInfoTile(
                          icon: Icons.restore_rounded,
                          title: 'Reset Data Profil',
                          value: 'Kembalikan Pengaturan Awal',
                          valueColor: Colors.redAccent.shade100,
                          subtitle: 'Reset nama dan hitungan riwayat terjemahan',
                          onTap: _confirmResetProfile,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return 'Hari Ini';
    try {
      final parts = isoDate.split('-');
      if (parts.length >= 3) {
        const months = [
          '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        final day = int.tryParse(parts[2]) ?? 1;
        final monthIdx = int.tryParse(parts[1]) ?? 1;
        final year = parts[0];
        return '$day ${months[monthIdx]} $year';
      }
      return isoDate;
    } catch (_) {
      return isoDate;
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    String? subLabel,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  subLabel,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFFA5B4FC), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: TextStyle(
                            color: valueColor ?? Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onTap != null)
                    const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
