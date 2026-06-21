import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rank AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SearchScreen(),
    );
  }
}
