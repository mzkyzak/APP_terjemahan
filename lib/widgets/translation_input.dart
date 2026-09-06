import 'package:flutter/material.dart';
import 'animated_border.dart';

class TranslationInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback onPaste;
  final VoidCallback onClear;
  final VoidCallback onListen;
  final bool isLoading;
  final bool isListening;

  const TranslationInput({
    super.key,
    required this.controller,
    this.onChanged,
    required this.onPaste,
    required this.onClear,
    required this.onListen,
    required this.isLoading,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBorderContainer(
      borderRadius: 28,
      borderWidth: 2.0,
      colors: isListening
          ? const [Color(0xFFEF4444), Color(0xFFDC2626), Color(0xFFF87171)]
          : const [Color(0xFF2563EB), Color(0xFFEF4444), Color(0xFF38BDF8)],
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          children: [
            if (isListening)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.graphic_eq_rounded, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mendengarkan... Silakan bicara!',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
                  TextField(
                    controller: controller,
                    onChanged: onChanged,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    cursorColor: const Color(0xFF818CF8),
                    decoration: InputDecoration(
                      hintText: isListening
                          ? 'Berbicaralah sekarang, teks akan terdeteksi otomatis...'
                          : 'Ketik atau tempel teks untuk diterjemahkan...',
                      hintStyle: TextStyle(
                        color: isListening
                            ? Colors.redAccent.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.35),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Tombol Mikrofon Suara
                      IconButton(
                        onPressed: onListen,
                        constraints: const BoxConstraints(minWidth: 46, minHeight: 46),
                        padding: const EdgeInsets.all(10),
                        icon: Icon(
                          isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                          size: 22,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: isListening
                              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                              : const Color(0xFF6366F1).withValues(alpha: 0.18),
                          foregroundColor: isListening ? const Color(0xFFEF4444) : const Color(0xFFA5B4FC),
                          side: BorderSide(
                            color: isListening ? const Color(0xFFEF4444) : const Color(0xFF6366F1).withValues(alpha: 0.4),
                            width: isListening ? 1.8 : 1.0,
                          ),
                        ),
                        tooltip: isListening ? 'Berhenti Mendengarkan' : 'Bicara (Suara ke Teks)',
                      ),
                      const SizedBox(width: 6),
                      // Tombol Tempel Teks
                      IconButton(
                        onPressed: onPaste,
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        padding: const EdgeInsets.all(8),
                        icon: const Icon(Icons.content_paste_rounded, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.15),
                          foregroundColor: const Color(0xFFA5B4FC),
                        ),
                        tooltip: 'Tempel Teks',
                      ),
                      if (controller.text.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: onClear,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          padding: const EdgeInsets.all(8),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                            foregroundColor: const Color(0xFFFCA5A5),
                          ),
                          tooltip: 'Hapus Teks',
                        ),
                      ],
                      const Spacer(),
                      // Badge Indikator Status Terjemahan Otomatis (Fleksibel agar tidak overflow)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isLoading
                                ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isLoading
                                  ? const Color(0xFF818CF8).withValues(alpha: 0.3)
                                  : Colors.white12,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLoading) ...[
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFA5B4FC),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Flexible(
                                  child: Text(
                                    'Menerjemahkan...',
                                    style: TextStyle(
                                      color: Color(0xFFA5B4FC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ] else ...[
                                const Icon(
                                  Icons.bolt_rounded,
                                  size: 15,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 4),
                                const Flexible(
                                  child: Text(
                                    'Otomatis',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}



