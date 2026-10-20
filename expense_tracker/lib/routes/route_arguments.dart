import 'package:expense_tracker/models/expense.dart';

/// Data handed to the category screen when it is opened.
class CategoryArguments {
  const CategoryArguments({required this.category, required this.expenses});

  final Category category;
  final List<Expense> expenses;
}
