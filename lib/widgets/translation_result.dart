import 'package:flutter/material.dart';
import 'animated_border.dart';

class TranslationResult extends StatelessWidget {
  final String text;
  final String languageName;
  final String languageFlag;
  final VoidCallback onCopy;
  final VoidCallback onSpeak;
  final bool isSpeaking;

  const TranslationResult({
    super.key,
    required this.text,
    required this.languageName,
    required this.languageFlag,
    required this.onCopy,
    required this.onSpeak,
    required this.isSpeaking,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    final isError = text.contains("Terjadi kesalahan");

    return AnimatedBorderContainer(
      borderRadius: 28,
      borderWidth: 2.0,
      colors: isError
          ? const [Color(0xFFEF4444), Color(0xFFDC2626), Color(0xFFF87171)]
          : const [Color(0xFF2563EB), Color(0xFFEF4444), Color(0xFF38BDF8)],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isError
                ? [
                    const Color(0xFF7F1D1D),
                    const Color(0xFF991B1B),
                  ]
                : [
                    const Color(0xFF1E293B),
                    const Color(0xFF0F172A),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(languageFlag, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  languageName.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: isError ? const Color(0xFFFCA5A5) : const Color(0xFFC7D2FE),
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Spacer(),
                      if (!isError) ...[
                        // Tombol Suara (Text to Speech)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onSpeak,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSpeaking
                                    ? const Color(0xFF818CF8).withValues(alpha: 0.35)
                                    : Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSpeaking
                                      ? const Color(0xFF818CF8)
                                      : Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Icon(
                                isSpeaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                                size: 18,
                                color: isSpeaking ? const Color(0xFFA5B4FC) : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Salin
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onCopy,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: const Icon(
                                Icons.copy_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 18),
                  SelectableText(
                    text,
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: isError ? const Color(0xFFFECACA) : Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


