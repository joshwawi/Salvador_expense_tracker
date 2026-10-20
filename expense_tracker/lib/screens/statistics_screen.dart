import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:expense_tracker/utils/layout_constants.dart';
import 'package:expense_tracker/widgets/app_panel.dart';

/// Totals and a per-category breakdown. The expenses are passed in as a
/// route argument, so this screen never needs to know where they come from.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final average = expenses.isEmpty ? 0.0 : total / expenses.length;
    final largest = expenses.isEmpty
        ? null
        : expenses.reduce((a, b) => a.amount >= b.amount ? a : b);

    final buckets = [
      for (final c in Category.values) ExpenseBucket.forCategory(expenses, c),
    ]..sort((a, b) => b.totalExpenses.compareTo(a.totalExpenses));

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: LayoutConstants.maxScreenWidth,
            ),
            child: expenses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Nothing to analyse yet. Add an expense first.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      AppPanel(
                        color: scheme.primary,
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total spent',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: scheme.onPrimary.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              peso.format(total),
                              style: theme.textTheme.displaySmall
                                  ?.copyWith(color: scheme.onPrimary),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${expenses.length} ${expenses.length == 1 ? 'expense' : 'expenses'} recorded',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onPrimary.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _StatTile(
                              icon: Icons.functions_rounded,
                              label: 'Average',
                              value: peso.format(average),
                              margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            ),
                          ),
                          Expanded(
                            child: _StatTile(
                              icon: Icons.arrow_upward_rounded,
                              label: 'Largest',
                              value: peso.format(largest?.amount ?? 0),
                              margin: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                            ),
                          ),
                        ],
                      ),
                      AppPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('By category',
                                style: theme.textTheme.titleLarge),
                            const SizedBox(height: 8),
                            for (final bucket in buckets)
                              _CategoryRow(
                                bucket: bucket,
                                share: total == 0
                                    ? 0
                                    : bucket.totalExpenses / total,
                              ),
                          ],
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

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.margin,
  });

  final IconData icon;
  final String label;
  final String value;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPanel(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.secondary),
          const SizedBox(height: 10),
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: theme.textTheme.titleLarge),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.bucket, required this.share});

  final ExpenseBucket bucket;
  final double share;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final category = bucket.category;
    final count = bucket.expenses.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(category.icon, color: category.color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${category.label} ($count)',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '${peso.format(bucket.totalExpenses)}  ${(share * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: share,
              minHeight: 8,
              color: category.color,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
