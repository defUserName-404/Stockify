part of 'app_layout.dart';

class _AppLayoutLarge extends StatelessWidget {
  final int selectedIndex;
  final double railWidth;
  final bool isExtended;
  final bool showLabels;
  final double minRailWidth;
  final double maxRailWidth;
  final void Function(double) updateRailWidth;
  final void Function(int,
      {ItemFilterParams? itemFilterParams,
      bool openAddItemPanel}) updateSelectedScreen;
  final Widget Function(int) getSelectedScreen;

  const _AppLayoutLarge({
    required this.selectedIndex,
    required this.railWidth,
    required this.isExtended,
    required this.showLabels,
    required this.minRailWidth,
    required this.maxRailWidth,
    required this.updateRailWidth,
    required this.updateSelectedScreen,
    required this.getSelectedScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _Sidebar(
          selectedIndex: selectedIndex,
          railWidth: railWidth,
          isExtended: isExtended,
          showLabels: showLabels,
          minRailWidth: minRailWidth,
          maxRailWidth: maxRailWidth,
          updateRailWidth: updateRailWidth,
          updateSelectedScreen: updateSelectedScreen,
        ),
        _ResizeHandle(
          railWidth: railWidth,
          updateRailWidth: updateRailWidth,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: getSelectedScreen(selectedIndex),
          ),
        ),
      ],
    );
  }
}

// Main Navigation Section
class _NavigationSection extends StatelessWidget {
  final int selectedIndex;
  final bool showLabels;
  final void Function(int,
      {ItemFilterParams? itemFilterParams,
      bool openAddItemPanel}) updateSelectedScreen;

  const _NavigationSection({
    required this.selectedIndex,
    required this.showLabels,
    required this.updateSelectedScreen,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showLabels) ...[
            _SectionLabel(label: 'MAIN'),
            const SizedBox(height: 8),
          ],
          _NavButton(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            onPressed: () => updateSelectedScreen(0),
            isSelected: selectedIndex == 0,
            showLabel: showLabels,
          ),
          const SizedBox(height: 4),
          _NavButton(
            icon: Icons.inventory_2_rounded,
            label: 'Items',
            onPressed: () => updateSelectedScreen(1),
            isSelected: selectedIndex == 1,
            showLabel: showLabels,
          ),
          const SizedBox(height: 4),
          _NavButton(
            icon: Icons.people_rounded,
            label: 'Users',
            onPressed: () => updateSelectedScreen(2),
            isSelected: selectedIndex == 2,
            showLabel: showLabels,
          ),
        ],
      ),
    );
  }
}
