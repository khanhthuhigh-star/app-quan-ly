import 'package:flutter/material.dart';

import 'category_list_screen.dart';
import 'dashboard_screen.dart';
import 'report_screen.dart';
import 'transaction_form_screen.dart';
import 'transaction_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _revision = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: switch (_index) {
          0 => DashboardScreen(key: ValueKey('dashboard-$_revision')),
          1 => TransactionListScreen(key: ValueKey('transactions-$_revision')),
          2 => CategoryListScreen(key: ValueKey('categories-$_revision')),
          _ => ReportScreen(key: ValueKey('reports-$_revision')),
        },
        floatingActionButton: _index == 1
            ? FloatingActionButton.extended(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TransactionFormScreen()));
                  setState(() => _revision++);
                },
                icon: const Icon(Icons.add),
                label: const Text('Giao dịch'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() {
            _index = value;
            _revision++;
          }),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Tổng quan'),
            NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Giao dịch'),
            NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'Danh mục'),
            NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Báo cáo'),
          ],
        ),
      );
}
