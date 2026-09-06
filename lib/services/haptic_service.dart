// Service getaran haptic
import 'package:flutter/services.dart';
import 'settings_service.dart';

class HapticService {
  HapticService._();

  /// Light tap — untuk toggle switch, checkbox
  static Future<void> lightImpact() async {
    final enabled = await SettingsService.getHapticEnabled();
    if (enabled) HapticFeedback.lightImpact();
  }

  /// Medium impact — untuk tombol aksi utama (mic, translate)
  static Future<void> mediumImpact() async {
    final enabled = await SettingsService.getHapticEnabled();
    if (enabled) HapticFeedback.mediumImpact();
  }

  /// Heavy impact — untuk aksi penting (swap, delete)
  static Future<void> heavyImpact() async {
    final enabled = await SettingsService.getHapticEnabled();
    if (enabled) HapticFeedback.heavyImpact();
  }

  /// Selection click — untuk item list, tab
  static Future<void> selectionClick() async {
    final enabled = await SettingsService.getHapticEnabled();
    if (enabled) HapticFeedback.selectionClick();
  }

  /// Vibrate — fallback general vibrate
  static Future<void> vibrate() async {
    final enabled = await SettingsService.getHapticEnabled();
    if (enabled) HapticFeedback.vibrate();
  }
}
