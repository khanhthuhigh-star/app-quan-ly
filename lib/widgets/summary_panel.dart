import 'package:flutter/material.dart';

import '../core/money.dart';
import '../models/summary.dart';

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({super.key, required this.summary});
  final Summary summary;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _amountRow('Tổng thu', summary.income, Colors.teal),
            const Divider(),
            _amountRow('Tổng chi', summary.expense, Colors.red),
            const Divider(),
            _amountRow('Còn lại', summary.balance,
                Theme.of(context).colorScheme.primary,
                bold: true),
          ]),
        ),
      );

  Widget _amountRow(String label, int value, Color color,
          {bool bold = false}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        Text(Money.format(value),
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: bold ? 20 : 16)),
      ]);
}
