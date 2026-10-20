import 'package:flutter/material.dart';

import 'package:expense_tracker/expenses.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_result.dart';
import 'package:expense_tracker/routes/app_routes.dart';
import 'package:expense_tracker/routes/route_arguments.dart';
import 'package:expense_tracker/screens/about_screen.dart';
import 'package:expense_tracker/screens/categories_screen.dart';
import 'package:expense_tracker/screens/category_expenses_screen.dart';
import 'package:expense_tracker/screens/expense_details_screen.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:expense_tracker/screens/statistics_screen.dart';

/// Turns a route name (plus its arguments) into a screen.
///
/// Every route is typed with [ExpenseResult] because any screen may be asked
/// to return one to the screen that opened it.
class AppRouter {
  const AppRouter({
    required this.themeMode,
    required this.onToggleTheme,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final void Function(bool isDark) onToggleTheme;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  Route<ExpenseResult>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _page(settings, Expenses(onToggleTheme: onToggleTheme));

      case AppRoutes.expenseDetails:
        final expense = settings.arguments as Expense;
        return _fadeSlide(settings, ExpenseDetailsScreen(expense: expense));

      case AppRoutes.statistics:
        return _page(settings, StatisticsScreen(expenses: _expenses(settings)));

      case AppRoutes.categories:
        return _page(settings, CategoriesScreen(expenses: _expenses(settings)));

      case AppRoutes.category:
        final args = settings.arguments as CategoryArguments;
        return _page(
          settings,
          CategoryExpensesScreen(
            category: args.category,
            expenses: args.expenses,
          ),
        );

      case AppRoutes.settings:
        return _page(
          settings,
          SettingsScreen(
            themeMode: themeMode,
            onThemeModeChanged: onThemeModeChanged,
          ),
        );

      case AppRoutes.about:
        return _page(settings, const AboutScreen());
    }
    return null;
  }

  /// Used when a name is not recognised, so the app never shows a red error.
  Route<ExpenseResult> onUnknownRoute(RouteSettings settings) {
    return _page(
      RouteSettings(name: AppRoutes.home, arguments: settings.arguments),
      Expenses(onToggleTheme: onToggleTheme),
    );
  }

  List<Expense> _expenses(RouteSettings settings) =>
      (settings.arguments as List<Expense>?) ?? const <Expense>[];

  Route<ExpenseResult> _page(RouteSettings settings, Widget page) {
    return MaterialPageRoute<ExpenseResult>(
      settings: settings,
      builder: (_) => page,
    );
  }

  /// Custom transition for the details screen: a soft fade and short slide.
  Route<ExpenseResult> _fadeSlide(RouteSettings settings, Widget page) {
    return PageRouteBuilder<ExpenseResult>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
