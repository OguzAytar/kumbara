import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:kumbara/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/functions/firebase_analytics_helper.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/widgets/custom_snackbar.dart';
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<OnboardData> _getOnboardData(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      OnboardData(
        icon: Icons.savings,
        title: localizations.trackYourSavings,
        description: localizations.trackYourSavingsDesc,
        color: const Color(0xFF2E7D32),
      ),
      OnboardData(
        icon: Icons.timeline,
        title: localizations.seeYourProgress,
        description: localizations.seeYourProgressDesc,
        color: const Color(0xFF1976D2),
      ),
      OnboardData(
        icon: Icons.notifications_active,
        title: localizations.getReminders,
        description: localizations.getRemindersDesc,
        color: const Color(0xFFFF6F00),
      ),
    ];
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

      // Log onboarding step completion
      FirebaseAnalyticsHelper.logOnboardingStepCompleted(
        stepNumber: _currentPage + 2, // Next step
        stepName: 'step_${_currentPage + 2}',
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<bool> _requestNotificationPermission() async {
    setState(() {
      _isRequestingPermission = true;
    });

    try {
      final granted = await NotificationService().requestPermission();
      final localizations = AppLocalizations.of(context)!;

      // Log notification permission request
      await FirebaseAnalyticsHelper.logNotificationPermissionRequested(granted: granted, source: 'onboarding');

      if (granted) {
        await context.read<SettingsProvider>().setNotificationsEnabled(true);
        CustomSnackBar.showSuccess(context, message: localizations.notificationPermissionGranted);
        return true;
      } else {
        CustomSnackBar.showWarning(
          context,
          message: localizations.notificationPermissionDenied,
          actionLabel: localizations.settings,
          onActionPressed: () {
            // TODO: Ayarlar sayfasına yönlendirme
          },
        );
        return false;
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      CustomSnackBar.showError(context, message: localizations.notificationPermissionError(e.toString()));

      // Log error
      await FirebaseAnalyticsHelper.logError(errorName: 'notification_permission_error', errorMessage: e.toString());

      return false;
    } finally {
      setState(() {
        _isRequestingPermission = false;
      });
    }
  }

  Future<void> _finishOnboarding() async {
    await context.read<SettingsProvider>().markOnboardingComplete();

    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final onboardData = _getOnboardData(context);

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
                  if (_currentPage > 0) TextButton(onPressed: _previousPage, child: Text(localizations.back)) else const SizedBox(),
                  TextButton(onPressed: _finishOnboarding, child: Text(localizations.skip)),
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
                  return _buildOnboardPage(onboardData[index], index);
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
                          : () async {
                              if (_currentPage == _totalPages - 1) {
                                final granded = await _requestNotificationPermission();
                                if (granded) {
                                  _nextPage();
                                }
                              } else {
                                _nextPage();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: onboardData[_currentPage].color,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isRequestingPermission
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(
                              _currentPage == _totalPages - 1 ? localizations.allowNotifications : localizations.continueButton,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (_currentPage == _totalPages - 1)
                    TextButton(onPressed: _finishOnboarding, child: Text(localizations.continueWithoutNotifications)),
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
            decoration: BoxDecoration(color: data.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(60)),
            child: Icon(data.icon, size: 60, color: data.color),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(data.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5), textAlign: TextAlign.center),
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
