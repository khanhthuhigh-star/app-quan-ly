import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/date_range.dart';
import '../data/app_database.dart';
import '../models/expense_transaction.dart';
import '../models/summary.dart';
import '../models/transaction_type.dart';
import '../widgets/summary_panel.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Period _period = Period.day;
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final range = DateRange.forPeriod(_date, _period);
    return Scaffold(
      appBar: AppBar(title: const Text('Sổ thu chi')),
      body: FutureBuilder<Summary>(
        future: AppDatabase.instance.summary(range.from, range.to),
        builder: (_, summarySnapshot) {
          final summary = summarySnapshot.data ?? const Summary(0, 0);
          return FutureBuilder<List<ExpenseTransaction>>(
            future: AppDatabase.instance
                .transactions(from: range.from, to: range.to),
            builder: (_, transactionSnapshot) => RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView(padding: const EdgeInsets.all(16), children: [
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
                const SizedBox(height: 12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => _shift(-1),
                          icon: const Icon(Icons.chevron_left)),
                      Text(_rangeText(range),
                          style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                          onPressed: () => _shift(1),
                          icon: const Icon(Icons.chevron_right)),
                    ]),
                const SizedBox(height: 8),
                SummaryPanel(summary: summary),
                const SizedBox(height: 24),
                Text('Giao dịch gần đây',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if ((transactionSnapshot.data ?? []).isEmpty)
                  const Padding(
                      padding: EdgeInsets.all(28),
                      child: Center(
                          child: Text('Chưa có giao dịch trong khoảng này.')))
                else
                  ...transactionSnapshot.data!
                      .take(6)
                      .map((item) => TransactionTile(item: item)),
              ]),
            ),
          );
        },
      ),
    );
  }

  void _shift(int direction) =>
      setState(() => _date = DateRange.shift(_date, _period, direction));

  String _rangeText(DateRange range) {
    final format = DateFormat('dd/MM/yyyy');
    return _period == Period.day
        ? format.format(range.from)
        : '${format.format(range.from)} – ${format.format(range.to.subtract(const Duration(days: 1)))}';
  }
}
