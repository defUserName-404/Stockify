part of 'app_layout.dart';

class _AppLayoutLarge extends StatelessWidget {
  const _AppLayoutLarge();

  @override
  Widget build(BuildContext context) {
    final appLayoutProvider = Provider.of<AppLayoutProvider>(context);
    return Row(
      children: <Widget>[
        const _Sidebar(),
        _ResizeHandle(
          railWidth: appLayoutProvider.railWidth,
          updateRailWidth: appLayoutProvider.updateRailWidth,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: appLayoutProvider.getSelectedScreen(),
          ),
        ),
      ],
    );
  }
}
