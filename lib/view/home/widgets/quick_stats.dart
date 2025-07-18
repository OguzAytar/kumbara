import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/currency_constants.dart';
import '../../../core/providers/settings_provider.dart';

class QuickStats extends StatelessWidget {
  final Map<String, dynamic>? stats;

  const QuickStats({super.key, this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return const SizedBox.shrink();
    }

    final totalSavings = stats!['totalSavings'] ?? 0;
    final activeSavings = stats!['activeSavings'] ?? 0;
    final totalAmount = stats!['totalAmount'] ?? 0.0;
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final currencySymbol = CurrencyConstants.getCurrencySymbol(settingsProvider.currency);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.summaryStatistics,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineSmall?.color),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem(AppLocalizations.of(context)!.totalSaving, totalSavings.toString(), Icons.savings, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatItem(AppLocalizations.of(context)!.activeTarget, activeSavings.toString(), Icons.flag, Colors.green)),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatItem(
            AppLocalizations.of(context)!.totalAmount,
            '$currencySymbol${totalAmount.toStringAsFixed(2)}',
            Icons.account_balance_wallet,
            Colors.purple,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color, {bool isFullWidth = false}) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: isFullWidth
            ? Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
