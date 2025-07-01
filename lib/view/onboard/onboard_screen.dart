import 'package:flutter/material.dart';
import 'package:kumbara/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/providers/settings_provider.dart';
import '../home/home_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;
  bool _isRequestingPermission = false;

  final List<OnboardData> _onboardData = [
    OnboardData(
      icon: Icons.savings,
      title: 'Birikimlerinizi Takip Edin',
      description: 'Hedeflerinize ulaşmak için biriktirmelerinizi kolayca takip edin ve yönetin.',
      color: Color(0xFF2E7D32),
    ),
    OnboardData(
      icon: Icons.timeline,
      title: 'İlerlemenizi Görün',
      description: 'Grafikler ve raporlarla birikimleririnizin ilerleyişini detaylı bir şekilde analiz edin.',
      color: Color(0xFF1976D2),
    ),
    OnboardData(
      icon: Icons.notifications_active,
      title: 'Hatırlatmalar Alın',
      description: 'Düzenli birikim yapmayı unutmamak için bildirimlerden yararlanın.',
      color: Color(0xFFFF6F00),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _isRequestingPermission = true;
    });

    try {
      final granted = await NotificationService().requestPermission();

      if (granted) {
        await context.read<SettingsProvider>().setNotificationsEnabled(true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bildirim izni verildi!'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bildirim izni reddedildi. Ayarlardan açabilirsiniz.'), backgroundColor: Colors.orange));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bildirim izni alınırken hata oluştu: $e'), backgroundColor: Colors.red));
    }

    setState(() {
      _isRequestingPermission = false;
    });
  }

  Future<void> _finishOnboarding() async {
    await context.read<SettingsProvider>().markOnboardingComplete();

    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScree()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0) TextButton(onPressed: _previousPage, child: const Text('Geri')) else const SizedBox(),
                  TextButton(onPressed: _finishOnboarding, child: const Text('Geç')),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  return _buildOnboardPage(_onboardData[index], index);
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalPages,
                    effect: WormEffect(
                      activeDotColor: Theme.of(context).primaryColor,
                      dotColor: Colors.grey.shade300,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isRequestingPermission
                          ? null
                          : () {
                              if (_currentPage == _totalPages - 1) {
                                _requestNotificationPermission();
                              } else {
                                _nextPage();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _onboardData[_currentPage].color,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isRequestingPermission
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(
                              _currentPage == _totalPages - 1 ? 'Bildirimlere İzin Ver' : 'Devam Et',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (_currentPage == _totalPages - 1) TextButton(onPressed: _finishOnboarding, child: const Text('Bildirimsiz Devam Et')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardPage(OnboardData data, int index) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: data.color.withOpacity(0.1), borderRadius: BorderRadius.circular(60)),
            child: Icon(data.icon, size: 60, color: data.color),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardData({required this.icon, required this.title, required this.description, required this.color});
}
