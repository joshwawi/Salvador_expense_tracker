import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_result.dart';
import 'package:expense_tracker/routes/app_routes.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:expense_tracker/utils/layout_constants.dart';
import 'package:expense_tracker/widgets/app_panel.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

/// Every expense in one category. Tapping a row opens its details, and the
/// result (for example a deletion) is forwarded back to the home screen.
class CategoryExpensesScreen extends StatelessWidget {
  const CategoryExpensesScreen({
    super.key,
    required this.category,
    required this.expenses,
  });

  final Category category;
  final List<Expense> expenses;

  Future<void> _openExpense(BuildContext context, Expense expense) async {
    final navigator = Navigator.of(context);
    final result = await navigator.pushNamed<ExpenseResult>(
      AppRoutes.expenseDetails,
      arguments: expense,
    );
    if (result != null && context.mounted) navigator.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final inCategory =
        expenses.where((e) => e.category == category).toList(growable: false);
    final total = inCategory.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(title: Text(category.label)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: LayoutConstants.maxScreenWidth,
            ),
            child: inCategory.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No ${category.label.toLowerCase()} expenses yet.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      AppPanel(
                        color: category.color.withValues(alpha: 0.18),
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Total in ${category.label}',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              peso.format(total),
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(color: scheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                      for (final expense in inCategory)
                        ExpenseItem(
                          expense: expense,
                          onTap: () => _openExpense(context, expense),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
