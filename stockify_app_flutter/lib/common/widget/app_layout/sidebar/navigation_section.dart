part of '../app_layout.dart';

class _NavigationSection extends StatelessWidget {
  final int selectedIndex;
  final bool showLabels;
  final void Function(int,
      {ItemFilterParams? itemFilterParams,
      bool openAddItemPanel}) updateSelectedScreen;
  final ItemFilterParams? currentFilterParams;

  const _NavigationSection({
    required this.selectedIndex,
    required this.showLabels,
    required this.updateSelectedScreen,
    this.currentFilterParams,
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
          if (selectedIndex == 1 && showLabels)
            Padding(
              padding: const EdgeInsets.only(
                  left: 36.0, top: 8, right: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SubNavButton(
                    label: 'All Items',
                    onPressed: () => updateSelectedScreen(1,
                        itemFilterParams: ItemFilterParams()),
                    isSelected: currentFilterParams?.assetStatus == null,
                  ),
                  const SizedBox(height: 4),
                  _SubNavButton(
                    label: 'Active Items',
                    onPressed: () => updateSelectedScreen(1,
                        itemFilterParams:
                            ItemFilterParams(assetStatus: AssetStatus.Active)),
                    isSelected:
                        currentFilterParams?.assetStatus == AssetStatus.Active,
                  ),
                  const SizedBox(height: 4),
                  _SubNavButton(
                    label: 'Disposed Items',
                    onPressed: () => updateSelectedScreen(1,
                        itemFilterParams: ItemFilterParams(
                            assetStatus: AssetStatus.Disposed)),
                    isSelected: currentFilterParams?.assetStatus ==
                        AssetStatus.Disposed,
                  ),
                ],
              ),
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
