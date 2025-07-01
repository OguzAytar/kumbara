class AppSettings {
  final int id;
  final bool isFirstLaunch;
  final bool notificationsEnabled;
  final String locale;
  final String theme;
  final DateTime? lastOpenDate;

  AppSettings({
    this.id = 1,
    required this.isFirstLaunch,
    required this.notificationsEnabled,
    required this.locale,
    required this.theme,
    this.lastOpenDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isFirstLaunch': isFirstLaunch ? 1 : 0,
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'locale': locale,
      'theme': theme,
      'lastOpenDate': lastOpenDate?.millisecondsSinceEpoch,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] ?? 1,
      isFirstLaunch: (map['isFirstLaunch'] ?? 1) == 1,
      notificationsEnabled: (map['notificationsEnabled'] ?? 0) == 1,
      locale: map['locale'] ?? 'tr',
      theme: map['theme'] ?? 'light',
      lastOpenDate: map['lastOpenDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastOpenDate']) : null,
    );
  }

  AppSettings copyWith({int? id, bool? isFirstLaunch, bool? notificationsEnabled, String? locale, String? theme, DateTime? lastOpenDate}) {
    return AppSettings(
      id: id ?? this.id,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      lastOpenDate: lastOpenDate ?? this.lastOpenDate,
    );
  }
}
