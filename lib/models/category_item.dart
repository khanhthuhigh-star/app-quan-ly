import 'transaction_type.dart';

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.name,
    required this.type,
    this.imagePath,
  });

  final int? id;
  final String name;
  final TransactionType type;
  final String? imagePath;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'image_path': imagePath,
      };

  factory CategoryItem.fromMap(Map<String, Object?> map) => CategoryItem(
        id: map['id'] as int,
        name: map['name'] as String,
        type: TransactionType.values.byName(map['type'] as String),
        imagePath: map['image_path'] as String?,
      );
}
