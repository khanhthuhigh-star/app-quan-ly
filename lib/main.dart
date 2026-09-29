import 'package:flutter/widgets.dart';

import 'app/expense_app.dart';
import 'data/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;
  runApp(const ExpenseApp());
}
