import 'dart:developer';

import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';

import '../../user/model/user.dart';
import 'device_type.dart';

class Item {
  final int? id;
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
      {this.id,
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
    log(json.toString());
    return Item(
      id: json['ID'],
      assetNo: json['AssetNo'],
      modelNo: json['ModelNo'],
      deviceType: DeviceType.values
          .firstWhere((e) => e.toString() == json['DeviceType']),
      serialNo: json['SerialNo'],
      receivedDate: json['ReceivedDate'] != null
          ? DateTime.parse(json['ReceivedDate']).toLocal()
          : null,
      warrantyDate: DateTime.parse(json['WarrantyDate']).toLocal(),
      assetStatus: AssetStatus.values
          .firstWhere((e) => e.toString() == json['AssetStatus']),
      hostName: json['HostName'],
      macAddress: json['MacAddress'],
      ipPort: json['IpPort'],
      osVersion: json['OsVersion'],
      facePlateName: json['FacePlateName'],
      switchPort: json['SwitchPort'],
      switchIpAddress: json['SwitchIpAddress'],
      isPasswordProtected: json['IsPasswordProtected'] == 1,
      assignedTo:
          json['AssignedTo'] != null ? User.fromJson(json['AssignedTo']) : null,
    );
  }
}

class ItemFilterParams {
  final String search;
  final DeviceType? deviceType;
  final AssetStatus? assetStatus;
  final DateTime? warrantyDate;
  final String sortBy;
  final String sortOrder;
  final int page;
  final int pageSize;

  ItemFilterParams({
    this.search = '',
    this.deviceType,
    this.assetStatus,
    this.warrantyDate,
    this.sortBy = 'assetNo',
    this.sortOrder = 'ASC',
    this.page = 1,
    this.pageSize = 10,
  });

  ItemFilterParams copyWith({
    Object? search = const _Sentinel(),
    Object? sortBy = const _Sentinel(),
    Object? sortOrder = const _Sentinel(),
    Object? deviceType = const _Sentinel(),
    Object? assetStatus = const _Sentinel(),
    Object? page = const _Sentinel(),
  }) {
    return ItemFilterParams(
      search:
          identical(search, const _Sentinel()) ? this.search : search as String,
      sortBy:
          identical(sortBy, const _Sentinel()) ? this.sortBy : sortBy as String,
      sortOrder: identical(sortOrder, const _Sentinel())
          ? this.sortOrder
          : sortOrder as String,
      deviceType: identical(deviceType, const _Sentinel())
          ? this.deviceType
          : deviceType as DeviceType?,
      assetStatus: identical(assetStatus, const _Sentinel())
          ? this.assetStatus
          : assetStatus as AssetStatus?,
      page: identical(page, const _Sentinel()) ? this.page : page as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemFilterParams &&
          runtimeType == other.runtimeType &&
          search == other.search &&
          sortBy == other.sortBy &&
          sortOrder == other.sortOrder &&
          deviceType == other.deviceType &&
          assetStatus == other.assetStatus &&
          page == other.page;

  @override
  int get hashCode =>
      search.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode ^
      deviceType.hashCode ^
      assetStatus.hashCode ^
      page.hashCode;
}

// Sentinel class to distinguish between null and not provided values
class _Sentinel {
  const _Sentinel();
}
