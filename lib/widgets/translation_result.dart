import 'dart:ui';
import 'package:flutter/material.dart';

class TranslationResult extends StatelessWidget {
  final String text;
  final String languageName;
  final String languageFlag;
  final VoidCallback onCopy;

  const TranslationResult({
    super.key,
    required this.text,
    required this.languageName,
    required this.languageFlag,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    final isError = text.contains("Terjadi kesalahan");

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isError
                ? Colors.red.withOpacity(0.15)
                : const Color(0xFF6366F1).withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isError
                    ? [
                        Colors.red.shade50.withOpacity(0.7),
                        Colors.red.shade100.withOpacity(0.5),
                      ]
                    : [
                        const Color(0xFFF5F3FF).withOpacity(0.8),
                        const Color(0xFFEDE9FE).withOpacity(0.6),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isError
                    ? Colors.red.shade200.withOpacity(0.5)
                    : const Color(0xFFDDD6FE).withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(languageFlag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(
                            languageName,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isError ? Colors.red.shade700 : const Color(0xFF5B21B6),
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!isError)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onCopy,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.copy_all_rounded,
                              size: 20,
                              color: Color(0xFF5B21B6),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                SelectableText(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    color: isError ? Colors.red.shade900 : const Color(0xFF1E1B4B),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
