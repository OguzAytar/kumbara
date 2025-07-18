import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../services/ads_service.dart';

/// AdMob banner reklamını gösteren widget
class AdBannerWidget extends StatefulWidget {
  final String widgetId;

  const AdBannerWidget({super.key, required this.widgetId});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    // initState içinde context.read kullanımı güvenli değil
    // Bu yüzden post-frame callback kullanıyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerAd();
    });
  }

  void _loadBannerAd() async {
    if (!mounted) return;

    final adsService = context.read<AdsService>();
    if (!adsService.isPremiumUser && adsService.isInitialized) {
      final ad = await adsService.createBannerAd(widget.widgetId);
      if (mounted) {
        setState(() {
          _bannerAd = ad;
        });
      }
    }
  }

  @override
  void dispose() {
    context.read<AdsService>().disposeBannerAd(widget.widgetId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsService>(
      builder: (context, adsService, child) {
        // Premium kullanıcı ise reklam gösterme
        if (adsService.isPremiumUser) {
          return const SizedBox.shrink();
        }

        // Reklam yüklenmemişse veya mevcut değilse boş widget göster
        if (_bannerAd == null) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 60, // Banner reklam yüksekliği

          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }
}

/// Uygulama başlığı altında banner reklam gösteren widget
class HeaderAdBannerWidget extends StatefulWidget {
  const HeaderAdBannerWidget({super.key});

  @override
  State<HeaderAdBannerWidget> createState() => _HeaderAdBannerWidgetState();
}

class _HeaderAdBannerWidgetState extends State<HeaderAdBannerWidget> {
  BannerAd? _bannerAd;
  final String _widgetId = 'header_banner';

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() async {
    final adsService = context.read<AdsService>();
    if (!adsService.isPremiumUser && adsService.isInitialized) {
      final ad = await adsService.createBannerAd(_widgetId);
      if (mounted) {
        setState(() {
          _bannerAd = ad;
        });
      }
    }
  }

  @override
  void dispose() {
    context.read<AdsService>().disposeBannerAd(_widgetId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsService>(
      builder: (context, adsService, child) {
        // Premium kullanıcı ise reklam gösterme
        if (adsService.isPremiumUser) {
          return const SizedBox.shrink();
        }

        // Reklam yüklenmemişse veya mevcut değilse boş widget göster
        if (_bannerAd == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        );
      },
    );
  }
}

/// Sayfa altında banner reklam gösteren widget
class BottomAdBannerWidget extends StatefulWidget {
  const BottomAdBannerWidget({super.key});

  @override
  State<BottomAdBannerWidget> createState() => _BottomAdBannerWidgetState();
}

class _BottomAdBannerWidgetState extends State<BottomAdBannerWidget> {
  BannerAd? _bannerAd;
  final String _widgetId = 'bottom_banner';

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() async {
    final adsService = context.read<AdsService>();
    if (!adsService.isPremiumUser && adsService.isInitialized) {
      final ad = await adsService.createBannerAd(_widgetId);
      if (mounted) {
        setState(() {
          _bannerAd = ad;
        });
      }
    }
  }

  @override
  void dispose() {
    context.read<AdsService>().disposeBannerAd(_widgetId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsService>(
      builder: (context, adsService, child) {
        // Premium kullanıcı ise reklam gösterme
        if (adsService.isPremiumUser) {
          return const SizedBox.shrink();
        }

        // Reklam yüklenmemişse veya mevcut değilse boş widget göster
        if (_bannerAd == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: SafeArea(
            child: SizedBox(height: 60, child: AdWidget(ad: _bannerAd!)),
          ),
        );
      },
    );
  }
}
