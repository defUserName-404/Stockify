import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

import '../model/asset_status.dart';

class ItemStatus extends StatelessWidget {
  final AssetStatus assetStatus;

  const ItemStatus({super.key, required this.assetStatus});

  @override
  Widget build(BuildContext context) {
    final color = switch (assetStatus) {
      AssetStatus.Active => AppColors.colorGreen,
      AssetStatus.Inactive => AppColors.colorOrange,
      AssetStatus.Disposed => AppColors.colorPink,
    };
    final icon = switch (assetStatus) {
      AssetStatus.Active => Icons.check_circle,
      AssetStatus.Inactive => Icons.pause_circle,
      AssetStatus.Disposed => Icons.remove_circle,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6.0),
          Text(
            assetStatus.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
