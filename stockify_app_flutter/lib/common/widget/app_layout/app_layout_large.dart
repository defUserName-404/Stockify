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
  final ItemFilterParams? currentFilterParams;

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
    this.currentFilterParams,
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
          currentFilterParams: currentFilterParams,
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
