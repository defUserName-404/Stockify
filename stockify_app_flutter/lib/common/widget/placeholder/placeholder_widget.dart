import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/feature/item/screen/item_screen.dart';

import '../../../feature/dashboard/screen/dashboard_screen.dart';
import '../../../feature/settings/screen/settings_screen.dart';
import '../../shared-preference/shared_preference_service.dart';
import '../../theme/colors.dart';

class AppPlaceholder extends StatefulWidget {
  const AppPlaceholder({super.key});

  @override
  State<AppPlaceholder> createState() => _AppPlaceholderState();
}

class _AppPlaceholderState extends State<AppPlaceholder> {
  int _selectedIndex = 0;
  late double _railWidth;
  bool _isExtended = false;
  bool _showLabels = false;
  final double _minRailWidth = 72;
  final double _maxRailWidth = 250;
  final double _minRailLabelThreshold = 100;

  @override
  void initState() {
    super.initState();
    final sharedPrefs = Provider.of<SharedPrefsService>(context, listen: false);
    _railWidth = sharedPrefs.railWidth;
    _isExtended = _railWidth > _minRailWidth;
    _showLabels = _railWidth > _minRailLabelThreshold;
  }

  void _updateRailWidth(double newWidth) {
    final sharedPrefs = Provider.of<SharedPrefsService>(context, listen: false);
    setState(() {
      _railWidth = newWidth.clamp(_minRailWidth, _maxRailWidth);
      _showLabels = _railWidth > _minRailLabelThreshold;
      _isExtended = _railWidth > _minRailWidth;
      sharedPrefs.setRailWidth(_railWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: <Widget>[
          SizedBox(
            width: _railWidth,
            child: NavigationRail(
              leading: IconButton(
                onPressed: () {
                  _updateRailWidth(_isExtended ? _minRailWidth : _maxRailWidth);
                },
                icon: const Icon(Icons.menu, color: AppColors.colorBackground),
              ),
              // Top items
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text('Items'),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.account_circle_outlined),
                  selectedIcon: const Icon(Icons.account_circle),
                  label: const Text('Users'),
                  padding: EdgeInsets.only(bottom: screenHeight * 0.61),
                ),
                // Bottom items
                const NavigationRailDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications),
                  label: Text('Notifications'),
                ),
                const NavigationRailDestination(
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
              _updateRailWidth(_railWidth + details.primaryDelta!);
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
        return const DashboardScreen();
      case 1:
        return const ItemScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const Center(child: Text("Page not found"));
    }
  }
}
