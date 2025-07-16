class UserFilterParams {
  final String search;
  final String? sortBy;
  final String sortOrder;

  UserFilterParams({
    this.search = '',
    this.sortBy,
    this.sortOrder = 'ASC',
  });

  UserFilterParams copyWith({
    Object? search = const _Sentinel(),
    Object? sortBy = const _Sentinel(),
    Object? sortOrder = const _Sentinel(),
  }) {
    return UserFilterParams(
      search:
          identical(search, const _Sentinel()) ? this.search : search as String,
      sortBy:
          identical(sortBy, const _Sentinel()) ? this.sortBy : sortBy as String?,
      sortOrder: identical(sortOrder, const _Sentinel())
          ? this.sortOrder
          : sortOrder as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserFilterParams &&
          runtimeType == other.runtimeType &&
          search == other.search &&
          sortBy == other.sortBy &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      search.hashCode ^
      sortBy.hashCode ^ sortOrder.hashCode;
}

// Sentinel class to distinguish between null and not-provided
class _Sentinel {
  const _Sentinel();
}