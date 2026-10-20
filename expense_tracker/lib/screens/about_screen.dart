import 'package:flutter/material.dart';

import 'package:expense_tracker/routes/app_routes.dart';
import 'package:expense_tracker/utils/layout_constants.dart';
import 'package:expense_tracker/widgets/app_panel.dart';

/// Profile and about page for the app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _features = [
    'Add, swipe-delete and undo expenses',
    'Light and dark themes',
    'Responsive layouts for phones and tablets',
    'Multiple screens with named routes',
    'Statistics and category views',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: LayoutConstants.maxScreenWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: scheme.primary,
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 40,
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Expense Tracker',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0  |  Built by Salvador',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                AppPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("What's inside", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      for (final feature in _features)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: scheme.secondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(feature)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: FilledButton.icon(
                    // Pops every screen above the home route in one go.
                    onPressed: () => Navigator.of(context).popUntil(
                      ModalRoute.withName(AppRoutes.home),
                    ),
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Back to expenses'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
