import '../models/app_settings.dart';
import 'database_helper.dart';

class SettingsService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<AppSettings> getSettings() async {
    return await _databaseHelper.getAppSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _databaseHelper.updateAppSettings(settings);
  }

  Future<void> markOnboardingComplete() async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(isFirstLaunch: false);
    await updateSettings(updatedSettings);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(
      notificationsEnabled: enabled,
    );
    await updateSettings(updatedSettings);
  }

  Future<void> setTheme(String theme) async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(theme: theme);
    await updateSettings(updatedSettings);
  }

  Future<void> setLocale(String locale) async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(locale: locale);
    await updateSettings(updatedSettings);
  }

  Future<void> updateLastOpenDate() async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(
      lastOpenDate: DateTime.now(),
    );
    await updateSettings(updatedSettings);
  }
}
