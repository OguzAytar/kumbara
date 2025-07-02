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

  @override
  String get appName => 'Kumbara';

  @override
  String get retry => 'Try Again';

  @override
  String get newSavingComingSoon => 'Add new saving feature coming soon!';

  @override
  String get welcomeMessage => 'Welcome! 👋';

  @override
  String get welcomeSubtitle => 'Get one step closer to your dreams';

  @override
  String get nearestTarget => 'Nearest Target';

  @override
  String get mostProgress => 'Most Progress';

  @override
  String get mySavings => 'My Savings';

  @override
  String get seeAll => 'See All';

  @override
  String get allSavingsComingSoon => 'All savings page coming soon!';

  @override
  String get targetNotFound => 'Target not found';

  @override
  String get expired => 'Expired';

  @override
  String get oneDayLeft => '1 day left';

  @override
  String daysLeft(int days) {
    return '$days days left';
  }

  @override
  String get savingNotFound => 'Saving not found';

  @override
  String get summaryStatistics => 'Summary Statistics';

  @override
  String get totalSaving => 'Total Saving';

  @override
  String get activeTarget => 'Active Target';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get noSavingsGoal => 'No savings goal yet';

  @override
  String get createFirstGoal =>
      'Click the + button to create your first savings goal';

  @override
  String detailPageComingSoon(String title) {
    return '$title detail page coming soon!';
  }

  @override
  String get trackYourSavings => 'Track Your Savings';

  @override
  String get trackYourSavingsDesc =>
      'Easily track and manage your savings to reach your goals.';

  @override
  String get seeYourProgress => 'See Your Progress';

  @override
  String get seeYourProgressDesc =>
      'Analyze your savings progress in detail with charts and reports.';

  @override
  String get getReminders => 'Get Reminders';

  @override
  String get getRemindersDesc =>
      'Use notifications to remember to save regularly.';

  @override
  String get back => 'Back';

  @override
  String get continueButton => 'Continue';

  @override
  String get allowNotifications => 'Allow Notifications';

  @override
  String get continueWithoutNotifications => 'Continue Without Notifications';

  @override
  String get notificationPermissionGranted =>
      'Notification permission granted! You can now receive reminders.';

  @override
  String get notificationPermissionDenied =>
      'Notification permission denied. You can enable it in settings.';

  @override
  String notificationPermissionError(String error) {
    return 'Error occurred while requesting notification permission: $error';
  }
}
