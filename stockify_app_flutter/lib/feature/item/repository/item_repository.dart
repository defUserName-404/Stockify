import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:stockify_app_flutter/common/ffi/ffi_bridge.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';

import '../model/item_filter_param.dart';

class ItemRepository {
  ItemRepository._privateConstructor();

  static final ItemRepository _instance = ItemRepository._privateConstructor();

  static ItemRepository get instance => _instance;

  final FFIBridge _ffi = FFIBridge();

  // Helper method to convert Dart String to Pointer<Utf8>
  Pointer<Utf8> _toUtf8(String? str) =>
      str != null ? str.toNativeUtf8() : nullptr;

  // Helper method to convert Dart DateTime to Unix timestamp
  int _toUnixTimestamp(DateTime? date) =>
      date != null ? date.millisecondsSinceEpoch ~/ 1000 : 0;

  // Add a new item
  void addItem(Item item) {
    final assetNoPtr = _toUtf8(item.assetNo);
    final modelNoPtr = _toUtf8(item.modelNo);
    final deviceTypePtr = _toUtf8(item.deviceType.toString());
    final serialNoPtr = _toUtf8(item.serialNo);
    final receivedDate = _toUnixTimestamp(item.receivedDate);
    final warrantyDate = _toUnixTimestamp(item.warrantyDate);
    final assetStatusPtr = _toUtf8(item.assetStatus.toString());
    final hostNamePtr = _toUtf8(item.hostName);
    final ipPortPtr = _toUtf8(item.ipPort);
    final macAddressPtr = _toUtf8(item.macAddress);
    final osVersionPtr = _toUtf8(item.osVersion);
    final facePlateNamePtr = _toUtf8(item.facePlateName);
    final switchPortPtr = _toUtf8(item.switchPort);
    final switchIpAddressPtr = _toUtf8(item.switchIpAddress);
    final assignedToID = item.assignedTo?.id ?? 0;
    _ffi.addItemFull(
      assetNoPtr,
      modelNoPtr,
      deviceTypePtr,
      serialNoPtr,
      receivedDate,
      warrantyDate,
      assetStatusPtr,
      hostNamePtr,
      ipPortPtr,
      macAddressPtr,
      osVersionPtr,
      facePlateNamePtr,
      switchPortPtr,
      switchIpAddressPtr,
      assignedToID,
    );
    // Free allocated memory
    calloc.free(assetNoPtr);
    calloc.free(modelNoPtr);
    calloc.free(deviceTypePtr);
    calloc.free(serialNoPtr);
    calloc.free(assetStatusPtr);
    if (hostNamePtr != nullptr) calloc.free(hostNamePtr);
    if (ipPortPtr != nullptr) calloc.free(ipPortPtr);
    if (macAddressPtr != nullptr) calloc.free(macAddressPtr);
    if (osVersionPtr != nullptr) calloc.free(osVersionPtr);
    if (facePlateNamePtr != nullptr) calloc.free(facePlateNamePtr);
    if (switchPortPtr != nullptr) calloc.free(switchPortPtr);
    if (switchIpAddressPtr != nullptr) calloc.free(switchIpAddressPtr);
  }

  // Retrieve all items
  List<Item> getAllItems() {
    final resultPtr = _ffi.getAllItems();
    final jsonString = resultPtr.toDartString();
    _ffi.freeCString(resultPtr);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Item.fromJson(json)).toList();
  }

  // Retrieve an item by ID
  Item getItemById(int id) {
    final resultPtr = _ffi.getItemById(id);
    final jsonString = resultPtr.toDartString();
    _ffi.freeCString(resultPtr);
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Item.fromJson(jsonMap);
  }

  // Debug version of your Flutter updateItem function
  void updateItem(Item item) {
    final id = item.id;
    final assetNoPtr = _toUtf8(item.assetNo);
    final modelNoPtr = _toUtf8(item.modelNo);
    final deviceTypePtr = _toUtf8(item.deviceType.toString());
    final serialNoPtr = _toUtf8(item.serialNo);
    final receivedDate = _toUnixTimestamp(item.receivedDate);
    final warrantyDate = _toUnixTimestamp(item.warrantyDate);
    final assetStatusPtr = _toUtf8(item.assetStatus.toString());
    final hostNamePtr = _toUtf8(item.hostName);
    final ipPortPtr = _toUtf8(item.ipPort);
    final macAddressPtr = _toUtf8(item.macAddress);
    final osVersionPtr = _toUtf8(item.osVersion);
    final facePlateNamePtr = _toUtf8(item.facePlateName);
    final switchPortPtr = _toUtf8(item.switchPort);
    final switchIpAddressPtr = _toUtf8(item.switchIpAddress);
    final assignedToID = item.assignedTo?.id != null ? item.assignedTo!.id : 0;
    _ffi.updateItemFull(
      id!,
      assetNoPtr,
      modelNoPtr,
      deviceTypePtr,
      serialNoPtr,
      receivedDate,
      warrantyDate,
      assetStatusPtr,
      hostNamePtr,
      ipPortPtr,
      macAddressPtr,
      osVersionPtr,
      facePlateNamePtr,
      switchPortPtr,
      switchIpAddressPtr,
      assignedToID!,
    );
    // Free allocated memory
    calloc.free(assetNoPtr);
    calloc.free(modelNoPtr);
    calloc.free(deviceTypePtr);
    calloc.free(serialNoPtr);
    calloc.free(assetStatusPtr);
    if (hostNamePtr != nullptr) calloc.free(hostNamePtr);
    if (ipPortPtr != nullptr) calloc.free(ipPortPtr);
    if (macAddressPtr != nullptr) calloc.free(macAddressPtr);
    if (osVersionPtr != nullptr) calloc.free(osVersionPtr);
    if (facePlateNamePtr != nullptr) calloc.free(facePlateNamePtr);
    if (switchPortPtr != nullptr) calloc.free(switchPortPtr);
    if (switchIpAddressPtr != nullptr) calloc.free(switchIpAddressPtr);
  }

  // Delete an item by ID
  void deleteItem(int id) {
    _ffi.deleteItemById(id);
  }

  List<Item> getFilteredItems(ItemFilterParams params) {
    final searchPtr = _toUtf8(params.search);
    final deviceTypePtr = _toUtf8(params.deviceType?.toString());
    final assetStatusPtr = _toUtf8(params.assetStatus?.toString());
    final warrantyDate = _toUnixTimestamp(params.warrantyDate);
    final warrantyDateFilterTypePtr = _toUtf8(params.warrantyDateFilterType?.name);
    final assignedToID = params.assignedTo?.id ?? 0;
    final sortByPtr = _toUtf8(params.sortBy);
    final sortOrderPtr = _toUtf8(params.sortOrder);
    final resultPtr = _ffi.getFilteredItems(
      deviceTypePtr,
      assetStatusPtr,
      warrantyDate,
      warrantyDateFilterTypePtr,
      assignedToID,
      searchPtr,
      sortByPtr,
      sortOrderPtr,
    );
    final jsonString = resultPtr.toDartString();
    _ffi.freeCString(resultPtr);
    calloc.free(searchPtr);
    if (deviceTypePtr != nullptr) calloc.free(deviceTypePtr);
    if (assetStatusPtr != nullptr) calloc.free(assetStatusPtr);
    if (warrantyDateFilterTypePtr != nullptr) calloc.free(warrantyDateFilterTypePtr);
    if (sortByPtr != nullptr) calloc.free(sortByPtr);
    calloc.free(sortOrderPtr);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Item.fromJson(json)).toList();
  }
}
