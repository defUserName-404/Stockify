import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/notification/model/user.dart';

import 'device_type.dart';

class Item {
  final String id;
  final String assetNo;
  final String modelNo;
  final DeviceType deviceType;
  final String serialNo;
  final DateTime? receivedDate;
  final DateTime warrantyDate;
  final AssetStatus assetStatus;
  final String? hostName;
  final String? macAddress;
  final String? ipPort;
  final String? osVersion;
  final String? facePlateName;
  final String? switchPort;
  final String? switchIpAddress;
  final bool? isPasswordProtected;
  final User? assignedTo;

  Item(
      {required this.id,
      required this.assetNo,
      required this.modelNo,
      required this.deviceType,
      required this.serialNo,
      this.receivedDate,
      required this.warrantyDate,
      required this.assetStatus,
      this.hostName,
      this.macAddress,
      this.ipPort,
      this.osVersion,
      this.facePlateName,
      this.switchPort,
      this.switchIpAddress,
      this.isPasswordProtected,
      this.assignedTo});
}
