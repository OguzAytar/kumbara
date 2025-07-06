import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/functions/firebase_analytics_helper.dart';
import '../../core/providers/saving_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../models/saving.dart';
import '../savings/savings_list_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/add_saving_bottom_sheet.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/quick_stats.dart';
import 'widgets/recent_savings_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Log screen view
    FirebaseAnalyticsHelper.logScreenView(screenName: 'Home', screenClass: 'HomeScreen');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final savingProvider = context.read<SavingProvider>();
    await savingProvider.loadSavings();
    await savingProvider.loadDashboardStats();
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Consumer<SavingProvider>(
        builder: (context, savingProvider, child) {
          if (savingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (savingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text(savingProvider.error!, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      savingProvider.clearError();
                      _refreshData();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hoş geldin mesajı
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),

                  // Hızlı istatistikler
                  QuickStats(stats: savingProvider.dashboardStats),
                  const SizedBox(height: 24),

                  // Ana dashboard kartları
                  _buildDashboardCards(savingProvider),
                  const SizedBox(height: 24),

                  // Son birikimler
                  _buildRecentSavingsSection(savingProvider),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddSavingBottomSheet(),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.welcomeMessage,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.welcomeSubtitle, style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.9))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardCards(SavingProvider savingProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: AppLocalizations.of(context)!.nearestTarget,
                subtitle: _getNearestTargetText(savingProvider),
                icon: Icons.access_time,
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate to nearest target detail
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DashboardCard(
                title: AppLocalizations.of(context)!.mostProgress,
                subtitle: _getMostProgressText(savingProvider),
                icon: Icons.trending_up,
                color: Colors.green,
                onTap: () {
                  // TODO: Navigate to most progressed saving
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSavingsSection(SavingProvider savingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.mySavings, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SavingsListScreen()));
              },
              child: Text(AppLocalizations.of(context)!.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RecentSavingsList(savings: savingProvider.activeSavings.take(3).toList()),
      ],
    );
  }

  String _getNearestTargetText(SavingProvider savingProvider) {
    final stats = savingProvider.dashboardStats;
    if (stats == null || stats['nearestTarget'] == null) {
      return AppLocalizations.of(context)!.targetNotFound;
    }

    final nearestTarget = stats['nearestTarget'] as Saving;
    final remainingDays = nearestTarget.remainingDays;

    if (remainingDays <= 0) {
      return AppLocalizations.of(context)!.expired;
    } else if (remainingDays == 1) {
      return AppLocalizations.of(context)!.oneDayLeft;
    } else {
      return AppLocalizations.of(context)!.daysLeft(remainingDays);
    }
  }

  String _getMostProgressText(SavingProvider savingProvider) {
    final activeSavings = savingProvider.activeSavings;
    if (activeSavings.isEmpty) {
      return AppLocalizations.of(context)!.savingNotFound;
    }

    final mostProgressed = activeSavings.reduce((a, b) => a.completionPercentage > b.completionPercentage ? a : b);

    return '%${mostProgressed.completionPercentage.toInt()}';
  }
}
