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
  String get currency => 'Currency';

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

  @override
  String get notificationChannelName => 'Kumbara Notifications';

  @override
  String get notificationChannelDescription =>
      'Savings reminders and goal notifications';

  @override
  String get savingReminderTitle => 'Time to Save!';

  @override
  String get savingReminderBody =>
      'Don\'t forget to save money today to get one step closer to your goals';

  @override
  String get goalAchievedTitle => 'Congratulations! 🎉';

  @override
  String get goalAchievedBody =>
      'You\'ve reached your goal! You can set a new goal';

  @override
  String get goalNearlyAchievedTitle => 'You\'re Almost There!';

  @override
  String get goalNearlyAchievedBody =>
      'You\'ve reached 90% of your goal. Final sprint!';

  @override
  String get addNewSaving => 'Add New Saving';

  @override
  String get save => 'Save';

  @override
  String get savingName => 'Saving Name';

  @override
  String get savingNameHint => 'e.g. Holiday Fund, New Car';

  @override
  String get pleaseEnterSavingName => 'Please enter saving name';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Write your notes about this saving...';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get setTargetAmount => 'Set target amount';

  @override
  String get setTargetAmountDesc => 'Set the amount you want to reach';

  @override
  String get targetAmountHint => 'e.g. 5000';

  @override
  String get pleaseEnterTargetAmount => 'Please enter target amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get targetDate => 'Target Date';

  @override
  String get setTargetDate => 'Set target date';

  @override
  String get setTargetDateDesc => 'Set the date you want to reach your goal';

  @override
  String get selectTargetDate => 'Select target date';

  @override
  String get pleaseSelectTargetDate => 'Please select target date';

  @override
  String get savingInfo =>
      'If you don\'t set a target amount or date, your saving will work like a piggy bank and only track how much money you save.';

  @override
  String get savingAddedSuccessfully => 'Saving added successfully!';

  @override
  String get errorAddingSaving => 'Error occurred while adding saving';

  @override
  String get sortByNewest => 'Newest';

  @override
  String get sortByOldest => 'Oldest';

  @override
  String get sortByProgress => 'Progress';

  @override
  String get sortByAmount => 'Amount';

  @override
  String get allSavings => 'All Savings';

  @override
  String get activeSavings => 'Active Savings';

  @override
  String get completedSavings => 'Completed Savings';

  @override
  String get pausedSavings => 'Paused Savings';

  @override
  String get searchSavings => 'Search your savings...';

  @override
  String get savingDetailComingSoon => 'Saving detail coming soon';

  @override
  String get savingsOverview => 'Savings Overview';

  @override
  String totalSavingsCount(int count) {
    return '$count savings';
  }

  @override
  String get totalTarget => 'Total Target';

  @override
  String get totalAmountSaved => 'Total Amount Saved';

  @override
  String get averageProgress => 'Average Progress';

  @override
  String get noSavingsFound => 'No savings found';

  @override
  String get noSavingsFoundDesc =>
      'You haven\'t added any savings yet or there are no savings matching your search criteria.';

  @override
  String get completed => 'completed';

  @override
  String get editSaving => 'Edit Saving';

  @override
  String get savingDetails => 'Saving Details';

  @override
  String get initialAmount => 'Initial Amount';

  @override
  String get initialAmountHint => 'Enter initial amount';

  @override
  String get initialAmountDesc => 'Add initial amount to your saving';

  @override
  String get setInitialAmount => 'Set Initial Amount';

  @override
  String get update => 'Update';

  @override
  String get savingUpdatedSuccessfully => 'Saving updated successfully';

  @override
  String get errorUpdatingSaving => 'Error updating saving';

  @override
  String get currentAmount => 'Current Amount';

  @override
  String get addMoney => 'Add Money';

  @override
  String get addMoneyHint => 'Enter amount to add';

  @override
  String dailyTarget(String amount) {
    return 'Daily ₺$amount';
  }

  @override
  String get moneyAddedSuccessfully => 'Money added successfully';

  @override
  String get errorAddingMoney => 'Error adding money';

  @override
  String get premiumUpgrade => 'Upgrade to Premium';

  @override
  String get premiumDescription =>
      'Enjoy premium features for a better experience';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get removeAdsDesc =>
      'Get rid of all ads and enjoy uninterrupted experience';

  @override
  String get unlimitedSavings => 'Unlimited Savings';

  @override
  String get unlimitedSavingsDesc => 'Create as many savings goals as you want';

  @override
  String get advancedAnalytics => 'Advanced Analytics';

  @override
  String get advancedAnalyticsDesc => 'View detailed reports and statistics';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get autoBackupDesc => 'Your data is safely backed up';

  @override
  String get premiumPrice => '\$9.99';

  @override
  String get perMonth => '/month';

  @override
  String get freeTrial => '7 days free trial';

  @override
  String get later => 'Later';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get premiumComingSoon => 'Premium feature coming soon!';

  @override
  String get image => 'Image';

  @override
  String get addImage => 'Add Image';

  @override
  String get tapToSelectImage => 'Tap to select image';

  @override
  String get selectImage => 'Select Image';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get change => 'Change';
}
