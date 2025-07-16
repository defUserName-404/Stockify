import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/widget/sidebar/app_layout.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/info_card.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';

import '../../../common/theme/colors.dart';

class InfoCardsGrid extends StatelessWidget {
  final int totalItems;
  final int totalUsers;
  final int expiringItems;
  final int disposedItems;

  const InfoCardsGrid(
      {super.key,
      required this.totalItems,
      required this.totalUsers,
      required this.expiringItems,
      required this.disposedItems});

  @override
  Widget build(BuildContext context) {
    final cards = [
      InfoCard(
        title: 'Total Items',
        value: totalItems.toString(),
        icon: Icons.inventory_2,
        color: AppColors.colorBlue,
        index: 0,
        onTap: () =>
            AppLayout.navigatorKey.currentState?.updateSelectedScreen(1),
      ),
      InfoCard(
        title: 'Total Users',
        value: totalUsers.toString(),
        icon: Icons.people,
        color: AppColors.colorGreen,
        index: 1,
        onTap: () {},
      ),
      InfoCard(
        title: 'Items Nearing Warranty',
        value: expiringItems.toString(),
        icon: Icons.warning,
        color: AppColors.colorOrange,
        index: 2,
        onTap: () => AppLayout.navigatorKey.currentState?.updateSelectedScreen(
            1,
            itemFilterParams: ItemFilterParams(isExpiring: true)),
      ),
      InfoCard(
        title: 'Disposed Items',
        value: disposedItems.toString(),
        icon: Icons.delete,
        color: AppColors.colorPink,
        index: 3,
        onTap: () => AppLayout.navigatorKey.currentState?.updateSelectedScreen(
            1,
            itemFilterParams:
                ItemFilterParams(assetStatus: AssetStatus.Disposed)),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }
}
