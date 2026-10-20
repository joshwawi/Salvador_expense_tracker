import 'package:flutter/material.dart';

import 'package:expense_tracker/routes/app_router.dart';
import 'package:expense_tracker/routes/app_routes.dart';
import 'package:expense_tracker/theme/app_theme.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() => _themeMode = isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(
      themeMode: _themeMode,
      onToggleTheme: _toggleTheme,
      onThemeModeChanged: _setThemeMode,
    );

    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      initialRoute: AppRoutes.home,
      onGenerateRoute: router.onGenerateRoute,
      onUnknownRoute: router.onUnknownRoute,
    );
  }
}
