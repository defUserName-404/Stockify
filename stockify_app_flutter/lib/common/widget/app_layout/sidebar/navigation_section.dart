part of '../widgets/app_layout.dart';

class _NavigationSection extends StatelessWidget {
  const _NavigationSection();

  @override
  Widget build(BuildContext context) {
    final appLayoutProvider = Provider.of<AppLayoutProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (appLayoutProvider.showLabels) ...[
            const _SectionLabel(label: 'MAIN'),
            const SizedBox(height: 8),
          ],
          _NavButton(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            onPressed: () => appLayoutProvider.updateSelectedScreen(0),
            isSelected: appLayoutProvider.selectedIndex == 0,
            showLabel: appLayoutProvider.showLabels,
          ),
          const SizedBox(height: 4),
          _NavButton(
            icon: Icons.inventory_2_rounded,
            label: 'Items',
            onPressed: () => appLayoutProvider.updateSelectedScreen(1),
            isSelected: appLayoutProvider.selectedIndex == 1,
            showLabel: appLayoutProvider.showLabels,
          ),
          if (appLayoutProvider.selectedIndex == 1 && appLayoutProvider.showLabels)
            Padding(
              padding: const EdgeInsets.only(
                  left: 36.0, top: 8, right: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SubNavButton(
                    label: 'All Items',
                    onPressed: () => appLayoutProvider.updateSelectedScreen(1,
                        itemFilterParams: ItemFilterParams()),
                    isSelected:
                        appLayoutProvider.currentFilterParams?.assetStatus ==
                            null,
                  ),
                  const SizedBox(height: 4),
                  _SubNavButton(
                    label: 'Active Items',
                    onPressed: () => appLayoutProvider.updateSelectedScreen(1,
                        itemFilterParams: 
                            ItemFilterParams(assetStatus: AssetStatus.Active)),
                    isSelected: appLayoutProvider.currentFilterParams?.assetStatus ==
                        AssetStatus.Active,
                  ),
                  const SizedBox(height: 4),
                  _SubNavButton(
                    label: 'Disposed Items',
                    onPressed: () => appLayoutProvider.updateSelectedScreen(1,
                        itemFilterParams: ItemFilterParams(
                            assetStatus: AssetStatus.Disposed)),
                    isSelected:
                        appLayoutProvider.currentFilterParams?.assetStatus ==
                            AssetStatus.Disposed,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          _NavButton(
            icon: Icons.people_rounded,
            label: 'Users',
            onPressed: () => appLayoutProvider.updateSelectedScreen(2),
            isSelected: appLayoutProvider.selectedIndex == 2,
            showLabel: appLayoutProvider.showLabels,
          ),
        ],
      ),
    );
  }
}
