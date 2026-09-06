import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/language.dart';
import '../services/language_service.dart';
import 'animated_border.dart';

class LanguageSelector extends StatelessWidget {
  final String label;
  final Language selectedLanguage;
  final List<Language> languages;
  final Function(Language) onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.label,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageSelected,
  });

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LanguageBottomSheet(
          label: label,
          selectedLanguage: selectedLanguage,
          languages: languages,
          onLanguageSelected: onLanguageSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBorderContainer(
      borderRadius: 22,
      borderWidth: 1.2,
      colors: const [
        Color(0xFF6366F1),
        Color(0xFF818CF8),
        Color(0xFF6366F1),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLanguagePicker(context),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(22),
                  // Border handled by AnimatedBorderContainer
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF818CF8).withValues(alpha: 0.25)),
                      ),
                      child: Text(selectedLanguage.flag,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFA5B4FC),
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedLanguage.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white70, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class LanguageBottomSheet extends StatefulWidget {
  final String label;
  final Language selectedLanguage;
  final List<Language> languages;
  final Function(Language) onLanguageSelected;

  const LanguageBottomSheet({
    super.key,
    required this.label,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String _activeRegion = 'Semua';
  String _searchQuery = '';

  static final List<String> _tabRegions = [
    'Semua',
    ...languageRegions.where((r) => r != 'Semua'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabRegions.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _activeRegion = _tabRegions[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Language> get _filteredList {
    if (_searchQuery.isNotEmpty) {
      return LanguageService.search(_searchQuery);
    }
    if (_activeRegion == 'Semua') return widget.languages;
    return widget.languages.where((l) => l.region == _activeRegion).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        children: [
          // ── Handle ─────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 14),

          // ── Judul ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.language_rounded,
                    color: Color(0xFF818CF8)),
                const SizedBox(width: 10),
                Text(
                  'Pilih Bahasa ${widget.label}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // ── Info Banner Mode Gratis vs Cloud API ───────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
                      'Gratis ~140+ Bahasa populer & daerah • Dukungan 100% semua bahasa dengan Cloud API Key di Pengaturan.',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Search Bar ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari bahasa, kode, atau wilayah...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: Colors.white54),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(Icons.clear, color: Colors.white38, size: 18),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1E293B),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Tab Region (tersembunyi saat ada pencarian) ────
          if (_searchQuery.isEmpty)
            SizedBox(
              height: 38,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFF6366F1),
                labelColor: const Color(0xFFA5B4FC),
                unselectedLabelColor: Colors.white38,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                tabs: _tabRegions
                    .map((r) => Tab(text: r))
                    .toList(),
              ),
            ),

          if (_searchQuery.isEmpty) const SizedBox(height: 6),

          // ── Jumlah hasil ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filteredList.length} bahasa',
                  style: const TextStyle(
                      color: Colors.white30, fontSize: 11),
                ),
                if (_searchQuery.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  const Text('(pencarian global)',
                      style: TextStyle(
                          color: Color(0xFF818CF8), fontSize: 11)),
                ],
              ],
            ),
          ),

          // ── Daftar Bahasa ──────────────────────────────────
          Expanded(
            child: _filteredList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, color: Colors.white24, size: 48),
                        SizedBox(height: 12),
                        Text('Bahasa tidak ditemukan',
                            style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) {
                      final lang = _filteredList[index];
                      final isSelected =
                          lang.code == widget.selectedLanguage.code;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              widget.onLanguageSelected(lang);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6366F1)
                                        .withValues(alpha: 0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF6366F1)
                                            .withValues(alpha: 0.4),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // Bendera
                                  Text(lang.flag,
                                      style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 12),

                                  // Nama + region
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang.name,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? const Color(0xFFA5B4FC)
                                                : Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '${lang.region} · ${lang.code}',
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Indicator centang jika terpilih
                                  if (isSelected)
                                    const Icon(Icons.check_circle_rounded,
                                        color: Color(0xFF818CF8), size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
