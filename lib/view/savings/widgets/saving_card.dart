import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';

import '../../../core/enums/saving_enum.dart';
import '../../../models/saving.dart';

class SavingCard extends StatelessWidget {
  final Saving saving;
  final VoidCallback? onTap;

  const SavingCard({super.key, required this.saving, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve durum
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      saving.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),

              if (saving.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  saving.description,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 16),

              // İlerleme çubuğu
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₺${saving.currentAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.lightGreen : Colors.green),
                      ),
                      if (saving.targetAmount > 0)
                        Text(
                          '₺${saving.targetAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (saving.targetAmount > 0) ...[
                    LinearProgressIndicator(
                      value: saving.completionPercentage / 100,
                      backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(saving.completionPercentage)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${saving.completionPercentage.toStringAsFixed(1)}% ${AppLocalizations.of(context)!.completed}',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // Alt bilgiler
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${saving.startDate.day}/${saving.startDate.month}/${saving.startDate.year}',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                    ),
                  ),
                  if (saving.remainingDays > 0) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.daysLeft(saving.remainingDays),
                        style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (saving.status) {
      case SavingStatus.active:
        chipColor = Colors.green;
        statusText = 'Aktif';
        break;
      case SavingStatus.completed:
        chipColor = Colors.blue;
        statusText = 'Tamamlandı';
        break;
      case SavingStatus.paused:
        chipColor = Colors.orange;
        statusText = 'Duraklatıldı';
        break;
      case SavingStatus.cancelled:
        chipColor = Colors.red;
        statusText = 'İptal Edildi';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: chipColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.lightGreen;
    if (percentage >= 50) return Colors.orange;
    if (percentage >= 30) return Colors.amber;
    return Colors.red;
  }
}
