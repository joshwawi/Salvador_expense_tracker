import 'package:expense_tracker/models/expense.dart';

enum ExpenseAction { deleted }

/// What a screen sends back with `Navigator.pop` so the screen that opened it
/// knows what the user did (for example, deleted an expense).
class ExpenseResult {
  const ExpenseResult.deleted(this.expense) : action = ExpenseAction.deleted;

  final ExpenseAction action;
  final Expense expense;
}
