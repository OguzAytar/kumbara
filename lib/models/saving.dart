import 'package:kumbara/core/enums/saving_enum.dart';

class Saving {
  final int? id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final SavingFrequency frequency;
  final SavingStatus status;
  final String? iconName;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  Saving({
    this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    required this.targetDate,
    required this.frequency,
    this.status = SavingStatus.active,
    this.iconName,
    this.color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Günlük, haftalık veya aylık biriktirme miktarını hesapla
  double get requiredAmountPerPeriod {
    final remainingAmount = targetAmount - currentAmount;
    final remainingDays = targetDate.difference(DateTime.now()).inDays;

    if (remainingDays <= 0) return 0;

    switch (frequency) {
      case SavingFrequency.daily:
        return remainingAmount / remainingDays;
      case SavingFrequency.weekly:
        final remainingWeeks = (remainingDays / 7).ceil();
        return remainingWeeks > 0 ? remainingAmount / remainingWeeks : 0;
      case SavingFrequency.monthly:
        final remainingMonths =
            ((targetDate.year - DateTime.now().year) * 12 +
            targetDate.month -
            DateTime.now().month);
        return remainingMonths > 0 ? remainingAmount / remainingMonths : 0;
    }
  }

  // Hedef tamamlanma yüzdesi
  double get completionPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount * 100).clamp(0, 100);
  }

  // Kalan gün sayısı
  int get remainingDays {
    return targetDate
        .difference(DateTime.now())
        .inDays
        .clamp(0, double.infinity)
        .toInt();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.millisecondsSinceEpoch,
      'targetDate': targetDate.millisecondsSinceEpoch,
      'frequency': frequency.name,
      'status': status.name,
      'iconName': iconName,
      'color': color,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Saving.fromMap(Map<String, dynamic> map) {
    return Saving(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0.0).toDouble(),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      targetDate: DateTime.fromMillisecondsSinceEpoch(map['targetDate']),
      frequency: SavingFrequency.values.firstWhere(
        (e) => e.name == map['frequency'],
        orElse: () => SavingFrequency.daily,
      ),
      status: SavingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SavingStatus.active,
      ),
      iconName: map['iconName'],
      color: map['color'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  Saving copyWith({
    int? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? targetDate,
    SavingFrequency? frequency,
    SavingStatus? status,
    String? iconName,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Saving(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
