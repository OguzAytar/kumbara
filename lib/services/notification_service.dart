import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:ogzawesomenotificationmanager/ogzawesomenotificationmanager.dart' as awesome;

import '../core/functions/firebase_analytics_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static bool _isInitialized = false;

  /// Initialize notification service with localized channel names
  static Future<void> initialize({BuildContext? context}) async {
    if (_isInitialized) return;

    // Get localized texts
    AppLocalizations? l10n;
    if (context != null) {
      l10n = AppLocalizations.of(context);
    }

    // Define notification handlers
    final handlers = {'savings_reminder': SavingsReminderHandler(), 'general_notifications': GeneralNotificationHandler()};

    // Define notification channels with localized names
    final channels = [
      awesome.NotificationChannelModel(
        channelGroupKey: 'kumbara_group',
        channelKey: 'savings_reminder',
        channelName: l10n?.notificationChannelName ?? '💰 Birikim Hatırlatıcıları',
        channelDescription: l10n?.notificationChannelDescription ?? 'Düzenli birikim yapmayı hatırlatan bildirimler',
        defaultColor: const Color(0xFF2E7D32),
        importance: awesome.NotificationImportanceModel.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      awesome.NotificationChannelModel(
        channelGroupKey: 'kumbara_group',
        channelKey: 'general_notifications',
        channelName: l10n?.notificationChannelName ?? '📱 Genel Bildirimler',
        channelDescription: l10n?.notificationChannelDescription ?? 'Genel uygulama bildirimleri',
        defaultColor: const Color(0xFF1976D2),
        importance: awesome.NotificationImportanceModel.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
    ];

    // Define channel groups
    final channelGroups = [
      awesome.NotificationChannelGroupModel(
        channelGroupKey: 'kumbara_group',
        channelGroupName: l10n?.notificationChannelName ?? '🏦 Kumbara Bildirimleri',
      ),
    ];

    // Initialize the notification service
    await awesome.NotificationService.initializeNotifications(handlers, channels: channels, channelGroups: channelGroups, debug: true);

    // Set listeners
    await awesome.NotificationService.setListeners();

    // Handle initial notification if app opened from notification
    await awesome.NotificationService.handleInitialNotificationAction();

    _isInitialized = true;
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    return await awesome.NotificationService.requestPermissions();
  }

  /// Check if notifications are allowed
  Future<bool> isNotificationAllowed() async {
    return await awesome.NotificationService.isNotificationAllowed();
  }

  /// Send a savings reminder notification
  Future<void> sendSavingsReminder({required String title, required String body, Map<String, String?>? payload}) async {
    final helper = awesome.NotificationHelper();
    await helper.createNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      channelKey: 'savings_reminder',
      payload: payload,
    );

    // Log notification sent
    await FirebaseAnalyticsHelper.logNotificationSent(type: 'savings_reminder', goalId: payload?['goal_id'], title: title);
  }

  /// Send a scheduled savings reminder
  Future<void> sendScheduledSavingsReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, String?>? payload,
  }) async {
    final helper = awesome.NotificationHelper();

    // Create schedule for the specified date
    final schedule = awesome.NotificationScheduleConverter.createCalendar(
      year: scheduledDate.year,
      month: scheduledDate.month,
      day: scheduledDate.day,
      hour: scheduledDate.hour,
      minute: scheduledDate.minute,
      second: scheduledDate.second,
      allowWhileIdle: true,
      preciseAlarm: true,
    );

    await helper.createScheduledNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      channelKey: 'savings_reminder',
      schedule: schedule,
      payload: payload,
    );

    // Log scheduled notification
    await FirebaseAnalyticsHelper.logNotificationSent(type: 'scheduled_savings_reminder', goalId: payload?['goal_id'], title: title);
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    final helper = awesome.NotificationHelper();
    await helper.cancelNotification(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    final helper = awesome.NotificationHelper();
    await helper.cancelAllNotifications();
  }
}

/// Handler for savings reminder notifications
class SavingsReminderHandler extends awesome.BaseNotificationHandler {
  @override
  Future<void> onActionReceived(awesome.ReceivedActionModel action) async {
    print('💰 Birikim hatırlatıcısı tıklandı: ${action.title}');

    // Log notification opened
    await FirebaseAnalyticsHelper.logNotificationOpened(
      type: 'savings_reminder',
      goalId: action.payload?['goal_id'],
      action: action.actionType?.toString(),
    );

    // Navigate to home screen or specific savings page
    if (action.payload?['screen'] == 'home') {
      // TODO: Navigate to home screen
    } else if (action.payload?['screen'] == 'add_saving') {
      // TODO: Navigate to add saving screen
    }
  }

  @override
  Future<void> onNotificationCreated(awesome.ReceivedNotificationModel notification) async {
    print('📝 Birikim hatırlatıcısı oluşturuldu: ${notification.title}');
  }

  @override
  Future<void> onNotificationDisplayed(awesome.ReceivedNotificationModel notification) async {
    print('👁️ Birikim hatırlatıcısı gösterildi: ${notification.title}');
  }

  @override
  Future<void> onDismissActionReceived(awesome.ReceivedActionModel action) async {
    print('🗑️ Birikim hatırlatıcısı kapatıldı: ${action.title}');
  }
}

/// Handler for general notifications
class GeneralNotificationHandler extends awesome.BaseNotificationHandler {
  @override
  Future<void> onActionReceived(awesome.ReceivedActionModel action) async {
    print('📱 Genel bildirim tıklandı: ${action.title}');

    // Log notification opened
    await FirebaseAnalyticsHelper.logNotificationOpened(
      type: 'general_notification',
      goalId: action.payload?['goal_id'],
      action: action.actionType?.toString(),
    );

    // Handle different types of general notifications
    final notificationType = action.payload?['type'];
    if (notificationType == 'goal_completed') {
      // TODO: Navigate to goals screen
    } else if (notificationType == 'backup_reminder') {
      // TODO: Navigate to settings screen
    }
  }

  @override
  Future<void> onNotificationCreated(awesome.ReceivedNotificationModel notification) async {
    print('📝 Genel bildirim oluşturuldu: ${notification.title}');
  }

  @override
  Future<void> onNotificationDisplayed(awesome.ReceivedNotificationModel notification) async {
    print('👁️ Genel bildirim gösterildi: ${notification.title}');
  }

  @override
  Future<void> onDismissActionReceived(awesome.ReceivedActionModel action) async {
    print('🗑️ Genel bildirim kapatıldı: ${action.title}');
  }
}
