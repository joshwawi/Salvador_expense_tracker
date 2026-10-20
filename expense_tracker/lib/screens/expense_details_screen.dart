import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_result.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:expense_tracker/utils/layout_constants.dart';
import 'package:expense_tracker/widgets/app_panel.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

/// Shows one expense in full. The expense arrives as a constructor argument,
/// and deleting it sends an [ExpenseResult] back to the previous screen.
class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen({super.key, required this.expense});

  final Expense expense;

  String _relativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('"${expense.title}" will be removed from your list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Return data to the screen that opened this one.
      Navigator.pop(context, ExpenseResult.deleted(expense));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final category = expense.category;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense details'),
        actions: [
          IconButton(
            tooltip: 'Delete expense',
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
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
                  child: Hero(
                    tag: ExpenseItem.heroTag(expense),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(category.icon, color: category.color, size: 48),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    expense.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  peso.format(expense.amount),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                AppPanel(
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: category.icon,
                        label: 'Category',
                        value: category.label,
                      ),
                      const Divider(height: 24),
                      _DetailRow(
                        icon: Icons.calendar_month_rounded,
                        label: 'Date',
                        value: DateFormat.yMMMMEEEEd().format(expense.date),
                      ),
                      const Divider(height: 24),
                      _DetailRow(
                        icon: Icons.schedule_rounded,
                        label: 'When',
                        value: _relativeDay(expense.date),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: FilledButton.tonalIcon(
                    onPressed: () => _confirmDelete(context),
                    style: FilledButton.styleFrom(
                      foregroundColor: scheme.error,
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Delete expense'),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
