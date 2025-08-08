import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShortcuts {
  // General
  static const openSearch =
      SingleActivator(LogicalKeyboardKey.keyF, control: true);
  static const openFilter =
      SingleActivator(LogicalKeyboardKey.keyF, control: true, shift: true);
  static const addNew = SingleActivator(LogicalKeyboardKey.keyN, control: true);

  static const arrowUp = SingleActivator(LogicalKeyboardKey.arrowUp);
  static const arrowDown = SingleActivator(LogicalKeyboardKey.arrowDown);
  static const nextPage = SingleActivator(LogicalKeyboardKey.pageDown);
  static const previousPage = SingleActivator(LogicalKeyboardKey.pageUp);

  static const viewDetails =
      SingleActivator(LogicalKeyboardKey.keyV, control: true);
  static const editItem =
      SingleActivator(LogicalKeyboardKey.keyE, control: true);
  static const deleteItem = SingleActivator(LogicalKeyboardKey.delete);
  static const cancel = SingleActivator(LogicalKeyboardKey.escape);
  static const submit = SingleActivator(LogicalKeyboardKey.enter);
  static const save = SingleActivator(LogicalKeyboardKey.keyS, control: true);

  // Sorting & Filtering
  static const sortAsc = SingleActivator(LogicalKeyboardKey.arrowUp, alt: true);
  static const sortDesc =
      SingleActivator(LogicalKeyboardKey.arrowDown, alt: true);

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
  final IconData icon;

  Shortcut({
    required this.description,
    required this.combination,
    this.icon = Icons.keyboard,
  });
}

final List<Shortcut> shortcutList = [
  Shortcut(
      description: 'Open Search', combination: 'Ctrl + F', icon: Icons.search),
  Shortcut(
      description: 'Open Filter',
      combination: 'Ctrl + Shift + F',
      icon: Icons.filter_list),
  Shortcut(
      description: 'Add New Item/User',
      combination: 'Ctrl + N',
      icon: Icons.add),
  Shortcut(
      description: 'Go to Dashboard',
      combination: 'Ctrl + 1',
      icon: Icons.dashboard),
  Shortcut(
      description: 'Go to Items', combination: 'Ctrl + 2', icon: Icons.list),
  Shortcut(
      description: 'Go to Users', combination: 'Ctrl + 3', icon: Icons.people),
  Shortcut(
      description: 'Go to Notifications',
      combination: 'Ctrl + 4',
      icon: Icons.notifications),
  Shortcut(
      description: 'Go to Settings',
      combination: 'Ctrl + 5',
      icon: Icons.settings),
  Shortcut(
      description: 'View Item/User Details',
      combination: 'Ctrl + V',
      icon: Icons.remove_red_eye),
  Shortcut(
      description: 'Edit Item/User', combination: 'Ctrl + E', icon: Icons.edit),
  Shortcut(
      description: 'Delete Item/User',
      combination: 'Delete',
      icon: Icons.delete),
  Shortcut(
      description: 'Sort Ascending',
      combination: 'Alt + Up Arrow',
      icon: Icons.arrow_upward),
  Shortcut(
      description: 'Sort Descending',
      combination: 'Alt + Down Arrow',
      icon: Icons.arrow_downward),
  Shortcut(
      description: 'Navigate Up',
      combination: 'Up Arrow',
      icon: Icons.arrow_upward),
  Shortcut(
      description: 'Navigate Down',
      combination: 'Down Arrow',
      icon: Icons.arrow_downward),
  Shortcut(
      description: 'Navigate to Next Page',
      combination: 'Page Down',
      icon: Icons.arrow_forward),
  Shortcut(
      description: 'Navigate to Previous Page',
      combination: 'Page Up',
      icon: Icons.arrow_back),
  Shortcut(
      description: 'Save Item/User',
      combination: 'Ctrl + S',
      icon: Icons.save),
];
