import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/enums/saving_enum.dart';
import '../../core/functions/firebase_analytics_helper.dart';
import '../../core/providers/saving_provider.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../models/saving.dart';
import 'widgets/saving_card.dart';

class SavingsListScreen extends StatefulWidget {
  const SavingsListScreen({super.key});

  @override
  State<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends State<SavingsListScreen> {
  String _searchQuery = '';
  SavingStatus? _filterStatus;
  SortOption _sortOption = SortOption.newest;
  bool _isSearchVisible = false;
  bool _isStatsExpanded = false;

  @override
  void initState() {
    super.initState();
    // Log screen view
    FirebaseAnalyticsHelper.logScreenView(screenName: 'SavingsList', screenClass: 'SavingsListScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.mySavings,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchQuery = '';
                }
              });
            },
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (SortOption option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: SortOption.newest, child: Text(AppLocalizations.of(context)!.sortByNewest)),
              PopupMenuItem(value: SortOption.oldest, child: Text(AppLocalizations.of(context)!.sortByOldest)),
              PopupMenuItem(value: SortOption.progress, child: Text(AppLocalizations.of(context)!.sortByProgress)),
              PopupMenuItem(value: SortOption.amount, child: Text(AppLocalizations.of(context)!.sortByAmount)),
            ],
          ),
          PopupMenuButton<SavingStatus?>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (SavingStatus? status) {
              setState(() {
                _filterStatus = status;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: null, child: Text(AppLocalizations.of(context)!.allSavings)),
              PopupMenuItem(value: SavingStatus.active, child: Text(AppLocalizations.of(context)!.activeSavings)),
              PopupMenuItem(value: SavingStatus.completed, child: Text(AppLocalizations.of(context)!.completedSavings)),
              PopupMenuItem(value: SavingStatus.paused, child: Text(AppLocalizations.of(context)!.pausedSavings)),
            ],
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
                      savingProvider.loadSavings();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          final filteredSavings = _getFilteredAndSortedSavings(savingProvider.savings);

          return Column(
            children: [
              // Arama çubuğu
              if (_isSearchVisible)
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchSavings,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),

              // İstatistikler
              _buildStatsSection(savingProvider),

              // Birikimler listesi
              Expanded(
                child: filteredSavings.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await savingProvider.loadSavings();
                          await savingProvider.loadDashboardStats();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredSavings.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SavingCard(
                                saving: filteredSavings[index],
                                onTap: () {
                                  // TODO: Navigate to saving detail
                                  CustomSnackBar.showInfo(context, message: AppLocalizations.of(context)!.savingDetailComingSoon);
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(SavingProvider savingProvider) {
    final stats = _calculateStats(savingProvider.savings);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ExpansionTile(
        initiallyExpanded: _isStatsExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isStatsExpanded = expanded;
          });
        },
        leading: const Icon(Icons.analytics_outlined, color: Colors.blue),
        title: Text(AppLocalizations.of(context)!.savingsOverview, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(AppLocalizations.of(context)!.totalSavingsCount(stats['totalCount']), style: TextStyle(color: Colors.grey.shade600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        AppLocalizations.of(context)!.totalAmount,
                        '₺${stats['totalAmount'].toStringAsFixed(2)}',
                        Icons.account_balance_wallet,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        AppLocalizations.of(context)!.totalTarget,
                        '₺${stats['totalTarget'].toStringAsFixed(2)}',
                        Icons.flag,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        AppLocalizations.of(context)!.activeSavings,
                        '${stats['activeCount']}',
                        Icons.play_circle_outline,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        AppLocalizations.of(context)!.completedSavings,
                        '${stats['completedCount']}',
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatItem(
                  AppLocalizations.of(context)!.averageProgress,
                  '${stats['averageProgress'].toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.savings_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.noSavingsFound, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noSavingsFoundDesc,
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Saving> _getFilteredAndSortedSavings(List<Saving> savings) {
    List<Saving> filtered = savings;

    // Filtre uygula
    if (_filterStatus != null) {
      filtered = filtered.where((saving) => saving.status == _filterStatus).toList();
    }

    // Arama uygula
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (saving) =>
                saving.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                saving.description.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Sıralama uygula
    switch (_sortOption) {
      case SortOption.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.progress:
        filtered.sort((a, b) => b.completionPercentage.compareTo(a.completionPercentage));
        break;
      case SortOption.amount:
        filtered.sort((a, b) => b.currentAmount.compareTo(a.currentAmount));
        break;
    }

    return filtered;
  }

  Map<String, dynamic> _calculateStats(List<Saving> savings) {
    if (savings.isEmpty) {
      return {'totalCount': 0, 'totalAmount': 0.0, 'totalTarget': 0.0, 'activeCount': 0, 'completedCount': 0, 'averageProgress': 0.0};
    }

    final totalAmount = savings.fold(0.0, (sum, saving) => sum + saving.currentAmount);
    final totalTarget = savings.fold(0.0, (sum, saving) => sum + saving.targetAmount);
    final activeCount = savings.where((s) => s.status == SavingStatus.active).length;
    final completedCount = savings.where((s) => s.status == SavingStatus.completed).length;
    final averageProgress = savings.fold(0.0, (sum, saving) => sum + saving.completionPercentage) / savings.length;

    return {
      'totalCount': savings.length,
      'totalAmount': totalAmount,
      'totalTarget': totalTarget,
      'activeCount': activeCount,
      'completedCount': completedCount,
      'averageProgress': averageProgress,
    };
  }
}

enum SortOption { newest, oldest, progress, amount }
