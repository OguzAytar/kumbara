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
}
