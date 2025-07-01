import 'package:flutter/material.dart';
import '../../models/app_settings.dart';
import '../../services/settings_service.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  
  AppSettings? _settings;
  bool _isLoading = false;

  AppSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isFirstLaunch => _settings?.isFirstLaunch ?? true;
  bool get notificationsEnabled => _settings?.notificationsEnabled ?? false;
  String get theme => _settings?.theme ?? 'light';
  String get locale => _settings?.locale ?? 'tr';

  Future<void> loadSettings() async {
    // Build process sırasında notifyListeners çağırmamak için flag kullan
    final bool shouldNotify = !_isLoading;
    
    _isLoading = true;
    if (shouldNotify && mounted) {
      // Build tamamlandıktan sonra notify et
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) notifyListeners();
      });
    }

    try {
      _settings = await _settingsService.getSettings();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }

    _isLoading = false;
    if (mounted) {
      // Build tamamlandıktan sonra notify et
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) notifyListeners();
      });
    }
  }

  // mounted kontrolü için getter ekleyelim
  bool _mounted = true;
  bool get mounted => _mounted;
  
  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> markOnboardingComplete() async {
    await _settingsService.markOnboardingComplete();
    await loadSettings();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _settingsService.setNotificationsEnabled(enabled);
    await loadSettings();
  }

  Future<void> setTheme(String theme) async {
    await _settingsService.setTheme(theme);
    await loadSettings();
  }

  Future<void> setLocale(String locale) async {
    await _settingsService.setLocale(locale);
    await loadSettings();
  }

  Future<void> updateLastOpenDate() async {
    await _settingsService.updateLastOpenDate();
    // Not notifying listeners here as this doesn't affect UI
  }
}
