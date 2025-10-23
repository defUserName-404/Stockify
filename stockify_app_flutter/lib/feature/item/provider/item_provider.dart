import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';

class ItemProvider extends ChangeNotifier {
  final ItemService _itemService = ItemServiceImplementation.instance;

  List<Item> _filteredItems = [];
  ItemFilterParams _filterParams = ItemFilterParams();
  int _selectedRowIndex = -1;
  int _firstRowIndex = 0;
  int _rowsPerPage = 10;

  // Getters
  List<Item> get filteredItems => _filteredItems;
  ItemFilterParams get filterParams => _filterParams;

  int get selectedRowIndex => _selectedRowIndex;

  int get firstRowIndex => _firstRowIndex;

  int get rowsPerPage => _rowsPerPage;

  int get rowCount => _filteredItems.length;

  // Constructor
  ItemProvider({ItemFilterParams? initialFilterParams}) {
    if (initialFilterParams != null) {
      _filterParams = initialFilterParams;
    }
    refreshData();
  }

  // Initialize with filter params
  void initialize(ItemFilterParams? params) {
    if (params != null) {
      _filterParams = params;
    }
    refreshData();
  }

  // Refresh data from service
  void refreshData() {
    _filteredItems = _itemService.getFilteredItems(_filterParams);
    notifyListeners();
  }

  // Update filter params
  void updateFilterParams(ItemFilterParams params) {
    _filterParams = params;
    _selectedRowIndex = -1;
    _firstRowIndex = 0;
    refreshData();
  }

  // Search
  void search(String query) {
    _filterParams = _filterParams.copyWith(search: query);
    _selectedRowIndex = -1;
    _firstRowIndex = 0;
    refreshData();
  }

  // Sort
  void sort(String sortBy) {
    String sortOrder = 'ASC';
    if (_filterParams.sortBy == sortBy) {
      sortOrder = _filterParams.sortOrder == 'ASC' ? 'DESC' : 'ASC';
    }
    _filterParams =
        _filterParams.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    refreshData();
  }

  void setSortOrder(String order) {
    if (_filterParams.sortBy != null) {
      _filterParams = _filterParams.copyWith(sortOrder: order);
      refreshData();
    }
  }

  // Filter by device type
  void filterByDeviceType(DeviceType? type) {
    _filterParams = _filterParams.copyWith(deviceType: type);
    _selectedRowIndex = -1;
    _firstRowIndex = 0;
    refreshData();
  }

  // Filter by asset status
  void filterByAssetStatus(AssetStatus? status) {
    _filterParams = _filterParams.copyWith(assetStatus: status);
    _selectedRowIndex = -1;
    _firstRowIndex = 0;
    refreshData();
  }

  // Clear specific filter
  void clearDeviceTypeFilter() {
    _filterParams = _filterParams.copyWith(deviceType: null);
    refreshData();
  }

  void clearAssetStatusFilter() {
    _filterParams = _filterParams.copyWith(assetStatus: null);
    refreshData();
  }

  void clearWarrantyDateFilter() {
    _filterParams = _filterParams.copyWith(
      warrantyDate: null,
      warrantyDateFilterType: null,
    );
    refreshData();
  }

  void clearAssignedToFilter() {
    _filterParams = _filterParams.copyWith(assignedTo: null);
    refreshData();
  }

  void clearIsExpiringFilter() {
    _filterParams = _filterParams.copyWith(isExpiring: false);
    refreshData();
  }

  // Reset all filters
  void resetFilters() {
    _filterParams = ItemFilterParams();
    _selectedRowIndex = -1;
    _firstRowIndex = 0;
    refreshData();
  }

  // Row selection
  void setSelectedRowIndex(int index) {
    if (index >= 0 && index < _filteredItems.length) {
      _selectedRowIndex = index;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedRowIndex = -1;
    notifyListeners();
  }

  // Pagination
  void setRowsPerPage(int rows) {
    _rowsPerPage = rows;
    notifyListeners();
  }

  void setFirstRowIndex(int index) {
    _firstRowIndex = index;
    notifyListeners();
  }

  void onPageChanged(int rowIndex) {
    _firstRowIndex = rowIndex;
    _selectedRowIndex = rowIndex;
    notifyListeners();
  }

  // Navigation with keyboard
  void selectNextRow() {
    if (_selectedRowIndex < _filteredItems.length - 1) {
      _selectedRowIndex++;
      if (_selectedRowIndex >= _firstRowIndex + _rowsPerPage) {
        _firstRowIndex = (_selectedRowIndex ~/ _rowsPerPage) * _rowsPerPage;
      }
      notifyListeners();
    }
  }

  void selectPreviousRow() {
    if (_selectedRowIndex > 0) {
      _selectedRowIndex--;
      if (_selectedRowIndex < _firstRowIndex) {
        _firstRowIndex = (_selectedRowIndex ~/ _rowsPerPage) * _rowsPerPage;
      }
      notifyListeners();
    }
  }

  void nextPage() {
    final newFirstRowIndex = _firstRowIndex + _rowsPerPage;
    if (newFirstRowIndex < _filteredItems.length) {
      _firstRowIndex = newFirstRowIndex;
      _selectedRowIndex = newFirstRowIndex;
      notifyListeners();
    }
  }

  void previousPage() {
    final newFirstRowIndex = _firstRowIndex - _rowsPerPage;
    if (newFirstRowIndex >= 0) {
      _firstRowIndex = newFirstRowIndex;
      _selectedRowIndex = newFirstRowIndex;
      notifyListeners();
    }
  }

  // Get selected item
  Item? getSelectedItem() {
    if (_selectedRowIndex >= 0 && _selectedRowIndex < _filteredItems.length) {
      return _filteredItems[_selectedRowIndex];
    }
    return null;
  }

  // Get item at index
  Item getItemAt(int index) {
    return _filteredItems[index];
  }

  // CRUD operations
  void addItem(Item item) {
    _itemService.addItem(item);
    refreshData();
  }

  void updateItem(Item item) {
    _itemService.updateItem(item);
    refreshData();
  }

  void deleteItem(int itemId) {
    _itemService.deleteItem(itemId);
    _selectedRowIndex = -1;
    refreshData();
  }

  // Check if filters are active
  bool get hasActiveFilters {
    return _filterParams.deviceType != null ||
        _filterParams.assetStatus != null ||
        _filterParams.warrantyDate != null ||
        _filterParams.assignedTo != null;
  }
}