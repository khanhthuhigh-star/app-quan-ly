import 'package:flutter/material.dart';

import '../core/date_range.dart';
import '../core/money.dart';
import '../data/app_database.dart';
import '../models/expense_transaction.dart';
import '../models/summary.dart';
import '../models/transaction_type.dart';
import '../widgets/summary_panel.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Period _period = Period.month;
  final DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final range = DateRange.forPeriod(_date, _period);
    return Scaffold(
      appBar: AppBar(title: const Text('Báo cáo')),
      body: FutureBuilder<List<ExpenseTransaction>>(
        future:
            AppDatabase.instance.transactions(from: range.from, to: range.to),
        builder: (_, snapshot) {
          final items = snapshot.data ?? [];
          final summary = Summary(
            items
                .where((item) => item.type == TransactionType.income)
                .fold(0, (value, item) => value + item.amount),
            items
                .where((item) => item.type == TransactionType.expense)
                .fold(0, (value, item) => value + item.amount),
          );
          final grouped = <String, int>{};
          for (final item
              in items.where((item) => item.type == TransactionType.expense)) {
            grouped.update(
                item.categoryName ?? 'Khác', (value) => value + item.amount,
                ifAbsent: () => item.amount);
          }
          return ListView(padding: const EdgeInsets.all(16), children: [
            SegmentedButton<Period>(
              segments: const [
                ButtonSegment(value: Period.day, label: Text('Ngày')),
                ButtonSegment(value: Period.week, label: Text('Tuần')),
                ButtonSegment(value: Period.month, label: Text('Tháng')),
              ],
              selected: {_period},
              onSelectionChanged: (value) =>
                  setState(() => _period = value.first),
            ),
            const SizedBox(height: 16),
            SummaryPanel(summary: summary),
            const SizedBox(height: 24),
            Text('Chi theo danh mục',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (grouped.isEmpty)
              const Text('Chưa có khoản chi trong khoảng này.')
            else
              ...grouped.entries.map((entry) {
                final share =
                    summary.expense == 0 ? 0.0 : entry.value / summary.expense;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text(Money.format(entry.value))
                            ]),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(value: share),
                      ]),
                );
              }),
          ]);
        },
      ),
    );
  }
}
