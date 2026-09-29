import 'package:flutter/material.dart';
import 'package:expense_manager/app/expense_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hiển thị ứng dụng Sổ thu chi', (tester) async {
    await tester.pumpWidget(const ExpenseApp(home: Text('Màn hình kiểm thử')));

    expect(find.text('Màn hình kiểm thử'), findsOneWidget);
  });
}
