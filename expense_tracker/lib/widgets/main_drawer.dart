import 'package:flutter/material.dart';

import 'package:expense_tracker/routes/app_routes.dart';

/// Side menu that lists every top-level screen.
/// It only reports which route was picked; the caller does the navigating.
class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelect,
    this.currentRoute = AppRoutes.home,
  });

  final void Function(String route) onSelect;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget item(IconData icon, String label, String route) {
      return ListTile(
        leading: Icon(icon),
        title: Text(label),
        selected: currentRoute == route,
        onTap: () => onSelect(route),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(color: scheme.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 36,
                    color: scheme.onPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expense Tracker',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: scheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
          item(Icons.receipt_long_rounded, 'Expenses', AppRoutes.home),
          item(Icons.bar_chart_rounded, 'Statistics', AppRoutes.statistics),
          item(Icons.category_rounded, 'Categories', AppRoutes.categories),
          const Divider(),
          item(Icons.settings_rounded, 'Settings', AppRoutes.settings),
          item(Icons.info_outline_rounded, 'About', AppRoutes.about),
        ],
      ),
    );
  }
}
