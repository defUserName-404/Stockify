import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';

import '../../../../feature/item/model/asset_status.dart';
import '../../../../feature/item/model/item_filter_param.dart';
import '../../../../feature/notification/model/app_notification.dart';
import '../../../../feature/notification/service/notification_storage_service.dart';
import '../provider/app_layout_provider.dart';

part '../sidebar/bottom_navigation_section.dart';

part '../sidebar/header_toggle_button.dart';

part '../sidebar/navigation_section.dart';

part '../sidebar/notification_badge.dart';

part '../sidebar/resize_handle.dart';

part '../sidebar/section_label.dart';

part '../sidebar/sidebar.dart';

part '../sidebar/sidebar_header.dart';

part '../sidebar/sub_nav_bar.dart';
part 'app_layout_large.dart';
part 'app_layout_small.dart';
part 'nav_button.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLayoutProvider>(
        builder: (context, appLayoutProvider, child) {
      return Shortcuts(
        shortcuts: {
          AppShortcuts.goToDashboard: VoidCallbackIntent(
              () => appLayoutProvider.updateSelectedScreen(0)),
          AppShortcuts.goToItems: VoidCallbackIntent(
              () => appLayoutProvider.updateSelectedScreen(1)),
          AppShortcuts.goToUsers: VoidCallbackIntent(
              () => appLayoutProvider.updateSelectedScreen(2)),
          AppShortcuts.goToNotifications: VoidCallbackIntent(
              () => appLayoutProvider.updateSelectedScreen(3)),
          AppShortcuts.goToSettings: VoidCallbackIntent(
              () => appLayoutProvider.updateSelectedScreen(4)),
        },
        child: Actions(
          actions: {
            VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
              onInvoke: (intent) => intent.callback(),
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return const _AppLayoutSmall();
                  } else {
                    return const _AppLayoutLarge();
                  }
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
