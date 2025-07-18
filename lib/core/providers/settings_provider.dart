import 'package:flutter/material.dart';

import '../../models/app_settings.dart';
import '../../services/settings_service.dart';
import '../functions/firebase_analytics_helper.dart';

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
  bool get isPremium => _settings?.isPremium ?? false;
  String get currency => _settings?.currency ?? 'TRY';

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

    // Log onboarding completion
    await FirebaseAnalyticsHelper.logOnboardingCompleted(
      totalSteps: 3,
      completedSteps: 3,
      durationSeconds: 0, // Bu bilgi onboarding ekranından gelecek
      notificationPermissionGranted: notificationsEnabled,
    );
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final oldValue = notificationsEnabled;
    await _settingsService.setNotificationsEnabled(enabled);
    await loadSettings();

    // Log settings change
    await FirebaseAnalyticsHelper.logSettingsChanged(settingName: 'notifications', oldValue: oldValue.toString(), newValue: enabled.toString());

    // Update user properties
    await FirebaseAnalyticsHelper.setUserProperties(notificationsEnabled: enabled);
  }

  Future<void> setTheme(String newTheme) async {
    final oldTheme = theme;
    await _settingsService.setTheme(newTheme);
    await loadSettings();

    // Log theme change
    await FirebaseAnalyticsHelper.logThemeChanged(oldTheme: oldTheme, newTheme: newTheme);

    // Update user properties
    await FirebaseAnalyticsHelper.setUserProperties(theme: newTheme);
  }

  Future<void> setLocale(String newLocale) async {
    final oldLocale = locale;
    await _settingsService.setLocale(newLocale);
    await loadSettings();

    // Log language change
    await FirebaseAnalyticsHelper.logLanguageChanged(oldLanguage: oldLocale, newLanguage: newLocale);

    // Update user properties
    await FirebaseAnalyticsHelper.setUserProperties(language: newLocale);
  }

  Future<void> updateLastOpenDate() async {
    await _settingsService.updateLastOpenDate();
    // Not notifying listeners here as this doesn't affect UI
  }

  Future<void> setPremiumStatus(bool isPremium) async {
    final oldValue = this.isPremium;
    await _settingsService.setPremiumStatus(isPremium);
    await loadSettings();

    // Log premium status change
    await FirebaseAnalyticsHelper.logSettingsChanged(settingName: 'premium_status', oldValue: oldValue.toString(), newValue: isPremium.toString());

    // Update user properties
    // await FirebaseAnalyticsHelper.setUserProperties(isPremium: isPremium);
  }

  Future<void> setCurrency(String newCurrency) async {
    final oldCurrency = currency;
    await _settingsService.setCurrency(newCurrency);
    await loadSettings();

    // Log currency change
    await FirebaseAnalyticsHelper.logSettingsChanged(settingName: 'currency', oldValue: oldCurrency, newValue: newCurrency);
  }
}
