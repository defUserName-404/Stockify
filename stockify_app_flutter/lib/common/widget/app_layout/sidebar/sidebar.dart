part of '../app_layout.dart';

class _Sidebar extends StatelessWidget {
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
  final ItemFilterParams? currentFilterParams;

  const _Sidebar({
    required this.selectedIndex,
    required this.railWidth,
    required this.isExtended,
    required this.showLabels,
    required this.minRailWidth,
    required this.maxRailWidth,
    required this.updateRailWidth,
    required this.updateSelectedScreen,
    this.currentFilterParams,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: railWidth,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _SidebarHeader(
            showLabels: showLabels,
            isExtended: isExtended,
            onToggle: () {
              updateRailWidth(isExtended ? minRailWidth : maxRailWidth);
            },
          ),
          Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
          Expanded(
            child: _NavigationSection(
              selectedIndex: selectedIndex,
              showLabels: showLabels,
              updateSelectedScreen: updateSelectedScreen,
              currentFilterParams: currentFilterParams,
            ),
          ),
          _BottomNavigationSection(
            selectedIndex: selectedIndex,
            showLabels: showLabels,
            updateSelectedScreen: updateSelectedScreen,
          ),
        ],
      ),
    );
  }
}




