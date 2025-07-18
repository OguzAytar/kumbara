import "package:flutter/material.dart";
import "package:kumbara/l10n/app_localizations.dart";

import "../../core/constants/currency_constants.dart";
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
  String get selectedCurrency => _settingsProvider.currency;
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

  String get selectedCurrencyText {
    final currency = CurrencyConstants.getCurrencyByCode(selectedCurrency);
    return "${currency.flag} ${currency.name} (${currency.symbol})";
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

  /// Change currency
  Future<void> changeCurrency(String currencyCode) async {
    if (selectedCurrency == currencyCode) return;

    _setLoading(true);
    try {
      await _settingsProvider.setCurrency(currencyCode);
    } catch (e) {
      debugPrint("Error changing currency: $e");
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
          title: Text(AppLocalizations.of(context)!.selectTheme, style: Theme.of(context).textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.lightTheme, style: Theme.of(context).textTheme.bodyMedium),
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
                  title: Text(AppLocalizations.of(context)!.darkTheme, style: Theme.of(context).textTheme.bodyMedium),
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
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
          title: Text(AppLocalizations.of(context)!.selectLanguage, style: Theme.of(context).textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.turkish, style: Theme.of(context).textTheme.bodyMedium),
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
                  title: Text(AppLocalizations.of(context)!.english, style: Theme.of(context).textTheme.bodyMedium),
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
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  /// Show currency selector
  void showCurrencySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Para Birimi Seçin", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              // Currency list
              Expanded(
                child: ListView.builder(
                  itemCount: CurrencyConstants.currencies.length,
                  itemBuilder: (context, index) {
                    final currency = CurrencyConstants.currencies[index];
                    final isSelected = selectedCurrency == currency.code;

                    return ListTile(
                      leading: Text(currency.flag, style: const TextStyle(fontSize: 24)),
                      title: Text(
                        currency.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                      ),
                      subtitle: Text(
                        "${currency.code} - ${currency.symbol}",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) : null,
                      onTap: () {
                        Navigator.of(context).pop();
                        if (currency.code != selectedCurrency) {
                          changeCurrency(currency.code);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
