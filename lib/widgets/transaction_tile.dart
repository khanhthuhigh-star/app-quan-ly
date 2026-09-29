import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/money.dart';
import '../models/expense_transaction.dart';
import '../models/transaction_type.dart';
import 'thumbnail.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.item, this.onTap});
  final ExpenseTransaction item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap,
        leading: Thumbnail(
          path: item.imagePath,
          icon: item.type == TransactionType.income
              ? Icons.south_west
              : Icons.north_east,
          color: item.type.color,
        ),
        title: Text(item.categoryName ?? 'Danh mục'),
        subtitle: Text(
          '${DateFormat('dd/MM/yyyy HH:mm').format(item.occurredAt)}${item.note.isEmpty ? '' : ' • ${item.note}'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${item.type == TransactionType.income ? '+' : '-'}${Money.format(item.amount)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: item.type.color),
        ),
      );
}
