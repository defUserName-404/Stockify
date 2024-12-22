import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';

import '../../user/model/user.dart';
import 'device_type.dart';

class Item {
  final int id;
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

  @override
  String toString() {
    return 'Item{'
        'id: $id, '
        'assetNo: $assetNo, '
        'modelNo: $modelNo, '
        'deviceType: $deviceType, '
        'serialNo: $serialNo, '
        'receivedDate: $receivedDate, '
        'warrantyDate: $warrantyDate, '
        'assetStatus: $assetStatus, '
        'hostName: $hostName, '
        'macAddress: $macAddress, '
        'ipPort: $ipPort, '
        'osVersion: $osVersion, '
        'facePlateName: $facePlateName, '
        'switchPort: $switchPort, '
        'switchIpAddress: $switchIpAddress, '
        'isPasswordProtected: $isPasswordProtected, '
        'assignedTo: $assignedTo'
        '}';
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: int.parse(json['id']?.toString() ?? ''),
      assetNo: json['assetNo'] ?? '',
      modelNo: json['modelNo'] ?? '',
      deviceType: DeviceType.values.firstWhere(
        (e) => e.toString() == 'DeviceType.${json['deviceType']}',
        orElse: () => DeviceType.Unknown,
      ),
      serialNo: json['serialNo'] ?? '',
      receivedDate: json['receivedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['receivedDate'] * 1000)
          : null,
      warrantyDate: json['warrantyDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['warrantyDate'] * 1000)
          : DateTime.now(),
      // Provide a default or handle as needed
      assetStatus: AssetStatus.values.firstWhere(
        (e) => e.toString() == 'AssetStatus.${json['assetStatus']}',
        orElse: () => AssetStatus.Unknown,
      ),
      hostName: json['hostName'],
      macAddress: json['macAddress'],
      ipPort: json['ipPort'],
      osVersion: json['osVersion'],
      facePlateName: json['facePlateName'],
      switchPort: json['switchPort'],
      switchIpAddress: json['switchIpAddress'],
      isPasswordProtected: json['isPasswordProtected'] == 1,
      assignedTo:
          json['assignedTo'] != null ? User.fromJson(json['assignedTo']) : null,
    );
  }
}
