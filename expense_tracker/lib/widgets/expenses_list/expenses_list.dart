import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

/// A sliver list of expenses. Place it inside a CustomScrollView's slivers.
class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    required this.onOpenExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  final void Function(Expense expense) onOpenExpense;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => ExpenseItem(
        expense: expenses[index],
        onRemoveExpense: onRemoveExpense,
        onTap: () => onOpenExpense(expenses[index]),
      ),
    );
  }
}
