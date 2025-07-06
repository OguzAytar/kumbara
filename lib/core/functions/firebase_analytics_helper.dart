import 'dart:developer' as dev;
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase Analytics Helper Class
/// Provides centralized analytics functionality for the app
class FirebaseAnalyticsHelper {
  static final FirebaseAnalyticsHelper _instance = FirebaseAnalyticsHelper._internal();
  factory FirebaseAnalyticsHelper() => _instance;
  FirebaseAnalyticsHelper._internal();

  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;

  /// Initialize Firebase Analytics
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);

      // Request App Tracking Transparency permission on iOS
      if (Platform.isIOS) {
        await _requestTrackingPermission();
      }

      // Enable analytics collection
      await _analytics!.setAnalyticsCollectionEnabled(true);

      // Log initialization
      dev.log('🔥 Firebase Analytics initialized successfully');

      // Track app installation/first launch
      await logAppOpen();
    } catch (e) {
      dev.log('❌ Firebase Analytics initialization failed: $e');
    }
  }

  /// Request tracking permission on iOS (ATT - App Tracking Transparency)
  static Future<void> _requestTrackingPermission() async {
    try {
      if (Platform.isIOS) {
        final status = await AppTrackingTransparency.trackingAuthorizationStatus;
        dev.log('📱 Current tracking status: $status');

        // Request permission if not determined
        if (status == TrackingStatus.notDetermined) {
          final result = await AppTrackingTransparency.requestTrackingAuthorization();
          dev.log('📱 Tracking permission result: $result');

          // Log the tracking permission result
          await logCustomEvent(eventName: 'tracking_permission_result', parameters: {'status': result.toString(), 'platform': 'ios'});
        }
      }
    } catch (e) {
      dev.log('❌ Error requesting tracking permission: $e');
    }
  }

  /// Get Firebase Analytics Observer for MaterialApp
  static FirebaseAnalyticsObserver? get observer => _observer;

  /// Get Firebase Analytics instance
  static FirebaseAnalytics? get analytics => _analytics;

  // ================================
  // GENERAL APP EVENTS
  // ================================

  /// Log app open event
  static Future<void> logAppOpen() async {
    try {
      await _analytics?.logAppOpen();
      dev.log('📱 App open logged');
    } catch (e) {
      dev.log('❌ Failed to log app open: $e');
    }
  }

  /// Log screen view
  static Future<void> logScreenView({required String screenName, String? screenClass, Map<String, Object>? parameters}) async {
    try {
      await _analytics?.logScreenView(screenName: screenName, screenClass: screenClass, parameters: parameters);
      dev.log('📺 Screen view logged: $screenName');
    } catch (e) {
      dev.log('❌ Failed to log screen view: $e');
    }
  }

  /// Set user properties
  static Future<void> setUserProperties({String? userId, String? language, String? theme, bool? notificationsEnabled}) async {
    try {
      if (userId != null) {
        await _analytics?.setUserId(id: userId);
      }

      if (language != null) {
        await _analytics?.setUserProperty(name: 'language', value: language);
      }

      if (theme != null) {
        await _analytics?.setUserProperty(name: 'theme', value: theme);
      }

      if (notificationsEnabled != null) {
        await _analytics?.setUserProperty(name: 'notifications_enabled', value: notificationsEnabled.toString());
      }

      dev.log('👤 User properties set successfully');
    } catch (e) {
      dev.log('❌ Failed to set user properties: $e');
    }
  }

  // ================================
  // SAVINGS RELATED EVENTS
  // ================================

  /// Log when user creates a new savings goal
  static Future<void> logSavingsGoalCreated({
    required String goalId,
    required double targetAmount,
    required String currency,
    int? durationDays,
    String? category,
  }) async {
    try {
      await _analytics?.logEvent(
        name: 'savings_goal_created',
        parameters: {
          'goal_id': goalId,
          'target_amount': targetAmount,
          'currency': currency,
          if (durationDays != null) 'duration_days': durationDays,
          if (category != null) 'category': category,
        },
      );
      dev.log('💰 Savings goal created logged: $goalId');
    } catch (e) {
      dev.log('❌ Failed to log savings goal created: $e');
    }
  }

  /// Log when user adds money to savings
  static Future<void> logSavingsAdded({required String goalId, required double amount, required String currency, String? method}) async {
    try {
      await _analytics?.logEvent(
        name: 'savings_added',
        parameters: {'goal_id': goalId, 'amount': amount, 'currency': currency, if (method != null) 'method': method},
      );
      dev.log('💸 Savings added logged: $amount $currency');
    } catch (e) {
      dev.log('❌ Failed to log savings added: $e');
    }
  }

  /// Log when user achieves a savings goal
  static Future<void> logSavingsGoalAchieved({
    required String goalId,
    required double finalAmount,
    required String currency,
    required int daysToComplete,
  }) async {
    try {
      await _analytics?.logEvent(
        name: 'savings_goal_achieved',
        parameters: {'goal_id': goalId, 'final_amount': finalAmount, 'currency': currency, 'days_to_complete': daysToComplete},
      );
      dev.log('🎉 Savings goal achieved logged: $goalId');
    } catch (e) {
      dev.log('❌ Failed to log savings goal achieved: $e');
    }
  }

  /// Log when user deletes a savings goal
  static Future<void> logSavingsGoalDeleted({
    required String goalId,
    required double currentAmount,
    required String currency,
    required String reason,
  }) async {
    try {
      await _analytics?.logEvent(
        name: 'savings_goal_deleted',
        parameters: {'goal_id': goalId, 'current_amount': currentAmount, 'currency': currency, 'reason': reason},
      );
      dev.log('🗑️ Savings goal deleted logged: $goalId');
    } catch (e) {
      dev.log('❌ Failed to log savings goal deleted: $e');
    }
  }

  // ================================
  // NOTIFICATION EVENTS
  // ================================

  /// Log notification permission request
  static Future<void> logNotificationPermissionRequested({required bool granted, String? source}) async {
    try {
      await _analytics?.logEvent(name: 'notification_permission_requested', parameters: {'granted': granted, if (source != null) 'source': source});
      dev.log('🔔 Notification permission logged: $granted');
    } catch (e) {
      dev.log('❌ Failed to log notification permission: $e');
    }
  }

  /// Log notification sent
  static Future<void> logNotificationSent({required String type, String? goalId, String? title}) async {
    try {
      await _analytics?.logEvent(
        name: 'notification_sent',
        parameters: {'type': type, if (goalId != null) 'goal_id': goalId, if (title != null) 'title': title},
      );
      dev.log('📬 Notification sent logged: $type');
    } catch (e) {
      dev.log('❌ Failed to log notification sent: $e');
    }
  }

  /// Log notification opened
  static Future<void> logNotificationOpened({required String type, String? goalId, String? action}) async {
    try {
      await _analytics?.logEvent(
        name: 'notification_opened',
        parameters: {'type': type, if (goalId != null) 'goal_id': goalId, if (action != null) 'action': action},
      );
      dev.log('📂 Notification opened logged: $type');
    } catch (e) {
      dev.log('❌ Failed to log notification opened: $e');
    }
  }

  // ================================
  // SETTINGS EVENTS
  // ================================

  /// Log settings changed
  static Future<void> logSettingsChanged({required String settingName, required String oldValue, required String newValue}) async {
    try {
      await _analytics?.logEvent(name: 'settings_changed', parameters: {'setting_name': settingName, 'old_value': oldValue, 'new_value': newValue});
      dev.log('⚙️ Settings changed logged: $settingName');
    } catch (e) {
      dev.log('❌ Failed to log settings changed: $e');
    }
  }

  /// Log theme changed
  static Future<void> logThemeChanged({required String oldTheme, required String newTheme}) async {
    try {
      await _analytics?.logEvent(name: 'theme_changed', parameters: {'old_theme': oldTheme, 'new_theme': newTheme});
      dev.log('🎨 Theme changed logged: $oldTheme → $newTheme');
    } catch (e) {
      dev.log('❌ Failed to log theme changed: $e');
    }
  }

  /// Log language changed
  static Future<void> logLanguageChanged({required String oldLanguage, required String newLanguage}) async {
    try {
      await _analytics?.logEvent(name: 'language_changed', parameters: {'old_language': oldLanguage, 'new_language': newLanguage});
      dev.log('🌍 Language changed logged: $oldLanguage → $newLanguage');
    } catch (e) {
      dev.log('❌ Failed to log language changed: $e');
    }
  }

  // ================================
  // DATA MANAGEMENT EVENTS
  // ================================

  /// Log data backup
  static Future<void> logDataBackup({required bool success, int? itemCount, String? errorMessage}) async {
    try {
      await _analytics?.logEvent(
        name: 'data_backup',
        parameters: {'success': success, if (itemCount != null) 'item_count': itemCount, if (errorMessage != null) 'error_message': errorMessage},
      );
      dev.log('💾 Data backup logged: $success');
    } catch (e) {
      dev.log('❌ Failed to log data backup: $e');
    }
  }

  /// Log data restore
  static Future<void> logDataRestore({required bool success, int? itemCount, String? errorMessage}) async {
    try {
      await _analytics?.logEvent(
        name: 'data_restore',
        parameters: {'success': success, if (itemCount != null) 'item_count': itemCount, if (errorMessage != null) 'error_message': errorMessage},
      );
      dev.log('📥 Data restore logged: $success');
    } catch (e) {
      dev.log('❌ Failed to log data restore: $e');
    }
  }

  /// Log data deletion
  static Future<void> logDataDeletion({required bool success, int? itemCount, String? errorMessage}) async {
    try {
      await _analytics?.logEvent(
        name: 'data_deletion',
        parameters: {'success': success, if (itemCount != null) 'item_count': itemCount, if (errorMessage != null) 'error_message': errorMessage},
      );
      dev.log('🗑️ Data deletion logged: $success');
    } catch (e) {
      dev.log('❌ Failed to log data deletion: $e');
    }
  }

  // ================================
  // ONBOARDING EVENTS
  // ================================

  /// Log onboarding completed
  static Future<void> logOnboardingCompleted({
    required int totalSteps,
    required int completedSteps,
    required int durationSeconds,
    bool? notificationPermissionGranted,
  }) async {
    try {
      await _analytics?.logEvent(
        name: 'onboarding_completed',
        parameters: {
          'total_steps': totalSteps,
          'completed_steps': completedSteps,
          'duration_seconds': durationSeconds,
          if (notificationPermissionGranted != null) 'notification_permission_granted': notificationPermissionGranted,
        },
      );
      dev.log('🎯 Onboarding completed logged');
    } catch (e) {
      dev.log('❌ Failed to log onboarding completed: $e');
    }
  }

  /// Log onboarding step completed
  static Future<void> logOnboardingStepCompleted({required int stepNumber, required String stepName}) async {
    try {
      await _analytics?.logEvent(name: 'onboarding_step_completed', parameters: {'step_number': stepNumber, 'step_name': stepName});
      dev.log('👣 Onboarding step completed logged: $stepName');
    } catch (e) {
      dev.log('❌ Failed to log onboarding step completed: $e');
    }
  }

  // ================================
  // ERROR TRACKING
  // ================================

  /// Log custom error
  static Future<void> logError({
    required String errorName,
    required String errorMessage,
    String? errorStack,
    Map<String, Object>? additionalData,
  }) async {
    try {
      await _analytics?.logEvent(
        name: 'custom_error',
        parameters: {
          'error_name': errorName,
          'error_message': errorMessage,
          if (errorStack != null) 'error_stack': errorStack,
          if (additionalData != null) ...additionalData,
        },
      );
      dev.log('❌ Error logged: $errorName');
    } catch (e) {
      dev.log('❌ Failed to log error: $e');
    }
  }

  // ================================
  // CUSTOM EVENTS
  // ================================

  /// Log custom event
  static Future<void> logCustomEvent({required String eventName, Map<String, Object>? parameters}) async {
    try {
      await _analytics?.logEvent(name: eventName, parameters: parameters);
      dev.log('🎯 Custom event logged: $eventName');
    } catch (e) {
      dev.log('❌ Failed to log custom event: $e');
    }
  }
}
