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

  /// Uygulama adı
  ///
  /// In tr, this message translates to:
  /// **'Kumbara'**
  String get appName;

  /// Tekrar deneme butonu
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get retry;

  /// Yeni birikim ekleme geliyor mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yeni birikim ekleme özelliği yakında eklenecek!'**
  String get newSavingComingSoon;

  /// Hoş geldin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz! 👋'**
  String get welcomeMessage;

  /// Hoş geldin alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hayallerinize bir adım daha yaklaşın'**
  String get welcomeSubtitle;

  /// En yakın hedef kartı başlığı
  ///
  /// In tr, this message translates to:
  /// **'En Yakın Hedef'**
  String get nearestTarget;

  /// En çok ilerleme kartı başlığı
  ///
  /// In tr, this message translates to:
  /// **'En Çok İlerleme'**
  String get mostProgress;

  /// Birikimlerim bölümü başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikimlerim'**
  String get mySavings;

  /// Tümünü gör butonu
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get seeAll;

  /// Tüm birikimler sayfası geliyor mesajı
  ///
  /// In tr, this message translates to:
  /// **'Tüm birikimler sayfası yakında eklenecek!'**
  String get allSavingsComingSoon;

  /// Hedef bulunamadı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hedef bulunamadı'**
  String get targetNotFound;

  /// Süresi dolmuş durumu
  ///
  /// In tr, this message translates to:
  /// **'Süresi dolmuş'**
  String get expired;

  /// Bir gün kaldı mesajı
  ///
  /// In tr, this message translates to:
  /// **'1 gün kaldı'**
  String get oneDayLeft;

  /// Gün sayısı kaldı mesajı
  ///
  /// In tr, this message translates to:
  /// **'{days} gün kaldı'**
  String daysLeft(int days);

  /// Birikim bulunamadı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Birikim bulunamadı'**
  String get savingNotFound;

  /// Özet istatistikler başlığı
  ///
  /// In tr, this message translates to:
  /// **'Özet İstatistikler'**
  String get summaryStatistics;

  /// Toplam birikim
  ///
  /// In tr, this message translates to:
  /// **'Toplam Birikim'**
  String get totalSaving;

  /// Aktif hedef
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hedef'**
  String get activeTarget;

  /// Toplam miktar
  ///
  /// In tr, this message translates to:
  /// **'Toplam Miktar'**
  String get totalAmount;

  /// Birikim hedefi yok mesajı
  ///
  /// In tr, this message translates to:
  /// **'Henüz birikim hedefi yok'**
  String get noSavingsGoal;

  /// İlk hedef oluşturma yönergesi
  ///
  /// In tr, this message translates to:
  /// **'İlk birikim hedefinizi oluşturmak için + butonuna tıklayın'**
  String get createFirstGoal;

  /// Detay sayfası geliyor mesajı
  ///
  /// In tr, this message translates to:
  /// **'{title} detay sayfası yakında eklenecek!'**
  String detailPageComingSoon(String title);

  /// Onboard ekranı 1. sayfa başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikimlerinizi Takip Edin'**
  String get trackYourSavings;

  /// Onboard ekranı 1. sayfa açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerinize ulaşmak için biriktirmelerinizi kolayca takip edin ve yönetin.'**
  String get trackYourSavingsDesc;

  /// Onboard ekranı 2. sayfa başlığı
  ///
  /// In tr, this message translates to:
  /// **'İlerlemenizi Görün'**
  String get seeYourProgress;

  /// Onboard ekranı 2. sayfa açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Grafikler ve raporlarla birikimleririnizin ilerleyişini detaylı bir şekilde analiz edin.'**
  String get seeYourProgressDesc;

  /// Onboard ekranı 3. sayfa başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar Alın'**
  String get getReminders;

  /// Onboard ekranı 3. sayfa açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Düzenli birikim yapmayı unutmamak için bildirimlerden yararlanın.'**
  String get getRemindersDesc;

  /// Geri butonu
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// Devam et butonu
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueButton;

  /// Bildirim izni butonu
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlere İzin Ver'**
  String get allowNotifications;

  /// Bildirim olmadan devam et butonu
  ///
  /// In tr, this message translates to:
  /// **'Bildirimsiz Devam Et'**
  String get continueWithoutNotifications;

  /// Bildirim izni başarılı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni verildi! Artık hatırlatmalar alabilirsiniz.'**
  String get notificationPermissionGranted;

  /// Bildirim izni reddedildi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni reddedildi. Ayarlardan açabilirsiniz.'**
  String get notificationPermissionDenied;

  /// Bildirim izni hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni alınırken hata oluştu: {error}'**
  String notificationPermissionError(String error);

  /// Bildirim kanalı adı
  ///
  /// In tr, this message translates to:
  /// **'Kumbara Bildirimleri'**
  String get notificationChannelName;

  /// Bildirim kanalı açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Birikim hatırlatmaları ve hedef bildirimleri'**
  String get notificationChannelDescription;

  /// Birikim hatırlatma bildirimi başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikim Zamanı!'**
  String get savingReminderTitle;

  /// Birikim hatırlatma bildirimi içeriği
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerinize bir adım daha yaklaşmak için bugün para yatırmayı unutmayın'**
  String get savingReminderBody;

  /// Hedef başarıldığında bildirim başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! 🎉'**
  String get goalAchievedTitle;

  /// Hedef başarıldığında bildirim içeriği
  ///
  /// In tr, this message translates to:
  /// **'Hedefinize ulaştınız! Yeni bir hedef belirleyebilirsiniz'**
  String get goalAchievedBody;

  /// Hedefe yaklaşıldığında bildirim başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hedefinize Çok Yakınsınız!'**
  String get goalNearlyAchievedTitle;

  /// Hedefe yaklaşıldığında bildirim içeriği
  ///
  /// In tr, this message translates to:
  /// **'Hedefinizin %90\'ına ulaştınız. Son spurt!'**
  String get goalNearlyAchievedBody;

  /// Yeni birikim ekleme sayfası başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yeni Birikim Ekle'**
  String get addNewSaving;

  /// Kaydet butonu
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// Birikim adı etiketi
  ///
  /// In tr, this message translates to:
  /// **'Birikim Adı'**
  String get savingName;

  /// Birikim adı ipucu
  ///
  /// In tr, this message translates to:
  /// **'Örn: Tatil Fonu, Yeni Araba'**
  String get savingNameHint;

  /// Birikim adı zorunlu alan uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Lütfen birikim adını giriniz'**
  String get pleaseEnterSavingName;

  /// Açıklama etiketi
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get description;

  /// Açıklama ipucu
  ///
  /// In tr, this message translates to:
  /// **'Bu birikim hakkında notlarınızı yazın...'**
  String get descriptionHint;

  /// Hedef tutar etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hedef Tutar'**
  String get targetAmount;

  /// Hedef tutar belirleme anahtarı
  ///
  /// In tr, this message translates to:
  /// **'Hedef tutar belirle'**
  String get setTargetAmount;

  /// Hedef tutar açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Ulaşmak istediğiniz tutarı belirleyin'**
  String get setTargetAmountDesc;

  /// Hedef tutar ipucu
  ///
  /// In tr, this message translates to:
  /// **'Örn: 5000'**
  String get targetAmountHint;

  /// Hedef tutar zorunlu alan uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Lütfen hedef tutarını giriniz'**
  String get pleaseEnterTargetAmount;

  /// Geçerli tutar uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Lütfen geçerli bir tutar giriniz'**
  String get pleaseEnterValidAmount;

  /// Hedef tarihi etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hedef Tarihi'**
  String get targetDate;

  /// Hedef tarih belirleme anahtarı
  ///
  /// In tr, this message translates to:
  /// **'Hedef tarih belirle'**
  String get setTargetDate;

  /// Hedef tarih açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Hedefinize ulaşmak istediğiniz tarihi belirleyin'**
  String get setTargetDateDesc;

  /// Hedef tarih seçim metni
  ///
  /// In tr, this message translates to:
  /// **'Hedef tarihi seçiniz'**
  String get selectTargetDate;

  /// Hedef tarih zorunlu alan uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Lütfen hedef tarihini seçiniz'**
  String get pleaseSelectTargetDate;

  /// Birikim bilgi notu
  ///
  /// In tr, this message translates to:
  /// **'Hedef tutar veya tarih belirlemezseniz, birikiminiz kumbara gibi çalışır ve sadece ne kadar para biriktirdiğinizi takip eder.'**
  String get savingInfo;

  /// Birikim ekleme başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Birikim başarıyla eklendi!'**
  String get savingAddedSuccessfully;

  /// Birikim ekleme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Birikim eklenirken hata oluştu'**
  String get errorAddingSaving;

  /// En yeni sıralama seçeneği
  ///
  /// In tr, this message translates to:
  /// **'En Yeniler'**
  String get sortByNewest;

  /// En eski sıralama seçeneği
  ///
  /// In tr, this message translates to:
  /// **'En Eskiler'**
  String get sortByOldest;

  /// İlerleme sıralama seçeneği
  ///
  /// In tr, this message translates to:
  /// **'İlerleme Durumu'**
  String get sortByProgress;

  /// Tutar sıralama seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get sortByAmount;

  /// Tüm birikimler filtresi
  ///
  /// In tr, this message translates to:
  /// **'Tüm Birikimler'**
  String get allSavings;

  /// Aktif birikimler filtresi
  ///
  /// In tr, this message translates to:
  /// **'Aktif Birikimler'**
  String get activeSavings;

  /// Tamamlanan birikimler filtresi
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan Birikimler'**
  String get completedSavings;

  /// Duraklatılan birikimler filtresi
  ///
  /// In tr, this message translates to:
  /// **'Duraklatılan Birikimler'**
  String get pausedSavings;

  /// Birikim arama ipucu
  ///
  /// In tr, this message translates to:
  /// **'Birikimlerinizi arayın...'**
  String get searchSavings;

  /// Birikim detay yakında mesajı
  ///
  /// In tr, this message translates to:
  /// **'Birikim detayı yakında gelecek'**
  String get savingDetailComingSoon;

  /// Birikimler özet başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikimlerim Özeti'**
  String get savingsOverview;

  /// Toplam birikim sayısı
  ///
  /// In tr, this message translates to:
  /// **'{count} adet birikim'**
  String totalSavingsCount(int count);

  /// Toplam hedef etiketi
  ///
  /// In tr, this message translates to:
  /// **'Toplam Hedef'**
  String get totalTarget;

  /// Toplam biriken tutar etiketi
  ///
  /// In tr, this message translates to:
  /// **'Toplam Biriken Tutar'**
  String get totalAmountSaved;

  /// Ortalama ilerleme etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ortalama İlerleme'**
  String get averageProgress;

  /// Birikim bulunamadı başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikim bulunamadı'**
  String get noSavingsFound;

  /// Birikim bulunamadı açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Henüz hiç birikim eklememişsiniz veya arama kriterlerinize uygun birikim yok.'**
  String get noSavingsFoundDesc;

  /// Tamamlandı durumu
  ///
  /// In tr, this message translates to:
  /// **'tamamlandı'**
  String get completed;

  /// Birikim düzenle başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikim Düzenle'**
  String get editSaving;

  /// Birikim detayları başlığı
  ///
  /// In tr, this message translates to:
  /// **'Birikim Detayları'**
  String get savingDetails;

  /// Başlangıç tutarı etiketi
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç Tutarı'**
  String get initialAmount;

  /// Başlangıç tutarı ipucu
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tutarını giriniz'**
  String get initialAmountHint;

  /// Başlangıç tutarı açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Birikiminize başlangıç tutarı ekleyin'**
  String get initialAmountDesc;

  /// Başlangıç tutarı belirle
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç Tutarı Belirle'**
  String get setInitialAmount;

  /// Güncelle butonu
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// Birikim güncelleme başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Birikim başarıyla güncellendi'**
  String get savingUpdatedSuccessfully;

  /// Birikim güncelleme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Birikim güncellenirken hata oluştu'**
  String get errorUpdatingSaving;

  /// Mevcut tutar etiketi
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Tutar'**
  String get currentAmount;

  /// Para ekleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Para Ekle'**
  String get addMoney;

  /// Para ekleme ipucu
  ///
  /// In tr, this message translates to:
  /// **'Eklemek istediğiniz tutarı giriniz'**
  String get addMoneyHint;

  /// Günlük hedef tutar
  ///
  /// In tr, this message translates to:
  /// **'Günlük ₺{amount}'**
  String dailyTarget(String amount);

  /// Para ekleme başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Para başarıyla eklendi'**
  String get moneyAddedSuccessfully;

  /// Para ekleme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Para eklenirken hata oluştu'**
  String get errorAddingMoney;
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
