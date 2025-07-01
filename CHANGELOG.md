# Changelog

Bu dosya Kumbara projesindeki tüm önemli değişiklikleri içerir.

Format [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standartına uygundur ve bu proje [Semantic Versioning](https://semver.org/spec/v2.0.0.html) kullanır.

## [Unreleased]

### Planned
- Veri yedekleme ve geri yükleme
- Kategori bazlı birikim hedefleri
- Widget desteği (iOS/Android)
- Gelişmiş rapor ve analitik

## [1.0.0] - 2025-01-07

### Added
- 🎉 İlk sürüm yayınlandı!
- 📱 Flutter ile cross-platform uygulama geliştirme
- 🏗️ Katmanlı mimari ile temiz kod yapısı
- 💾 SQLite ile yerel veritabanı entegrasyonu
- 🔄 Provider ile state management
- 🎨 Modern ve kullanıcı dostu arayüz tasarımı

#### Core Features
- ✅ Çoklu birikim hedefi oluşturma
- ✅ Hedef miktar ve tarih belirleme
- ✅ Günlük, haftalık, aylık birikim planları
- ✅ İlerleme takibi ve yüzde hesaplaması
- ✅ Dashboard görünümü

#### UI/UX
- ✅ 3 adımlı onboarding süreci
- ✅ Splash screen animasyonları
- ✅ Responsive tasarım
- ✅ Karanlık/Açık tema desteği
- ✅ Modern card tasarımları
- ✅ Progress indicator'lar
- ✅ Smooth page indicators

#### Data Management
- ✅ SQLite veritabanı schema'sı
- ✅ CRUD operasyonları
- ✅ Transaction takibi
- ✅ Veri validasyonu
- ✅ Error handling

#### Services
- ✅ Database helper service
- ✅ Settings service
- ✅ Saving service
- ✅ Notification service setup

#### Models
- ✅ App Settings model
- ✅ Saving model with business logic
- ✅ Saving Transaction model
- ✅ Enum definitions

#### Architecture
- ✅ Provider pattern implementation
- ✅ Service layer separation
- ✅ Model layer with business logic
- ✅ Clean widget structure
- ✅ Reusable components

#### Platform Support
- ✅ Android support
- ✅ iOS support
- ✅ macOS support
- ✅ Web support
- ✅ Windows support
- ✅ Linux support

#### Developer Experience
- ✅ Comprehensive documentation
- ✅ Code organization
- ✅ Git workflow setup
- ✅ Contributing guidelines
- ✅ MIT License

### Technical Details
- Flutter SDK: 3.8.1+
- Dart SDK: 3.8.1+
- Material Design 3
- Provider: 6.1.2
- SQLite: 2.3.3+1
- Local Notifications: 17.2.4

### Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
  sqflite: ^2.3.3+1
  path: ^1.9.0
  smooth_page_indicator: ^1.2.0+3
  permission_handler: ^11.3.1
  flutter_local_notifications: ^17.2.3
  fl_chart: ^0.69.0
  intl: ^0.19.0
  timezone: ^0.9.4
```

## [0.1.0] - 2025-01-07

### Added
- 🔧 Proje kurulumu
- 📁 Klasör yapısı oluşturuldu
- 🎯 İlk MVP planlaması

---

### Legend
- 🎉 Major release
- ✨ New feature
- 🐛 Bug fix
- 🔧 Internal changes
- 📝 Documentation
- 🎨 UI/UX improvements
- ⚡ Performance improvements
- 🔒 Security fixes
- 🗑️ Deprecation
- 💥 Breaking changes
