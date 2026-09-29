import 'package:flutter/material.dart';

enum Category { food, transport, bills, game, other }

extension CategoryX on Category {
  String get label => switch (this) {
        Category.food => 'Food',
        Category.transport => 'Transport',
        Category.bills => 'Bills',
        Category.game => 'Leisure',
        Category.other => 'Other',
      };

  IconData get icon => switch (this) {
        Category.food => Icons.ramen_dining_rounded,
        Category.transport => Icons.directions_bus_rounded,
        Category.bills => Icons.receipt_long_rounded,
        Category.game => Icons.sports_esports_rounded,
        Category.other => Icons.category_rounded,
      };

  Color get color => switch (this) {
        Category.food => const Color.fromARGB(255, 19, 66, 7),
        Category.transport => const Color.fromARGB(255, 13, 18, 88),
        Category.bills => const Color.fromARGB(255, 59, 9, 9),
        Category.game => const Color(0xFF6C5CE7),
        Category.other => const Color(0xFF7A8B91),
      };
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = '${DateTime.now().microsecondsSinceEpoch}-${_counter++}';

  static int _counter = 0;

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}

/// Groups all expenses that belong to one category.
class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  /// Alternative constructor: builds a bucket by filtering a full list.
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses =
            allExpenses.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
