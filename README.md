# kumbara

# Kumbara - Birikim Takip Uygulaması

Kumbara, Flutter ile geliştirilmiş modern ve kullanıcı dostu bir birikim takip uygulamasıdır. Bu uygulama sayesinde finansal hedeflerinizi belirleyebilir, birikimlerinizi takip edebilir ve hayallerinize adım adım yaklaşabilirsiniz.

## ✨ Özellikler

### 📊 Birikim Yönetimi
- Çoklu birikim hedefi oluşturma
- Hedef miktar ve tarih belirleme
- Günlük, haftalık, aylık birikim planları
- İlerleme takibi ve grafikler
- Hedef tamamlanma bildirimleri

### 📱 Kullanıcı Deneyimi
- Modern ve sezgisel arayüz
- 3 adımlı kolay onboarding süreci
- Karanlık/Açık tema desteği
- Çoklu dil desteği (Türkçe/İngilizce)
- Responsive tasarım

### 📈 Raporlama ve Analiz
- Detaylı dashboard görünümü
- Aylık/yıllık progress raporları
- En yakın hedef takibi
- En çok ilerleme gösteren hedef analizi
- Grafik ve görselleştirilmiş veriler

### 🔔 Bildirimler
- Birikim hatırlatmaları
- Hedef tamamlanma bildirimleri
- Özelleştirilebilir bildirim ayarları

### 💾 Veri Yönetimi
- Yerel SQLite veritabanı
- Güvenli veri saklama
- Yedekleme ve geri yükleme (yakında)
- Veriye offline erişim

## 🏗️ Mimari

Uygulama, temiz ve sürdürülebilir kod için katmanlı mimari prensipleri kullanılarak geliştirilmiştir:

### 📁 Proje Yapısı
```
lib/
├── core/
│   ├── enums/          # Enum tanımları
│   ├── providers/      # State management (Provider)
│   ├── theme/          # Tema ve stil dosyaları
│   └── widgets/        # Yeniden kullanılabilir widget'lar
├── models/             # Veri modelleri
│   ├── app_settings.dart
│   ├── saving.dart
│   └── saving_transaction.dart
├── services/           # İş mantığı katmanı
│   ├── database_helper.dart
│   ├── notification_service.dart
│   ├── saving_service.dart
│   └── settings_service.dart
└── view/              # UI katmanı
    ├── home/          # Ana sayfa
    ├── onboard/       # Onboarding ekranları
    ├── settings/      # Ayarlar sayfası
    └── splash/        # Splash screen
```

### 🔧 Kullanılan Teknolojiler
- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **SQLite**: Yerel veritabanı
- **Flutter Local Notifications**: Bildirim yönetimi
- **FL Chart**: Grafik ve görselleştirme
- **Smooth Page Indicator**: Sayfa göstergeleri

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (3.8.1+)
- Dart SDK (3.8.1+)
- Android Studio / VS Code
- iOS Simulator (macOS) veya Android Emulator

### Adımlar

1. Repository'yi klonlayın:
```bash
git clone https://github.com/[kullanici-adi]/kumbara.git
cd kumbara
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📱 Desteklenen Platformlar

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Web
- ✅ Windows
- ✅ Linux

## 🎯 Özellik Roadmap

### v1.1.0 (Yakında)
- [ ] Veri yedekleme ve geri yükleme
- [ ] Kategori bazlı birikim hedefleri
- [ ] Gelişmiş rapor ve analitik
- [ ] Widget desteği (iOS/Android)

### v1.2.0 (Planlanan)
- [ ] Bulut senkronizasyonu
- [ ] Sosyal özellikler (hedef paylaşımı)
- [ ] Gamification öğeleri
- [ ] Gelişmiş bildirim sistemi

### v2.0.0 (Gelecek)
- [ ] AI destekli tasarruf önerileri
- [ ] Crypto takibi
- [ ] Yatırım planlaması
- [ ] Multi-currency desteği

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen katkıda bulunmadan önce [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını okuyun.

### Geliştirme Süreci
1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 📞 İletişim

- **Email**: [your-email@example.com]
- **GitHub**: [@your-username]
- **LinkedIn**: [Your LinkedIn Profile]

## 🙏 Teşekkürler

Bu proje aşağıdaki açık kaynak projelerden ilham almıştır:
- Flutter Framework
- Provider Package
- SQLite
- Material Design

## 📊 İstatistikler

![GitHub stars](https://img.shields.io/github/stars/username/kumbara)
![GitHub forks](https://img.shields.io/github/forks/username/kumbara)
![GitHub issues](https://img.shields.io/github/issues/username/kumbara)
![GitHub license](https://img.shields.io/github/license/username/kumbara)

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
