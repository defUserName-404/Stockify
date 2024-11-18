import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

import '../../../feature/home/screen/home_screen.dart';
import '../../../feature/settings/screen/settings_screen.dart';

class AppPlaceholder extends StatefulWidget {
  const AppPlaceholder({super.key});

  @override
  State<AppPlaceholder> createState() => _AppPlaceholderState();
}

class _AppPlaceholderState extends State<AppPlaceholder> {
  int _selectedIndex = 0;
  double _railWidth = 72;
  bool _isExtended = false;
  bool _showLabels = false;
  final double _minWidth = 72;
  final double _maxWidth = 250;
  final double _labelThreshold = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          SizedBox(
            width: _railWidth,
            child: NavigationRail(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _isExtended = !_isExtended;
                    _railWidth = _isExtended ? _maxWidth : _minWidth;
                    _showLabels = _railWidth > _labelThreshold;
                  });
                },
                icon: const Icon(Icons.menu, color: AppColors.colorBackground),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              labelType: _showLabels
                  ? NavigationRailLabelType.all
                  : NavigationRailLabelType.none,
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _railWidth += details.primaryDelta!;
                _railWidth = _railWidth.clamp(_minWidth, _maxWidth);
                bool shouldShowLabels = _railWidth > _labelThreshold;
                if (shouldShowLabels != _showLabels) {
                  _showLabels = shouldShowLabels;
                }
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: Container(
                width: 2,
                height: double.infinity,
                color: Colors.grey[300],
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: _getSelectedScreen(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SettingsScreen();
      default:
        return const Center(child: Text("Page not found"));
    }
  }
}
