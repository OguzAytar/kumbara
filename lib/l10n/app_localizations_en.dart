// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kumbara - Savings Tracker';

  @override
  String get welcome => 'Welcome';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Set Your Goals';

  @override
  String get onboardingDesc1 => 'Easily create and track your savings goals';

  @override
  String get onboardingTitle2 => 'Save Money';

  @override
  String get onboardingDesc2 => 'Regularly deposit money and reach your goals';

  @override
  String get onboardingTitle3 => 'Track Your Progress';

  @override
  String get onboardingDesc3 =>
      'Visualize your progress with charts and reports';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get home => 'Home';

  @override
  String get totalSavings => 'Total Savings';

  @override
  String get activeGoals => 'Active Goals';

  @override
  String get completedGoals => 'Completed Goals';

  @override
  String get recentSavings => 'Recent Savings';

  @override
  String get addSaving => 'Add Saving';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSubtitle => 'Reminder notifications';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get language => 'Language';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get data => 'Data';

  @override
  String get backupData => 'Backup Data';

  @override
  String get backupSubtitle => 'Backup your savings';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get restoreSubtitle => 'Restore from backup';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get deleteDataSubtitle => 'Warning: This action cannot be undone';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSubtitle => 'FAQ and contact';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAllDataTitle => 'Delete All Data';

  @override
  String get deleteAllDataMessage =>
      'This action will delete all your savings and settings. This action cannot be undone. Are you sure you want to continue?';

  @override
  String get dataBackedUpSuccessfully => 'Data backed up successfully!';

  @override
  String get dataRestoredSuccessfully => 'Data restored successfully!';

  @override
  String get dataDeletedSuccessfully => 'All data deleted successfully!';

  @override
  String backupError(String error) {
    return 'Error during backup: $error';
  }

  @override
  String restoreError(String error) {
    return 'Error during restore: $error';
  }

  @override
  String deleteError(String error) {
    return 'Error during data deletion: $error';
  }

  @override
  String get helpComingSoon => 'Help page coming soon!';
}
