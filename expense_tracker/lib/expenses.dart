import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/summary_card.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key, this.onToggleTheme});

  /// Called with `true` when the app is currently dark.
  final void Function(bool isDark)? onToggleTheme;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Jeepney and MyBus fare',
      amount: 84,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.transport,
    ),
    Expense(
      title: 'Lunch at the canteen',
      amount: 145,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.food,
    ),
    Expense(
      title: 'Internet load',
      amount: 299,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: Category.bills,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      _registeredExpenses.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() => _registeredExpenses.remove(expense));

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(
            () => _registeredExpenses.insert(expenseIndex, expense),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          if (widget.onToggleTheme != null)
            IconButton(
              tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
              onPressed: () => widget.onToggleTheme!(isDark),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => RotationTransition(
                  turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpenseOverlay,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add expense'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SummaryCard(expenses: _registeredExpenses),
          ),
          SliverToBoxAdapter(child: Chart(expenses: _registeredExpenses)),
          if (_registeredExpenses.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No expenses yet. Tap Add expense to record your first one.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text('Recent', style: theme.textTheme.titleLarge),
              ),
            ),
            ExpensesList(
              expenses: _registeredExpenses,
              onRemoveExpense: _removeExpense,
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}
