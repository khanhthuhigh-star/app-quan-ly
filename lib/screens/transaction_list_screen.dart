import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../models/expense_transaction.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_form_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});
  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Giao dịch')),
        body: FutureBuilder<List<ExpenseTransaction>>(
          future: AppDatabase.instance.transactions(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!;
            if (items.isEmpty) {
              return const Center(
                  child: Text(
                      'Nhấn “Giao dịch” để thêm khoản thu hoặc chi đầu tiên.'));
            }
            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) => TransactionTile(
                  item: items[index],
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                TransactionFormScreen(editing: items[index])));
                    setState(() {});
                  },
                ),
              ),
            );
          },
        ),
      );
}
