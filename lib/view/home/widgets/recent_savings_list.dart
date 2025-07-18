import 'package:flutter/material.dart';
import 'package:kumbara/core/enums/saving_enum.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:kumbara/view/home/widgets/add_saving_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/currency_constants.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../models/saving.dart';

class RecentSavingsList extends StatelessWidget {
  final List<Saving> savings;

  const RecentSavingsList({super.key, required this.savings});

  @override
  Widget build(BuildContext context) {
    if (savings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(Icons.savings_outlined, size: 64, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noSavingsGoal,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.createFirstGoal,
              style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: savings.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
        itemBuilder: (context, index) {
          final saving = savings[index];
          return _buildSavingTile(context, saving);
        },
      ),
    );
  }

  Widget _buildSavingTile(BuildContext context, Saving saving) {
    final progressPercentage = saving.completionPercentage;
    final remainingDays = saving.remainingDays;
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final currencySymbol = CurrencyConstants.getCurrencySymbol(settingsProvider.currency);

    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: _getStatusColor(saving.status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(_getStatusIcon(saving.status), color: _getStatusColor(saving.status), size: 24),
      ),
      title: Text(
        saving.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleMedium?.color),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            '$currencySymbol${saving.currentAmount.toStringAsFixed(2)} / $currencySymbol${saving.targetAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(saving.status)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '%${progressPercentage.toInt()}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _getStatusColor(saving.status)),
              ),
              Text(
                remainingDays > 0
                    ? (remainingDays == 1 ? AppLocalizations.of(context)!.oneDayLeft : AppLocalizations.of(context)!.daysLeft(remainingDays))
                    : AppLocalizations.of(context)!.expired,
                style: TextStyle(
                  fontSize: 12,
                  color: remainingDays > 0 ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) : Colors.red.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        // Birikim detaylarını göster
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AddSavingBottomSheet(saving: saving),
        );
      },
    );
  }

  Color _getStatusColor(SavingStatus status) {
    switch (status) {
      case SavingStatus.active:
        return Colors.blue;
      case SavingStatus.completed:
        return Colors.green;
      case SavingStatus.paused:
        return Colors.orange;
      case SavingStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(SavingStatus status) {
    switch (status) {
      case SavingStatus.active:
        return Icons.trending_up;
      case SavingStatus.completed:
        return Icons.check_circle;
      case SavingStatus.paused:
        return Icons.pause_circle;
      case SavingStatus.cancelled:
        return Icons.cancel;
    }
  }
}
