import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kumbara/firebase_options.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'core/functions/firebase_analytics_helper.dart';
import 'core/providers/saving_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'services/notification_service.dart';
import 'view/settings/settings_viewmodel.dart';
import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and Analytics
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalyticsHelper.initialize();

  // Initialize notification service
  try {
    await NotificationService.initialize();
  } catch (e) {
    print('Notification initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SavingProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, SettingsViewModel>(
          create: (context) => SettingsViewModel(settingsProvider: context.read<SettingsProvider>()),
          update: (context, settingsProvider, previous) => previous ?? SettingsViewModel(settingsProvider: settingsProvider),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Kumbara - Birikim Takip',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getThemeMode(settingsProvider.theme),

            // Localization support
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: _getLocale(settingsProvider.locale),

            // Firebase Analytics Observer
            navigatorObservers: [if (FirebaseAnalyticsHelper.observer != null) FirebaseAnalyticsHelper.observer!],

            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Locale _getLocale(String locale) {
    switch (locale) {
      case 'tr':
        return const Locale('tr', '');
      case 'en':
        return const Locale('en', '');
      default:
        return const Locale('tr', ''); // Varsayılan Türkçe
    }
  }
}
