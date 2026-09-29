import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key, this.home});

  /// Cho phép thay màn hình đầu trong widget test mà không cần khởi tạo plugin.
  final Widget? home;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Sổ thu chi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D6B)),
          useMaterial3: true,
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
        ),
        home: home ?? const HomeScreen(),
      );
}
