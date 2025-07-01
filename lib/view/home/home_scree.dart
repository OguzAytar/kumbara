import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/saving_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../models/saving.dart';
import '../settings/settings_screen.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/quick_stats.dart';
import 'widgets/recent_savings_list.dart';

class HomeScree extends StatefulWidget {
  const HomeScree({super.key});

  @override
  State<HomeScree> createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScree> {
  @override
  void initState() {
    super.initState();
    _loadData();
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Kumbara',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
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
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    savingProvider.error!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      savingProvider.clearError();
                      _refreshData();
                    },
                    child: const Text('Tekrar Dene'),
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
          // TODO: Add new saving screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yeni birikim ekleme özelliği yakında eklenecek!'),
            ),
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
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoş Geldiniz! 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hayallerinize bir adım daha yaklaşın',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
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
                title: 'En Yakın Hedef',
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
                title: 'En Çok İlerleme',
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
            const Text(
              'Birikimlerim',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all savings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tüm birikimler sayfası yakında eklenecek!'),
                  ),
                );
              },
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RecentSavingsList(
          savings: savingProvider.activeSavings.take(3).toList(),
        ),
      ],
    );
  }

  String _getNearestTargetText(SavingProvider savingProvider) {
    final stats = savingProvider.dashboardStats;
    if (stats == null || stats['nearestTarget'] == null) {
      return 'Hedef bulunamadı';
    }

    final nearestTarget = stats['nearestTarget'] as Saving;
    final remainingDays = nearestTarget.remainingDays;

    if (remainingDays <= 0) {
      return 'Süresi dolmuş';
    } else if (remainingDays == 1) {
      return '1 gün kaldı';
    } else {
      return '$remainingDays gün kaldı';
    }
  }

  String _getMostProgressText(SavingProvider savingProvider) {
    final activeSavings = savingProvider.activeSavings;
    if (activeSavings.isEmpty) {
      return 'Birikim bulunamadı';
    }

    final mostProgressed = activeSavings.reduce(
      (a, b) => a.completionPercentage > b.completionPercentage ? a : b,
    );

    return '%${mostProgressed.completionPercentage.toInt()}';
  }
}
