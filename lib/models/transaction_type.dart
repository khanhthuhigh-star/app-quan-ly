import 'package:flutter/material.dart';

enum TransactionType { income, expense }

enum Period { day, week, month }

extension TransactionTypeLabel on TransactionType {
  String get label => this == TransactionType.income ? 'Thu' : 'Chi';
  Color get color => this == TransactionType.income ? Colors.teal : Colors.red;
}
