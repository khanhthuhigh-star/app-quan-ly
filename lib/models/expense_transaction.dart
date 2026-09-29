import 'transaction_type.dart';

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.occurredAt,
    this.note = '',
    this.imagePath,
    this.categoryName,
  });

  final int? id;
  final TransactionType type;
  final int categoryId;
  final int amount;
  final DateTime occurredAt;
  final String note;
  final String? imagePath;
  final String? categoryName;

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type.name,
        'category_id': categoryId,
        'amount': amount,
        'note': note,
        'image_path': imagePath,
        'occurred_at': occurredAt.toIso8601String(),
      };

  factory ExpenseTransaction.fromMap(Map<String, Object?> map) =>
      ExpenseTransaction(
        id: map['id'] as int,
        type: TransactionType.values.byName(map['type'] as String),
        categoryId: map['category_id'] as int,
        amount: map['amount'] as int,
        note: (map['note'] as String?) ?? '',
        imagePath: map['image_path'] as String?,
        occurredAt: DateTime.parse(map['occurred_at'] as String),
        categoryName: map['category_name'] as String?,
      );
}
