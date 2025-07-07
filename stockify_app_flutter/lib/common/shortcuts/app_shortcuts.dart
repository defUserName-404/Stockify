import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppShortcuts {
  // General
  static const openSearch =
      SingleActivator(LogicalKeyboardKey.keyF, control: true);
  static const openFilter =
      SingleActivator(LogicalKeyboardKey.keyF, control: true, shift: true);
  static const addNew = SingleActivator(LogicalKeyboardKey.keyN, control: true);
  static const nextPage =
      SingleActivator(LogicalKeyboardKey.arrowRight, control: true);
  static const prevPage =
      SingleActivator(LogicalKeyboardKey.arrowLeft, control: true);

  // Navigation
  static const goToDashboard =
      SingleActivator(LogicalKeyboardKey.digit1, control: true);
  static const goToItems =
      SingleActivator(LogicalKeyboardKey.digit2, control: true);
  static const goToUsers =
      SingleActivator(LogicalKeyboardKey.digit3, control: true);
  static const goToNotifications =
      SingleActivator(LogicalKeyboardKey.digit4, control: true);
  static const goToSettings =
      SingleActivator(LogicalKeyboardKey.digit5, control: true);
}

class Shortcut {
  final String description;
  final String combination;

  Shortcut({required this.description, required this.combination});
}

final List<Shortcut> shortcutList = [
  Shortcut(description: 'Open Search', combination: 'Ctrl + F'),
  Shortcut(description: 'Open Filter', combination: 'Ctrl + Shift + F'),
  Shortcut(description: 'Add New Item/User', combination: 'Ctrl + N'),
  // Shortcut(description: 'Next Page', combination: 'Ctrl + Right Arrow'),
  // Shortcut(description: 'Previous Page', combination: 'Ctrl + Left Arrow'),
  Shortcut(description: 'Go to Dashboard', combination: 'Ctrl + 1'),
  Shortcut(description: 'Go to Items', combination: 'Ctrl + 2'),
  Shortcut(description: 'Go to Users', combination: 'Ctrl + 3'),
  Shortcut(description: 'Go to Notifications', combination: 'Ctrl + 4'),
  Shortcut(description: 'Go to Settings', combination: 'Ctrl + 5'),
];
