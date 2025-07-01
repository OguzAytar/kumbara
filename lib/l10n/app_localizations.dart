import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Uygulamanın başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kumbara - Birikim Takip'**
  String get appTitle;

  /// Hoş geldiniz mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz'**
  String get welcome;

  /// Başlama butonu
  ///
  /// In tr, this message translates to:
  /// **'Başlayalım'**
  String get getStarted;

  /// İlk onboarding başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerinizi Belirleyin'**
  String get onboardingTitle1;

  /// İlk onboarding açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Birikim hedeflerinizi kolayca oluşturun ve takip edin'**
  String get onboardingDesc1;

  /// İkinci onboarding başlığı
  ///
  /// In tr, this message translates to:
  /// **'Para Biriktirin'**
  String get onboardingTitle2;

  /// İkinci onboarding açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Düzenli olarak para yatırın ve hedeflerinize ulaşın'**
  String get onboardingDesc2;

  /// Üçüncü onboarding başlığı
  ///
  /// In tr, this message translates to:
  /// **'İlerlemenizi İzleyin'**
  String get onboardingTitle3;

  /// Üçüncü onboarding açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Grafikler ve raporlarla ilerlemenizi görselleştirin'**
  String get onboardingDesc3;

  /// İleri butonu
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get next;

  /// Geç butonu
  ///
  /// In tr, this message translates to:
  /// **'Geç'**
  String get skip;

  /// Ana sayfa
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get home;

  /// Toplam birikimler
  ///
  /// In tr, this message translates to:
  /// **'Toplam Birikimler'**
  String get totalSavings;

  /// Aktif hedefler
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hedefler'**
  String get activeGoals;

  /// Tamamlanan hedefler
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan Hedefler'**
  String get completedGoals;

  /// Son birikimler
  ///
  /// In tr, this message translates to:
  /// **'Son Birikimler'**
  String get recentSavings;

  /// Birikim ekleme butonu
  ///
  /// In tr, this message translates to:
  /// **'Birikim Ekle'**
  String get addSaving;

  /// Ayarlar
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// Genel ayarlar
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get general;

  /// Bildirimler
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// Bildirim alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma bildirimleri'**
  String get notificationSubtitle;

  /// Tema
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// Açık tema
  ///
  /// In tr, this message translates to:
  /// **'Açık tema'**
  String get lightTheme;

  /// Karanlık tema
  ///
  /// In tr, this message translates to:
  /// **'Karanlık tema'**
  String get darkTheme;

  /// Dil
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// Türkçe dili
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// İngilizce dili
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get english;

  /// Veri ayarları
  ///
  /// In tr, this message translates to:
  /// **'Veriler'**
  String get data;

  /// Veri yedekleme
  ///
  /// In tr, this message translates to:
  /// **'Verileri Yedekle'**
  String get backupData;

  /// Yedekleme alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikimlerinizi yedekleyin'**
  String get backupSubtitle;

  /// Veri geri yükleme
  ///
  /// In tr, this message translates to:
  /// **'Verileri Geri Yükle'**
  String get restoreData;

  /// Geri yükleme alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedekten geri yükleyin'**
  String get restoreSubtitle;

  /// Tüm veri silme
  ///
  /// In tr, this message translates to:
  /// **'Tüm Verileri Sil'**
  String get deleteAllData;

  /// Veri silme uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Dikkat: Bu işlem geri alınamaz'**
  String get deleteDataSubtitle;

  /// Hakkında bölümü
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// Sürüm
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get version;

  /// Yardım ve destek
  ///
  /// In tr, this message translates to:
  /// **'Yardım & Destek'**
  String get helpSupport;

  /// Yardım alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'SSS ve iletişim'**
  String get helpSubtitle;

  /// Tema seçimi başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tema Seçin'**
  String get selectTheme;

  /// Dil seçimi başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçin'**
  String get selectLanguage;

  /// İptal butonu
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// Sil butonu
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// Veri silme dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tüm Verileri Sil'**
  String get deleteAllDataTitle;

  /// Veri silme dialog mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem tüm birikimlerinizi ve ayarlarınızı silecektir. Bu işlem geri alınamaz. Devam etmek istediğinizden emin misiniz?'**
  String get deleteAllDataMessage;

  /// Başarılı yedekleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Veriler başarıyla yedeklendi!'**
  String get dataBackedUpSuccessfully;

  /// Başarılı geri yükleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Veriler başarıyla geri yüklendi!'**
  String get dataRestoredSuccessfully;

  /// Başarılı veri silme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Tüm veriler başarıyla silindi!'**
  String get dataDeletedSuccessfully;

  /// Yedekleme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme sırasında hata oluştu: {error}'**
  String backupError(String error);

  /// Geri yükleme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Geri yükleme sırasında hata oluştu: {error}'**
  String restoreError(String error);

  /// Veri silme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Veri silme sırasında hata oluştu: {error}'**
  String deleteError(String error);

  /// Yardım sayfası geliyor mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yardım sayfası yakında eklenecek!'**
  String get helpComingSoon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
