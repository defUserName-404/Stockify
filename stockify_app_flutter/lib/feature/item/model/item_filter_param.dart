import 'asset_status.dart';
import 'device_type.dart';

class ItemFilterParams {
  final String search;
  final String sortBy;
  final String sortOrder;
  final DeviceType? deviceType;
  final AssetStatus? assetStatus;
  final bool isExpiring;
  final int page;

  ItemFilterParams({
    this.search = '',
    this.sortBy = 'assetNo',
    this.sortOrder = 'ASC',
    this.deviceType,
    this.assetStatus,
    this.isExpiring = false,
    this.page = 1,
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
          isExpiring == other.isExpiring &&
          page == other.page;

  @override
  int get hashCode =>
      search.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode ^
      deviceType.hashCode ^
      assetStatus.hashCode ^
      isExpiring.hashCode ^
      page.hashCode;
}

// Sentinel class to distinguish between null and not-provided
class _Sentinel {
  const _Sentinel();
}
