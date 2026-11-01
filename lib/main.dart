
import 'package:flutter/material.dart';
import 'pages/app_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
