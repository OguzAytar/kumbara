// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Kumbara - Birikim Takip';

  @override
  String get welcome => 'Hoş Geldiniz';

  @override
  String get getStarted => 'Başlayalım';

  @override
  String get onboardingTitle1 => 'Hedeflerinizi Belirleyin';

  @override
  String get onboardingDesc1 =>
      'Birikim hedeflerinizi kolayca oluşturun ve takip edin';

  @override
  String get onboardingTitle2 => 'Para Biriktirin';

  @override
  String get onboardingDesc2 =>
      'Düzenli olarak para yatırın ve hedeflerinize ulaşın';

  @override
  String get onboardingTitle3 => 'İlerlemenizi İzleyin';

  @override
  String get onboardingDesc3 =>
      'Grafikler ve raporlarla ilerlemenizi görselleştirin';

  @override
  String get next => 'İleri';

  @override
  String get skip => 'Geç';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get totalSavings => 'Toplam Birikimler';

  @override
  String get activeGoals => 'Aktif Hedefler';

  @override
  String get completedGoals => 'Tamamlanan Hedefler';

  @override
  String get recentSavings => 'Son Birikimler';

  @override
  String get addSaving => 'Birikim Ekle';

  @override
  String get settings => 'Ayarlar';

  @override
  String get general => 'Genel';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notificationSubtitle => 'Hatırlatma bildirimleri';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Açık tema';

  @override
  String get darkTheme => 'Karanlık tema';

  @override
  String get language => 'Dil';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get data => 'Veriler';

  @override
  String get backupData => 'Verileri Yedekle';

  @override
  String get backupSubtitle => 'Birikimlerinizi yedekleyin';

  @override
  String get restoreData => 'Verileri Geri Yükle';

  @override
  String get restoreSubtitle => 'Yedekten geri yükleyin';

  @override
  String get deleteAllData => 'Tüm Verileri Sil';

  @override
  String get deleteDataSubtitle => 'Dikkat: Bu işlem geri alınamaz';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get helpSupport => 'Yardım & Destek';

  @override
  String get helpSubtitle => 'SSS ve iletişim';

  @override
  String get selectTheme => 'Tema Seçin';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get deleteAllDataTitle => 'Tüm Verileri Sil';

  @override
  String get deleteAllDataMessage =>
      'Bu işlem tüm birikimlerinizi ve ayarlarınızı silecektir. Bu işlem geri alınamaz. Devam etmek istediğinizden emin misiniz?';

  @override
  String get dataBackedUpSuccessfully => 'Veriler başarıyla yedeklendi!';

  @override
  String get dataRestoredSuccessfully => 'Veriler başarıyla geri yüklendi!';

  @override
  String get dataDeletedSuccessfully => 'Tüm veriler başarıyla silindi!';

  @override
  String backupError(String error) {
    return 'Yedekleme sırasında hata oluştu: $error';
  }

  @override
  String restoreError(String error) {
    return 'Geri yükleme sırasında hata oluştu: $error';
  }

  @override
  String deleteError(String error) {
    return 'Veri silme sırasında hata oluştu: $error';
  }

  @override
  String get helpComingSoon => 'Yardım sayfası yakında eklenecek!';

  @override
  String get appName => 'Kumbara';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get newSavingComingSoon =>
      'Yeni birikim ekleme özelliği yakında eklenecek!';

  @override
  String get welcomeMessage => 'Hoş Geldiniz! 👋';

  @override
  String get welcomeSubtitle => 'Hayallerinize bir adım daha yaklaşın';

  @override
  String get nearestTarget => 'En Yakın Hedef';

  @override
  String get mostProgress => 'En Çok İlerleme';

  @override
  String get mySavings => 'Birikimlerim';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get allSavingsComingSoon =>
      'Tüm birikimler sayfası yakında eklenecek!';

  @override
  String get targetNotFound => 'Hedef bulunamadı';

  @override
  String get expired => 'Süresi dolmuş';

  @override
  String get oneDayLeft => '1 gün kaldı';

  @override
  String daysLeft(int days) {
    return '$days gün kaldı';
  }

  @override
  String get savingNotFound => 'Birikim bulunamadı';

  @override
  String get summaryStatistics => 'Özet İstatistikler';

  @override
  String get totalSaving => 'Toplam Birikim';

  @override
  String get activeTarget => 'Aktif Hedef';

  @override
  String get totalAmount => 'Toplam Miktar';

  @override
  String get noSavingsGoal => 'Henüz birikim hedefi yok';

  @override
  String get createFirstGoal =>
      'İlk birikim hedefinizi oluşturmak için + butonuna tıklayın';

  @override
  String detailPageComingSoon(String title) {
    return '$title detay sayfası yakında eklenecek!';
  }

  @override
  String get trackYourSavings => 'Birikimlerinizi Takip Edin';

  @override
  String get trackYourSavingsDesc =>
      'Hedeflerinize ulaşmak için biriktirmelerinizi kolayca takip edin ve yönetin.';

  @override
  String get seeYourProgress => 'İlerlemenizi Görün';

  @override
  String get seeYourProgressDesc =>
      'Grafikler ve raporlarla birikimleririnizin ilerleyişini detaylı bir şekilde analiz edin.';

  @override
  String get getReminders => 'Hatırlatmalar Alın';

  @override
  String get getRemindersDesc =>
      'Düzenli birikim yapmayı unutmamak için bildirimlerden yararlanın.';

  @override
  String get back => 'Geri';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get allowNotifications => 'Bildirimlere İzin Ver';

  @override
  String get continueWithoutNotifications => 'Bildirimsiz Devam Et';

  @override
  String get notificationPermissionGranted =>
      'Bildirim izni verildi! Artık hatırlatmalar alabilirsiniz.';

  @override
  String get notificationPermissionDenied =>
      'Bildirim izni reddedildi. Ayarlardan açabilirsiniz.';

  @override
  String notificationPermissionError(String error) {
    return 'Bildirim izni alınırken hata oluştu: $error';
  }

  @override
  String get notificationChannelName => 'Kumbara Bildirimleri';

  @override
  String get notificationChannelDescription =>
      'Birikim hatırlatmaları ve hedef bildirimleri';

  @override
  String get savingReminderTitle => 'Birikim Zamanı!';

  @override
  String get savingReminderBody =>
      'Hedeflerinize bir adım daha yaklaşmak için bugün para yatırmayı unutmayın';

  @override
  String get goalAchievedTitle => 'Tebrikler! 🎉';

  @override
  String get goalAchievedBody =>
      'Hedefinize ulaştınız! Yeni bir hedef belirleyebilirsiniz';

  @override
  String get goalNearlyAchievedTitle => 'Hedefinize Çok Yakınsınız!';

  @override
  String get goalNearlyAchievedBody =>
      'Hedefinizin %90\'ına ulaştınız. Son spurt!';

  @override
  String get addNewSaving => 'Yeni Birikim Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get savingName => 'Birikim Adı';

  @override
  String get savingNameHint => 'Örn: Tatil Fonu, Yeni Araba';

  @override
  String get pleaseEnterSavingName => 'Lütfen birikim adını giriniz';

  @override
  String get description => 'Açıklama';

  @override
  String get descriptionHint => 'Bu birikim hakkında notlarınızı yazın...';

  @override
  String get targetAmount => 'Hedef Tutar';

  @override
  String get setTargetAmount => 'Hedef tutar belirle';

  @override
  String get setTargetAmountDesc => 'Ulaşmak istediğiniz tutarı belirleyin';

  @override
  String get targetAmountHint => 'Örn: 5000';

  @override
  String get pleaseEnterTargetAmount => 'Lütfen hedef tutarını giriniz';

  @override
  String get pleaseEnterValidAmount => 'Lütfen geçerli bir tutar giriniz';

  @override
  String get targetDate => 'Hedef Tarihi';

  @override
  String get setTargetDate => 'Hedef tarih belirle';

  @override
  String get setTargetDateDesc =>
      'Hedefinize ulaşmak istediğiniz tarihi belirleyin';

  @override
  String get selectTargetDate => 'Hedef tarihi seçiniz';

  @override
  String get pleaseSelectTargetDate => 'Lütfen hedef tarihini seçiniz';

  @override
  String get savingInfo =>
      'Hedef tutar veya tarih belirlemezseniz, birikiminiz kumbara gibi çalışır ve sadece ne kadar para biriktirdiğinizi takip eder.';

  @override
  String get savingAddedSuccessfully => 'Birikim başarıyla eklendi!';

  @override
  String get errorAddingSaving => 'Birikim eklenirken hata oluştu';

  @override
  String get sortByNewest => 'En Yeniler';

  @override
  String get sortByOldest => 'En Eskiler';

  @override
  String get sortByProgress => 'İlerleme Durumu';

  @override
  String get sortByAmount => 'Tutar';

  @override
  String get allSavings => 'Tüm Birikimler';

  @override
  String get activeSavings => 'Aktif Birikimler';

  @override
  String get completedSavings => 'Tamamlanan Birikimler';

  @override
  String get pausedSavings => 'Duraklatılan Birikimler';

  @override
  String get searchSavings => 'Birikimlerinizi arayın...';

  @override
  String get savingDetailComingSoon => 'Birikim detayı yakında gelecek';

  @override
  String get savingsOverview => 'Birikimlerim Özeti';

  @override
  String totalSavingsCount(int count) {
    return '$count adet birikim';
  }

  @override
  String get totalTarget => 'Toplam Hedef';

  @override
  String get totalAmountSaved => 'Toplam Biriken Tutar';

  @override
  String get averageProgress => 'Ortalama İlerleme';

  @override
  String get noSavingsFound => 'Birikim bulunamadı';

  @override
  String get noSavingsFoundDesc =>
      'Henüz hiç birikim eklememişsiniz veya arama kriterlerinize uygun birikim yok.';

  @override
  String get completed => 'tamamlandı';

  @override
  String get editSaving => 'Birikim Düzenle';

  @override
  String get savingDetails => 'Birikim Detayları';

  @override
  String get initialAmount => 'Başlangıç Tutarı';

  @override
  String get initialAmountHint => 'Başlangıç tutarını giriniz';

  @override
  String get initialAmountDesc => 'Birikiminize başlangıç tutarı ekleyin';

  @override
  String get setInitialAmount => 'Başlangıç Tutarı Belirle';

  @override
  String get update => 'Güncelle';

  @override
  String get savingUpdatedSuccessfully => 'Birikim başarıyla güncellendi';

  @override
  String get errorUpdatingSaving => 'Birikim güncellenirken hata oluştu';

  @override
  String get currentAmount => 'Mevcut Tutar';

  @override
  String get addMoney => 'Para Ekle';

  @override
  String get addMoneyHint => 'Eklemek istediğiniz tutarı giriniz';

  @override
  String dailyTarget(String amount) {
    return 'Günlük ₺$amount';
  }

  @override
  String get moneyAddedSuccessfully => 'Para başarıyla eklendi';

  @override
  String get errorAddingMoney => 'Para eklenirken hata oluştu';
}
