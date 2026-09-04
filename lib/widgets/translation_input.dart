import 'dart:ui';
import 'package:flutter/material.dart';

class TranslationInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPaste;
  final VoidCallback onClear;
  final VoidCallback onTranslate;
  final bool isLoading;

  const TranslationInput({
    super.key,
    required this.controller,
    required this.onPaste,
    required this.onClear,
    required this.onTranslate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 2,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            ),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  maxLines: 5,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1B4B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tulis sesuatu untuk diterjemahkan...',
                    hintStyle: TextStyle(color: Colors.indigo.shade200),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: onPaste,
                      icon: const Icon(Icons.content_paste_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.indigo.shade50.withOpacity(0.5),
                        foregroundColor: const Color(0xFF6366F1),
                      ),
                      tooltip: 'Tempel',
                    ),
                    const SizedBox(width: 8),
                    if (controller.text.isNotEmpty)
                      IconButton(
                        onPressed: onClear,
                        icon: const Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.shade50.withOpacity(0.5),
                          foregroundColor: Colors.redAccent,
                        ),
                        tooltip: 'Hapus',
                      ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : onTranslate,
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.auto_fix_high_rounded, size: 20),
                        label: Text(
                          isLoading ? 'Memproses' : 'Terjemahkan',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
