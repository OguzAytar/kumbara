#!/bin/bash

# GitHub repository'si oluşturduktan sonra bu script'i çalıştırın
# Önce GitHub'da repository oluşturun: https://github.com/new
# Repository adı: kumbara
# Açıklama: Flutter ile geliştirilmiş modern birikim takip uygulaması

echo "GitHub repository URL'sini girin (örn: https://github.com/kullanici-adi/kumbara.git):"
read REPO_URL

# Remote origin ekle
git remote add origin $REPO_URL

# Ana branch'i push et
git push -u origin main

echo "✅ Repository başarıyla GitHub'a yüklendi!"
echo "🔗 Repository URL: $REPO_URL"

# Repository özelliklerini göster
echo ""
echo "📊 Proje İstatistikleri:"
echo "$(git rev-list --count HEAD) commit"
echo "$(find . -name "*.dart" | wc -l) Dart dosyası"
echo "$(wc -l < README.md) satır README"

echo ""
echo "🚀 Sonraki adımlar:"
echo "1. GitHub repository'nizde Issues'ı etkinleştirin"
echo "2. Wiki sayfası oluşturun"
echo "3. GitHub Actions ile CI/CD kurun"
echo "4. Releases sayfasını hazırlayın"
