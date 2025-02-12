import 'package:flutter/material.dart';
import 'game.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: Game(),
    );
  }
}
