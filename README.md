# expense_tracker

A Flutter expense tracker for the Lesson 5 (Interactivity & Theming) asynchronous activity.

## Features

- Add expenses with a title, amount, date picker, and category chips (with validation)
- Swipe an expense to delete it, with an Undo snackbar
- Animated monthly total and animated category breakdown bars
- Custom color palette, custom fonts (Sora and DM Sans via `google_fonts`)
- App-wide light and dark themes with a toggle in the app bar
- Reusable styling through `AppTheme` and the `AppPanel` widget

## Setup

This folder has `lib/` and `pubspec.yaml` only. Generate the platform folders (android, ios, web, and so on) with:

```bash
cd expense_tracker
flutter create .
flutter pub get
flutter run
```

`flutter create .` adds a default `test/widget_test.dart` that references `MyApp` and will fail. Delete that file (or rewrite it) before running `flutter test`.

## Project structure

```
lib/
  main.dart                    app entry + theme mode switching
  models/expense.dart          Expense + Category (label, icon, color)
  theme/app_theme.dart         palette, fonts, component themes
  screens/expenses_screen.dart main screen
  widgets/
    app_panel.dart             reusable rounded container
    summary_card.dart          animated monthly total
    category_bars.dart         spending by category
    expense_tile.dart          list item with swipe-to-delete
    new_expense.dart           add-expense bottom sheet
```

## Suggested Git milestones

The assignment reviews your commit history, so commit as you build rather than all at once. One way to grow this project in stages:

```bash
git init
git branch -M main
git remote add origin <your-repo-url>

# 1. Initial project setup
flutter create .
git add . && git commit -m "Initial project setup with starter main.dart"
git push -u origin main

# 2. Data model
git add lib/models && git commit -m "Add Expense model and categories"

# 3. Theme configuration
git add lib/theme pubspec.yaml && git commit -m "Add custom color palette, fonts, and light/dark themes"

# 4. Reusable widgets / UI redesign
git add lib/widgets/app_panel.dart lib/widgets/summary_card.dart lib/widgets/expense_tile.dart
git commit -m "Add reusable panel, summary card, and expense tile"

# 5. Interactive features
git add lib/widgets/new_expense.dart lib/screens
git commit -m "Add expense form with validation and date picker"

# 6. Result screen enhancement
git add lib/widgets/category_bars.dart
git commit -m "Add animated category breakdown"

# 7. Final testing and polishing
git add . && git commit -m "Polish UI, add undo on delete and theme toggle"
git push
```

Push everything to the same repository you submit, before 3:00 PM on September 30.
