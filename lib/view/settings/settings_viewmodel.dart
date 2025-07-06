import "package:flutter/material.dart";
import "package:kumbara/l10n/app_localizations.dart";

import "../../core/functions/firebase_analytics_helper.dart";
import "../../core/providers/settings_provider.dart";
import "../../core/widgets/custom_snackbar.dart";

class SettingsViewModel extends ChangeNotifier {
  final SettingsProvider _settingsProvider;

  SettingsViewModel({required SettingsProvider settingsProvider}) : _settingsProvider = settingsProvider {
    // SettingsProvider'daki değişiklikleri dinle
    _settingsProvider.addListener(_onSettingsChanged);
  }

  bool _isLoading = false;

  // Getters - SettingsProvider'dan veri al
  bool get notificationsEnabled => _settingsProvider.notificationsEnabled;
  bool get isDarkTheme => _settingsProvider.theme == "dark";
  String get selectedLanguage => _settingsProvider.locale;
  bool get isLoading => _isLoading || _settingsProvider.isLoading;

  String get selectedLanguageText {
    switch (selectedLanguage) {
      case "tr":
        return "Türkçe";
      case "en":
        return "English";
      default:
        return "Türkçe";
    }
  }

  String themeText(BuildContext context) {
    return isDarkTheme ? AppLocalizations.of(context)!.darkTheme : AppLocalizations.of(context)!.lightTheme;
  }

  /// SettingsProvider değişikliklerini dinle
  void _onSettingsChanged() {
    notifyListeners();
  }

  /// Initialize settings
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _settingsProvider.loadSettings();
    } catch (e) {
      debugPrint("Settings initialization error: \$e");
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool value) async {
    _setLoading(true);
    try {
      await _settingsProvider.setNotificationsEnabled(value);
    } catch (e) {
      debugPrint("Error toggling notifications: \$e");
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    _setLoading(true);
    try {
      final newTheme = isDarkTheme ? "light" : "dark";
      await _settingsProvider.setTheme(newTheme);
    } catch (e) {
      debugPrint("Error toggling theme: \$e");
    } finally {
      _setLoading(false);
    }
  }

  /// Change language
  Future<void> changeLanguage(String languageCode) async {
    if (selectedLanguage == languageCode) return;

    _setLoading(true);
    try {
      await _settingsProvider.setLocale(languageCode);
    } catch (e) {
      debugPrint("Error changing language: \$e");
    } finally {
      _setLoading(false);
    }
  }

  /// Show theme selector
  void showThemeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tema Seçin", style: Theme.of(context).textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Açık Tema", style: Theme.of(context).textTheme.bodyMedium),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: isDarkTheme,
                    onChanged: (value) {
                      Navigator.of(context).pop();
                      if (value != null && value != isDarkTheme) {
                        toggleTheme();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (!isDarkTheme) return;
                    toggleTheme();
                  },
                ),
                ListTile(
                  title: Text("Karanlık Tema", style: Theme.of(context).textTheme.bodyMedium),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: isDarkTheme,
                    onChanged: (value) {
                      Navigator.of(context).pop();
                      if (value != null && value != isDarkTheme) {
                        toggleTheme();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (isDarkTheme) return;
                    toggleTheme();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text("İptal", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  /// Show language selector
  void showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dil Seçin", style: Theme.of(context).textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Türkçe", style: Theme.of(context).textTheme.bodyMedium),
                  leading: Radio<String>(
                    value: "tr",
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      Navigator.of(context).pop();
                      if (value != null && value != selectedLanguage) {
                        changeLanguage(value);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (selectedLanguage == "tr") return;
                    changeLanguage("tr");
                  },
                ),
                ListTile(
                  title: Text("English", style: Theme.of(context).textTheme.bodyMedium),
                  leading: Radio<String>(
                    value: "en",
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      Navigator.of(context).pop();
                      if (value != null && value != selectedLanguage) {
                        changeLanguage(value);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (selectedLanguage == "en") return;
                    changeLanguage("en");
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text("İptal", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  /// Backup data
  Future<void> backupData(BuildContext context) async {
    _setLoading(true);
    try {
      // TODO: Implement backup functionality
      await Future.delayed(const Duration(seconds: 1)); // Simulate backup

      // Log successful backup
      await FirebaseAnalyticsHelper.logDataBackup(
        success: true,
        itemCount: 0, // Will be actual count when implemented
      );

      CustomSnackBar.showSuccess(context, message: "Veriler başarıyla yedeklendi!");
    } catch (e) {
      // Log failed backup
      await FirebaseAnalyticsHelper.logDataBackup(success: false, errorMessage: e.toString());

      CustomSnackBar.showError(context, message: "Yedekleme sırasında hata oluştu: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Restore data
  Future<void> restoreData(BuildContext context) async {
    _setLoading(true);
    try {
      // TODO: Implement restore functionality
      await Future.delayed(const Duration(seconds: 1)); // Simulate restore

      // Log successful restore
      await FirebaseAnalyticsHelper.logDataRestore(
        success: true,
        itemCount: 0, // Will be actual count when implemented
      );

      CustomSnackBar.showSuccess(context, message: "Veriler başarıyla geri yüklendi!");
    } catch (e) {
      // Log failed restore
      await FirebaseAnalyticsHelper.logDataRestore(success: false, errorMessage: e.toString());

      CustomSnackBar.showError(context, message: "Geri yükleme sırasında hata oluştu: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Delete all data
  Future<void> deleteAllData(BuildContext context) async {
    _setLoading(true);
    try {
      // TODO: Implement delete all data functionality
      await Future.delayed(const Duration(seconds: 1)); // Simulate deletion

      // Log successful deletion
      await FirebaseAnalyticsHelper.logDataDeletion(
        success: true,
        itemCount: 0, // Will be actual count when implemented
      );

      CustomSnackBar.showSuccess(context, message: "Tüm veriler başarıyla silindi!");
    } catch (e) {
      // Log failed deletion
      await FirebaseAnalyticsHelper.logDataDeletion(success: false, errorMessage: e.toString());

      CustomSnackBar.showError(context, message: "Veri silme sırasında hata oluştu: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Show help screen
  void showHelpScreen(BuildContext context) {
    CustomSnackBar.showInfo(context, message: "Yardım sayfası yakında eklenecek!");
  }

  /// Show delete confirmation dialog
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tüm Verileri Sil", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),
          content: SingleChildScrollView(
            child: Text(
              "Bu işlem tüm birikimlerinizi ve ayarlarınızı silecektir. Bu işlem geri alınamaz. Devam etmek istediğinizden emin misiniz?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text("İptal", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllData(context);
              },
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge, foregroundColor: Colors.red),
              child: const Text("Sil", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _settingsProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
