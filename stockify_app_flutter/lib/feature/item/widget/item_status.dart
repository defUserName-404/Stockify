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
      AssetStatus.Disposed => AppColors.colorPink
    };
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        assetStatus.name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
