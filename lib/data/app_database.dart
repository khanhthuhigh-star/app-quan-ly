import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category_item.dart';
import '../models/expense_transaction.dart';
import '../models/summary.dart';
import '../models/transaction_type.dart';
import 'image_store.dart';

class AppDatabase {
  AppDatabase._();
  static final instance = AppDatabase._();
  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final directory = await getApplicationDocumentsDirectory();
    return openDatabase(path.join(directory.path, 'expense_manager.db'),
        version: 1, onCreate: (db, _) async {
      await db.execute('''CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
        type TEXT NOT NULL, image_path TEXT)''');
      await db.execute('''CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL,
        category_id INTEGER NOT NULL, amount INTEGER NOT NULL, note TEXT,
        image_path TEXT, occurred_at TEXT NOT NULL,
        FOREIGN KEY(category_id) REFERENCES categories(id))''');
      for (final category in const [
        CategoryItem(id: null, name: 'Lương', type: TransactionType.income),
        CategoryItem(id: null, name: 'Thưởng', type: TransactionType.income),
        CategoryItem(id: null, name: 'Ăn uống', type: TransactionType.expense),
        CategoryItem(
            id: null, name: 'Di chuyển', type: TransactionType.expense),
        CategoryItem(id: null, name: 'Hóa đơn', type: TransactionType.expense),
        CategoryItem(id: null, name: 'Mua sắm', type: TransactionType.expense),
      ]) {
        await db.insert('categories', category.toMap()..remove('id'));
      }
    });
  }

  Future<List<CategoryItem>> categories([TransactionType? type]) async {
    final rows = await (await database).query('categories',
        where: type == null ? null : 'type = ?',
        whereArgs: type == null ? null : [type.name],
        orderBy: 'name');
    return rows.map(CategoryItem.fromMap).toList();
  }

  Future<int> saveCategory(CategoryItem item) async {
    final db = await database;
    final data = item.toMap()..remove('id');
    if (item.id == null) return db.insert('categories', data);
    final old = await db.query('categories',
        columns: ['image_path'],
        where: 'id = ?',
        whereArgs: [item.id],
        limit: 1);
    await db.update('categories', data, where: 'id = ?', whereArgs: [item.id]);
    await _deleteReplacedImage(old, item.imagePath);
    return item.id!;
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM transactions WHERE category_id = ?', [id])) ??
        0;
    if (count > 0) {
      throw StateError('Không thể xóa danh mục đang có giao dịch.');
    }
    final old = await db.query('categories',
        columns: ['image_path'], where: 'id = ?', whereArgs: [id], limit: 1);
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    if (old.isNotEmpty && old.first['image_path'] != null) {
      await ImageStore.delete(old.first['image_path'] as String);
    }
  }

  Future<List<ExpenseTransaction>> transactions(
      {DateTime? from, DateTime? to}) async {
    final conditions = <String>[];
    final arguments = <Object?>[];
    if (from != null) {
      conditions.add('t.occurred_at >= ?');
      arguments.add(from.toIso8601String());
    }
    if (to != null) {
      conditions.add('t.occurred_at < ?');
      arguments.add(to.toIso8601String());
    }
    final where = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
    final rows = await (await database).rawQuery('''
      SELECT t.*, c.name AS category_name FROM transactions t
      JOIN categories c ON c.id = t.category_id $where
      ORDER BY t.occurred_at DESC
    ''', arguments);
    return rows.map(ExpenseTransaction.fromMap).toList();
  }

  Future<void> saveTransaction(ExpenseTransaction item) async {
    final db = await database;
    final data = item.toMap()..remove('id');
    if (item.id == null) {
      await db.insert('transactions', data);
      return;
    }
    final old = await db.query('transactions',
        columns: ['image_path'],
        where: 'id = ?',
        whereArgs: [item.id],
        limit: 1);
    await db
        .update('transactions', data, where: 'id = ?', whereArgs: [item.id]);
    await _deleteReplacedImage(old, item.imagePath);
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    final old = await db.query('transactions',
        columns: ['image_path'], where: 'id = ?', whereArgs: [id], limit: 1);
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    if (old.isNotEmpty && old.first['image_path'] != null) {
      await ImageStore.delete(old.first['image_path'] as String);
    }
  }

  Future<Summary> summary(DateTime from, DateTime to) async {
    final rows = await (await database).rawQuery('''
      SELECT type, COALESCE(SUM(amount), 0) AS total FROM transactions
      WHERE occurred_at >= ? AND occurred_at < ? GROUP BY type
    ''', [from.toIso8601String(), to.toIso8601String()]);
    var income = 0;
    var expense = 0;
    for (final row in rows) {
      if (row['type'] == TransactionType.income.name) {
        income = row['total'] as int;
      } else {
        expense = row['total'] as int;
      }
    }
    return Summary(income, expense);
  }

  Future<void> _deleteReplacedImage(
      List<Map<String, Object?>> old, String? newPath) async {
    final oldPath = old.isEmpty ? null : old.first['image_path'] as String?;
    if (oldPath != null && oldPath != newPath) {
      await ImageStore.delete(oldPath);
    }
  }
}
