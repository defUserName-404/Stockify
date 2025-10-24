part of '../widgets/app_layout.dart';

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final appLayoutProvider = Provider.of<AppLayoutProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: appLayoutProvider.railWidth,
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
            showLabels: appLayoutProvider.showLabels,
            isExtended: appLayoutProvider.isExtended,
            onToggle: () {
              appLayoutProvider.updateRailWidth(appLayoutProvider.isExtended
                  ? appLayoutProvider.minRailWidth
                  : appLayoutProvider.maxRailWidth);
            },
          ),
          Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
          const Expanded(
            child: _NavigationSection(),
          ),
          const _BottomNavigationSection(),
        ],
      ),
    );
  }
}




