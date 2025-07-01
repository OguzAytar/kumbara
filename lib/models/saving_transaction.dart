class SavingTransaction {
  final int? id;
  final int savingId;
  final double amount;
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  SavingTransaction({this.id, required this.savingId, required this.amount, required this.date, this.note, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savingId': savingId,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SavingTransaction.fromMap(Map<String, dynamic> map) {
    return SavingTransaction(
      id: map['id'],
      savingId: map['savingId'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      note: map['note'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  SavingTransaction copyWith({int? id, int? savingId, double? amount, DateTime? date, String? note, DateTime? createdAt}) {
    return SavingTransaction(
      id: id ?? this.id,
      savingId: savingId ?? this.savingId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
