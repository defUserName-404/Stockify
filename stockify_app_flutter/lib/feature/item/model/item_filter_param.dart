import 'asset_status.dart';
import 'device_type.dart';
import '../../user/model/user.dart';

enum WarrantyDateFilterType {
  day,
  month,
  year,
}

class ItemFilterParams {
  final String search;
  final String? sortBy;
  final String sortOrder;
  final DeviceType? deviceType;
  final AssetStatus? assetStatus;
  final bool isExpiring;
  final bool isExpired;
  final DateTime? warrantyDate;
  final WarrantyDateFilterType? warrantyDateFilterType;
  final User? assignedTo;

  ItemFilterParams({
    this.search = '',
    this.sortBy,
    this.sortOrder = 'ASC',
    this.deviceType,
    this.assetStatus,
    this.isExpiring = false,
    this.isExpired = false,
    this.warrantyDate,
    this.warrantyDateFilterType,
    this.assignedTo,
  });

  ItemFilterParams copyWith({
    Object? search = const _Sentinel(),
    Object? sortBy = const _Sentinel(),
    Object? sortOrder = const _Sentinel(),
    Object? deviceType = const _Sentinel(),
    Object? assetStatus = const _Sentinel(),
    Object? isExpiring = const _Sentinel(),
    Object? isExpired = const _Sentinel(),
    Object? warrantyDate = const _Sentinel(),
    Object? warrantyDateFilterType = const _Sentinel(),
    Object? assignedTo = const _Sentinel(),
  }) {
    return ItemFilterParams(
      search:
          identical(search, const _Sentinel()) ? this.search : search as String,
      sortBy: identical(sortBy, const _Sentinel())
          ? this.sortBy
          : sortBy as String?,
      sortOrder: identical(sortOrder, const _Sentinel())
          ? this.sortOrder
          : sortOrder as String,
      deviceType: identical(deviceType, const _Sentinel())
          ? this.deviceType
          : deviceType as DeviceType?,
      assetStatus: identical(assetStatus, const _Sentinel())
          ? this.assetStatus
          : assetStatus as AssetStatus?,
      isExpiring: identical(isExpiring, const _Sentinel())
          ? this.isExpiring
          : isExpiring as bool,
      isExpired: identical(isExpired, const _Sentinel())
          ? this.isExpired
          : isExpired as bool,
      warrantyDate: identical(warrantyDate, const _Sentinel())
          ? this.warrantyDate
          : warrantyDate as DateTime?,
      warrantyDateFilterType: identical(warrantyDateFilterType, const _Sentinel())
          ? this.warrantyDateFilterType
          : warrantyDateFilterType as WarrantyDateFilterType?,
      assignedTo: identical(assignedTo, const _Sentinel())
          ? this.assignedTo
          : assignedTo as User?,
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
          isExpiring == other.isExpiring &&
          isExpired == other.isExpired &&
          warrantyDate == other.warrantyDate &&
          warrantyDateFilterType == other.warrantyDateFilterType &&
          assignedTo == other.assignedTo;

  @override
  int get hashCode =>
      search.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode ^
      deviceType.hashCode ^
      assetStatus.hashCode ^
      isExpiring.hashCode ^
      isExpired.hashCode ^
      warrantyDate.hashCode ^
      warrantyDateFilterType.hashCode ^
      assignedTo.hashCode;
}

// Sentinel class to distinguish between null and not-provided
class _Sentinel {
  const _Sentinel();
}
