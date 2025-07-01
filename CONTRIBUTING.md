# Kumbara Projesine Katkıda Bulunma Rehberi

Kumbara projesine katkıda bulunmak istediğiniz için teşekkür ederiz! Bu rehber, projeye nasıl katkıda bulunabileceğinizi açıklamaktadır.

## 🚀 Hızlı Başlangıç

### Gereksinimler
- Flutter SDK (3.8.1+)
- Dart SDK (3.8.1+)
- Git
- Android Studio / VS Code

### Kurulum
1. Repository'yi fork edin
2. Fork'unuzu yerel makinenize klonlayın:
```bash
git clone https://github.com/[kullanici-adi]/kumbara.git
cd kumbara
```

3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📝 Katkı Türleri

### 🐛 Bug Raporları
- Issue oluşturmadan önce mevcut issue'ları kontrol edin
- Bug template'ini kullanın
- Reproduksiyon adımlarını detaylı yazın
- Screenshots/video ekleyin

### ✨ Özellik İstekleri
- Feature request template'ini kullanın
- Use case'leri açıklayın
- Mockup/wireframe ekleyin (varsa)

### 🔧 Kod Katkıları
1. Issue seçin veya oluşturun
2. Feature branch oluşturun:
```bash
git checkout -b feature/[issue-number]-feature-name
```

3. Değişikliklerinizi yapın
4. Testlerinizi yazın
5. Commit edin:
```bash
git commit -m "feat: [açıklama]"
```

6. Push edin:
```bash
git push origin feature/[issue-number]-feature-name
```

7. Pull Request oluşturun

## 📋 Kod Standartları

### Dart/Flutter
- `flutter analyze` hatasız olmalı
- `flutter test` başarılı olmalı
- Dart formatting kullanın: `dart format .`
- Effective Dart guidelines'ı takip edin

### Commit Mesajları
Conventional Commits formatını kullanıyoruz:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types:
- `feat`: Yeni özellik
- `fix`: Bug düzeltmesi
- `docs`: Dokümantasyon değişiklikleri
- `style`: Kod formatı (mantık değişmez)
- `refactor`: Kod refactoring
- `test`: Test ekleme/düzeltme
- `chore`: Build araçları, auxiliary tools

#### Örnekler:
```
feat(auth): kullanıcı giriş sistemi eklendi
fix(database): null pointer exception düzeltildi
docs(readme): kurulum adımları güncellendi
```

### Branch Adlandırması
- `feature/[issue-number]-brief-description`
- `bugfix/[issue-number]-brief-description`
- `hotfix/[issue-number]-brief-description`
- `docs/[brief-description]`

## 🏗️ Proje Yapısı

```
lib/
├── core/           # Temel yapılar
├── models/         # Veri modelleri  
├── services/       # İş mantığı
├── view/          # UI katmanı
└── main.dart      # Uygulama giriş noktası
```

### Dosya Adlandırması
- Snake_case kullanın: `my_widget.dart`
- Widget dosyaları widget adıyla eşleşmeli
- Test dosyaları `_test.dart` ile bitmeli

## 🧪 Test Yazma

### Unit Tests
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kumbara/models/saving.dart';

void main() {
  group('Saving Model Tests', () {
    test('should calculate completion percentage correctly', () {
      // Arrange
      final saving = Saving(/* ... */);
      
      // Act
      final percentage = saving.completionPercentage;
      
      // Assert
      expect(percentage, equals(50.0));
    });
  });
}
```

### Widget Tests
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kumbara/view/home/widgets/dashboard_card.dart';

void main() {
  testWidgets('DashboardCard should display title and subtitle', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardCard(
          title: 'Test Title',
          subtitle: 'Test Subtitle',
          icon: Icons.test,
          color: Colors.blue,
        ),
      ),
    );

    // Assert
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
  });
}
```

## 📖 Dokümantasyon

- Public API'lar için dokümantasyon yazın
- Complex algoritmaları açıklayın
- README güncel tutun
- Changelog güncelleyin

## 🔍 Review Süreci

### Pull Request Checklist
- [ ] Kod lint/format kontrolünden geçti
- [ ] Unit testler yazıldı ve geçiyor
- [ ] Integration testler geçiyor
- [ ] Dokümantasyon güncellendi
- [ ] Breaking change varsa CHANGELOG güncellendi
- [ ] Screenshots/GIF eklendi (UI değişiklikleri için)

### Review Kriterleri
- Kod kalitesi ve okunabilirlik
- Performance etkileri
- Security considerations
- Backward compatibility
- Test coverage

## 🏷️ Issue Labels

- `bug`: Hata raporları
- `enhancement`: Yeni özellik istekleri
- `documentation`: Dokümantasyon iyileştirmeleri
- `good first issue`: Yeni başlayanlar için uygun
- `help wanted`: Yardım aranan konular
- `priority:high`: Yüksek öncelikli
- `priority:low`: Düşük öncelikli

## 💬 İletişim

- GitHub Issues: Teknik konular
- GitHub Discussions: Genel konuşmalar
- Email: Acil durumlar

## 📜 Lisans

Katkıda bulunarak, kodunuzun MIT lisansı altında lisanslanmasını kabul etmiş olursunuz.

---

**Mutlu kodlamalar! 🎉**
