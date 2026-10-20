import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_result.dart';
import 'package:expense_tracker/routes/app_routes.dart';
import 'package:expense_tracker/routes/route_arguments.dart';
import 'package:expense_tracker/utils/format.dart';
import 'package:expense_tracker/utils/layout_constants.dart';

/// Grid of categories. Picking one opens that category's expenses.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.expenses});

  final List<Expense> expenses;

  Future<void> _openCategory(BuildContext context, Category category) async {
    final navigator = Navigator.of(context);
    final result = await navigator.pushNamed<ExpenseResult>(
      AppRoutes.category,
      arguments: CategoryArguments(category: category, expenses: expenses),
    );

    // Pass whatever the next screen returned back to the home screen.
    if (result != null && context.mounted) navigator.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: LayoutConstants.maxScreenWidth,
            ),
            child: GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              children: [
                for (final category in Category.values)
                  _CategoryCard(
                    bucket: ExpenseBucket.forCategory(expenses, category),
                    onTap: () => _openCategory(context, category),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.bucket, required this.onTap});

  final ExpenseBucket bucket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = bucket.category;
    final count = bucket.expenses.length;

    return Material(
      color: category.color.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(category.icon, color: category.color, size: 32),
              const Spacer(),
              Text(category.label, style: theme.textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                '$count ${count == 1 ? 'expense' : 'expenses'}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  peso.format(bucket.totalExpenses),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
