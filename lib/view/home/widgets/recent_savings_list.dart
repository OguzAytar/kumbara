import 'package:flutter/material.dart';
import 'package:kumbara/core/enums/saving_enum.dart';

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(Icons.savings_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Henüz birikim hedefi yok',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'İlk birikim hedefinizi oluşturmak için + butonuna tıklayın',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: savings.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
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

    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: _getStatusColor(saving.status).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(_getStatusIcon(saving.status), color: _getStatusColor(saving.status), size: 24),
      ),
      title: Text(
        saving.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            '₺${saving.currentAmount.toStringAsFixed(2)} / ₺${saving.targetAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Colors.grey.shade200,
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
                remainingDays > 0 ? '$remainingDays gün kaldı' : 'Süresi dolmuş',
                style: TextStyle(fontSize: 12, color: remainingDays > 0 ? Colors.grey.shade600 : Colors.red.shade600),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to saving detail
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${saving.title} detay sayfası yakında eklenecek!')));
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
