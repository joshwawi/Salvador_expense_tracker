# expense_tracker

A Flutter expense tracker built across the Lesson 5 (Interactivity & Theming), Lesson 6 (Responsive & Adaptive) and Topic 8 (Navigation) activities.

## Features

### Lesson 5
- Add expenses with a title, amount, date picker, and category chips (with validation)
- Swipe an expense to delete it, with an Undo snackbar
- Animated monthly total and animated category breakdown chart with tooltips
- Custom color palette, custom fonts (Sora and DM Sans via `google_fonts`)
- App-wide light and dark themes with a toggle in the app bar
- Reusable styling through `AppTheme` and the `AppPanel` widget

### Lesson 6
- Adaptive layout chosen with `LayoutBuilder`:
  - **Compact** (under 600 dp wide, such as a phone in portrait): one scrolling column
  - **Wide** (600 dp or more, such as a tablet or a phone in landscape): summary and chart on the left, expense list on the right, each pane scrolling on its own
- Add-expense sheet adapts to its width: title and amount share a row, and category chips share a row with the date field on wide screens
- Bottom sheet capped at a comfortable width, and content capped on very large screens
- Safe-area handling for notches in landscape
- Large widgets split into small reusable widgets, each in its own file
- Breakpoints and sizes kept in one place (`LayoutConstants`) instead of magic numbers

### Topic 8: Navigation
- Multiple screens: expense details, statistics, categories, a single category's expenses, settings and about
- Named routes kept in `AppRoutes`, resolved in one place by `AppRouter` (`onGenerateRoute`, plus `onUnknownRoute`)
- Passing data forward: the tapped `Expense`, the expense list and `CategoryArguments` travel as route arguments
- Returning data back: deleting from the details screen pops an `ExpenseResult`, which the home screen turns into a removal with an Undo snackbar (it is forwarded through the category screens too)
- Navigation drawer (`MainDrawer`) for moving between the main screens
- Custom fade and slide transition for the details screen, plus a `Hero` animation on the category icon
- `popUntil` on the About page to jump straight back to the home screen
- Settings screen with a System, Light and Dark theme selector

## Setup

This folder has `lib/` and `pubspec.yaml` only. Generate the platform folders (android, ios, web, and so on) with:

```bash
cd expense_tracker
flutter create .
flutter pub get
flutter run
```

`flutter create .` adds a default `test/widget_test.dart` that references `MyApp` and will fail. Delete that file (or rewrite it) before running `flutter test`.

To see the Lesson 6 layouts, rotate the device or emulator to landscape, run on a tablet emulator, or widen the Chrome window past 600 px.

## Project structure

```
lib/
  main.dart                          app entry, themes, theme mode switching
  expenses.dart                      main screen: state, add and remove logic
  models/expense.dart                Expense, Category, ExpenseBucket
  models/expense_result.dart         value returned when a screen pops
  theme/app_theme.dart               palette, fonts, component themes
  routes/
    app_routes.dart                  route name constants
    app_router.dart                  route name to screen, with transitions
    route_arguments.dart             data passed to the category screen
  screens/
    expense_details_screen.dart      one expense, delete returns a result
    statistics_screen.dart           totals and category breakdown
    categories_screen.dart           category grid
    category_expenses_screen.dart    expenses of one category
    settings_screen.dart             theme selector
    about_screen.dart                about page
  utils/
    format.dart                      peso formatter
    layout_constants.dart            breakpoints and shared sizes
  widgets/
    app_panel.dart                   reusable rounded container
    summary_card.dart                animated monthly total
    theme_toggle_button.dart         light and dark mode button
    main_drawer.dart                 navigation drawer
    empty_state.dart                 message shown when there are no expenses
    layouts/
      expenses_layout.dart           picks compact or wide layout
      compact_layout.dart            single-column layout
      wide_layout.dart               two-pane layout
    new_expense/
      new_expense.dart               add-expense form (narrow and wide)
      category_chips.dart            selectable category chips
      date_field.dart                tappable date field
    chart/
      chart.dart                     builds buckets and bars
      chart_bar.dart                 one animated bar
    expenses_list/
      expenses_list.dart             sliver list of expenses
      expense_item.dart              one swipe-to-delete row
      expenses_list_header.dart      "Recent" heading
```

## Git milestones (Lesson 6)

Each step was committed separately, with action-verb messages:

1. Add layout constants for breakpoints
2. Extract theme toggle button widget
3. Extract empty state and list header widgets
4. Implement compact and wide layouts
5. Refactor project structure into folders
6. Extract category chips and date field widgets
7. Implement landscape layout for add-expense form
8. Update README for Lesson 6

Example:

```bash
git add lib/utils/layout_constants.dart
git commit -m "Add layout constants for breakpoints"
git push
```

All commits are pushed to the same repository used throughout the semester, before 3:00 PM on October 7.

## Git milestones (Topic 8)

1. Add route names and expense result model
2. Make expense items tappable
3. Add expense details screen
4. Add statistics screen
5. Add categories and category expenses screens
6. Add settings and about screens
7. Add main drawer
8. Add named route generator
9. Wire navigation into expenses screen
10. Remove duplicate files and update README
