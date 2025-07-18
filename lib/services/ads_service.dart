import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob reklam yönetimi için servis sınıfı
/// Banner ve Interstitial reklamları yönetir
/// Premium abonelik durumuna göre reklamları gösterir/gizler
class AdsService with ChangeNotifier {
  static AdsService? _instance;
  static AdsService get instance => _instance ??= AdsService._();

  AdsService._();

  // Test Ad Unit IDs (geliştirme ortamı için) - Güncellenmiş
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  // Gerçek Ad Unit IDs (gelecekte kullanım için yorum olarak bırakıldı)
  // iOS: ca-app-pub-1840661306138455/2996419101 (Banner), ca-app-pub-1840661306138455/6877073921 (Interstitial)
  // Android: ca-app-pub-1840661306138455/5074388734 (Banner), ca-app-pub-1840661306138455/3761307062 (Interstitial)

  // Reklam durumları
  InterstitialAd? _actionInterstitialAd;
  bool _isInitialized = false;
  bool _isPremiumUser = false;
  bool _isInterstitialAdLoaded = false;

  // Banner reklamları için cache - her widget'ın kendi banner'ı olacak
  final Map<String, BannerAd> _bannerAds = {};
  final Map<String, int> _retryAttempts = {};
  static const int _maxRetryAttempts = 3;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isPremiumUser => _isPremiumUser;
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  /// AdMob'u başlatır
  Future<void> initialize({bool useTestAds = kDebugMode}) async {
    try {
      // Test cihazını debug modunda ekle
      if (kDebugMode) {
        final List<String> testDeviceIds = <String>[];
        // Test cihazı eklemek için (debug konsolundan gerçek device ID'yi alabilirsiniz)
        testDeviceIds.add('your_device_id_here');

        final RequestConfiguration configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
        MobileAds.instance.updateRequestConfiguration(configuration);

        print('Test cihazları yapılandırıldı: $testDeviceIds');
      }

      final initResult = await MobileAds.instance.initialize();

      if (kDebugMode) {
        print('AdMob initialization result: $initResult');
      }

      _isInitialized = true;

      // Premium kullanıcı değilse interstitial reklamını yükle
      if (!_isPremiumUser) {
        await _loadActionInterstitialAd(useTestAds: useTestAds);
      }

      notifyListeners();

      if (kDebugMode) {
        print('AdMob başarıyla başlatıldı');
      }
    } catch (e) {
      _isInitialized = false;
      if (kDebugMode) {
        print('AdMob başlatma hatası: $e');
      }
      notifyListeners();
    }
  }

  /// Premium kullanıcı durumunu ayarlar
  void setPremiumStatus(bool isPremium) {
    if (_isPremiumUser != isPremium) {
      _isPremiumUser = isPremium;

      if (isPremium) {
        // Premium kullanıcı için tüm reklamları kaldır
        _disposeAllBannerAds();
        _disposeInterstitialAd();
      } else {
        // Premium olmayan kullanıcı için interstitial reklamı yükle
        if (_isInitialized) {
          _loadActionInterstitialAd();
        }
      }

      notifyListeners();
    }
  }

  /// Her widget için benzersiz bir banner reklam oluşturur
  Future<BannerAd?> createBannerAd(String widgetId, {bool useTestAds = true}) async {
    // Test reklamları zorla aktif
    if (_isPremiumUser || !_isInitialized) return null;

    // Eğer bu widget için zaten bir reklam varsa, önce onu temizle
    if (_bannerAds.containsKey(widgetId)) {
      _bannerAds[widgetId]?.dispose();
      _bannerAds.remove(widgetId);
    }

    // İlk deneme değilse, yeniden deneme sayısını arttır
    if (!_retryAttempts.containsKey(widgetId)) {
      _retryAttempts[widgetId] = 0;
    }

    // Test reklamlarını zorla kullan
    final String adUnitId = _testBannerAdUnitId;

    if (kDebugMode) {
      print('Banner reklam oluşturuluyor: $widgetId, Ad Unit ID: $adUnitId (Deneme ${_retryAttempts[widgetId]! + 1})');
    }

    // Reklam yükleme işlemini biraz geciktir
    await Future.delayed(const Duration(milliseconds: 500));

    // Test cihazları için AdRequest oluştur
    const adRequest = AdRequest();

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: adRequest,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Başarılı yükleme durumunda yeniden deneme sayısını sıfırla
          _retryAttempts.remove(widgetId);

          if (kDebugMode) {
            print('✅ Banner reklam başarıyla yüklendi: $widgetId');
          }
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAds.remove(widgetId);

          // Yeniden deneme sayısını güncelle
          final currentAttempts = _retryAttempts[widgetId] ?? 0;
          _retryAttempts[widgetId] = currentAttempts + 1;

          if (kDebugMode) {
            print('❌ Banner reklam yüklenemedi ($widgetId): $error');
            print('Error Code: ${error.code}, Domain: ${error.domain}');
            print('Message: ${error.message}');
            print('Deneme ${_retryAttempts[widgetId]}/$_maxRetryAttempts');
          }

          // Maksimum deneme sayısına ulaşmadıysa yeniden dene
          if (_retryAttempts[widgetId]! < _maxRetryAttempts) {
            Future.delayed(const Duration(seconds: 5), () {
              if (kDebugMode) {
                print('🔄 Banner reklam yeniden deneniyor: $widgetId (${_retryAttempts[widgetId]! + 1}/$_maxRetryAttempts)');
              }
              createBannerAd(widgetId, useTestAds: useTestAds);
            });
          } else {
            if (kDebugMode) {
              print('🔴 Banner reklam maksimum deneme sayısına ulaştı: $widgetId');
            }
            _retryAttempts.remove(widgetId);
          }

          notifyListeners();
        },
        onAdOpened: (ad) {
          if (kDebugMode) {
            print('Banner reklam açıldı: $widgetId');
          }
        },
        onAdClosed: (ad) {
          if (kDebugMode) {
            print('Banner reklam kapatıldı: $widgetId');
          }
        },
      ),
    );

    try {
      await bannerAd.load();
      _bannerAds[widgetId] = bannerAd;

      if (kDebugMode) {
        print('🚀 Banner reklam load() tamamlandı: $widgetId');
      }

      return bannerAd;
    } catch (e) {
      bannerAd.dispose();
      if (kDebugMode) {
        print('💥 Banner reklam load() exception ($widgetId): $e');
      }
      return null;
    }
  }

  /// Widget için banner reklamını döndürür
  BannerAd? getBannerAd(String widgetId) {
    return _bannerAds[widgetId];
  }

  /// Widget için banner reklamının yüklenip yüklenmediğini kontrol eder
  bool isBannerAdLoaded(String widgetId) {
    return _bannerAds.containsKey(widgetId) && _bannerAds[widgetId] != null;
  }

  /// Specific widget'ın banner reklamını temizler
  void disposeBannerAd(String widgetId) {
    if (_bannerAds.containsKey(widgetId)) {
      _bannerAds[widgetId]?.dispose();
      _bannerAds.remove(widgetId);
    }
    // Yeniden deneme sayısını da temizle
    _retryAttempts.remove(widgetId);
  }

  /// Aksiyon sayfası interstitial reklamını yükler
  Future<void> _loadActionInterstitialAd({bool useTestAds = true}) async {
    // Test reklamları zorla aktif
    if (_isPremiumUser) return;

    _disposeInterstitialAd();

    // Test reklamlarını zorla kullan
    final String adUnitId = _testInterstitialAdUnitId;

    if (kDebugMode) {
      print('Interstitial reklam yükleniyor, Ad Unit ID: $adUnitId');
    }

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _actionInterstitialAd = ad;
          _isInterstitialAdLoaded = true;
          notifyListeners();

          _actionInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (kDebugMode) {
                print('Interstitial reklam gösterildi');
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _actionInterstitialAd = null;
              _isInterstitialAdLoaded = false;
              _loadActionInterstitialAd(useTestAds: useTestAds);
              if (kDebugMode) {
                print('Interstitial reklam kapatıldı');
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _actionInterstitialAd = null;
              _isInterstitialAdLoaded = false;
              if (kDebugMode) {
                print('Interstitial reklam gösterilemedi: $error');
              }
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdLoaded = false;
          notifyListeners();
          if (kDebugMode) {
            print('Interstitial reklam yüklenemedi: $error');
          }
        },
      ),
    );
  }

  /// Interstitial reklamı gösterir
  Future<void> showActionInterstitialAd() async {
    if (_isPremiumUser || !_isInterstitialAdLoaded || _actionInterstitialAd == null) {
      return;
    }

    try {
      await _actionInterstitialAd!.show();
    } catch (e) {
      if (kDebugMode) {
        print('Interstitial reklam gösterme hatası: $e');
      }
    }
  }

  /// Tüm banner reklamlarını temizler
  void _disposeAllBannerAds() {
    for (final ad in _bannerAds.values) {
      ad.dispose();
    }
    _bannerAds.clear();
    _retryAttempts.clear();
  }

  /// Interstitial reklamını temizler
  void _disposeInterstitialAd() {
    _actionInterstitialAd?.dispose();
    _actionInterstitialAd = null;
    _isInterstitialAdLoaded = false;
  }

  /// Interstitial reklamını yeniden yükler
  Future<void> reloadInterstitialAd() async {
    if (!_isPremiumUser && _isInitialized) {
      await _loadActionInterstitialAd();
    }
  }

  /// Servisi temizler
  @override
  void dispose() {
    _disposeAllBannerAds();
    _disposeInterstitialAd();
    super.dispose();
  }
}
