import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

// Define the C function signatures for all CRUD operations.
typedef AddItemFullC = Void Function(
  Pointer<Utf8> assetNo,
  Pointer<Utf8> modelNo,
  Pointer<Utf8> deviceType,
  Pointer<Utf8> serialNo,
  Int64 receivedDate,
  Int64 warrantyDate,
  Pointer<Utf8> assetStatus,
  Pointer<Utf8> hostName,
  Pointer<Utf8> ipPort,
  Pointer<Utf8> macAddress,
  Pointer<Utf8> osVersion,
  Pointer<Utf8> facePlateName,
  Pointer<Utf8> switchPort,
  Pointer<Utf8> switchIpAddress,
  Int32 isPasswordProtected,
  Uint64 assignedToID,
);
typedef AddItemFullDart = void Function(
  Pointer<Utf8> assetNo,
  Pointer<Utf8> modelNo,
  Pointer<Utf8> deviceType,
  Pointer<Utf8> serialNo,
  int receivedDate,
  int warrantyDate,
  Pointer<Utf8> assetStatus,
  Pointer<Utf8> hostName,
  Pointer<Utf8> ipPort,
  Pointer<Utf8> macAddress,
  Pointer<Utf8> osVersion,
  Pointer<Utf8> facePlateName,
  Pointer<Utf8> switchPort,
  Pointer<Utf8> switchIpAddress,
  int isPasswordProtected,
  int assignedToID,
);

typedef GetAllItemsC = Pointer<Utf8> Function();
typedef GetAllItemsDart = Pointer<Utf8> Function();

typedef GetItemByIdC = Pointer<Utf8> Function(Uint64 id);
typedef GetItemByIdDart = Pointer<Utf8> Function(int id);

typedef UpdateItemFullC = Void Function(
  Uint64 id,
  Pointer<Utf8> assetNo,
  Pointer<Utf8> modelNo,
  Pointer<Utf8> deviceType,
  Pointer<Utf8> serialNo,
  Int64 receivedDate,
  Int64 warrantyDate,
  Pointer<Utf8> assetStatus,
  Pointer<Utf8> hostName,
  Pointer<Utf8> ipPort,
  Pointer<Utf8> macAddress,
  Pointer<Utf8> osVersion,
  Pointer<Utf8> facePlateName,
  Pointer<Utf8> switchPort,
  Pointer<Utf8> switchIpAddress,
  Int32 isPasswordProtected,
  Uint64 assignedToID,
);
typedef UpdateItemFullDart = void Function(
  int id,
  Pointer<Utf8> assetNo,
  Pointer<Utf8> modelNo,
  Pointer<Utf8> deviceType,
  Pointer<Utf8> serialNo,
  int receivedDate,
  int warrantyDate,
  Pointer<Utf8> assetStatus,
  Pointer<Utf8> hostName,
  Pointer<Utf8> ipPort,
  Pointer<Utf8> macAddress,
  Pointer<Utf8> osVersion,
  Pointer<Utf8> facePlateName,
  Pointer<Utf8> switchPort,
  Pointer<Utf8> switchIpAddress,
  int isPasswordProtected,
  int assignedToID,
);

typedef DeleteItemByIdC = Void Function(Uint64 id);
typedef DeleteItemByIdDart = void Function(int id);

typedef FreeCStringC = Void Function(Pointer<Utf8> str);
typedef FreeCStringDart = void Function(Pointer<Utf8> str);

class ItemFFI {
  late DynamicLibrary _lib;
  late AddItemFullDart addItemFull;
  late GetAllItemsDart getAllItems;
  late GetItemByIdDart getItemById;
  late UpdateItemFullDart updateItemFull;
  late DeleteItemByIdDart deleteItemById;
  late FreeCStringDart freeCString;

  ItemFFI() {
    if (Platform.isWindows) {
      _lib = DynamicLibrary.open("inventory.dll");
    } else if (Platform.isLinux) {
      _lib = DynamicLibrary.open("libinventory.so");
    } else if (Platform.isMacOS) {
      _lib = DynamicLibrary.open("libinventory.dylib");
    } else {
      throw UnsupportedError("Platform not supported");
    }
    addItemFull =
        _lib.lookupFunction<AddItemFullC, AddItemFullDart>('AddItemFull');
    getAllItems =
        _lib.lookupFunction<GetAllItemsC, GetAllItemsDart>('GetAllItems');
    getItemById =
        _lib.lookupFunction<GetItemByIdC, GetItemByIdDart>('GetItemById');
    updateItemFull = _lib
        .lookupFunction<UpdateItemFullC, UpdateItemFullDart>('UpdateItemFull');
    deleteItemById = _lib
        .lookupFunction<DeleteItemByIdC, DeleteItemByIdDart>('DeleteItemById');
    freeCString =
        _lib.lookupFunction<FreeCStringC, FreeCStringDart>('FreeCString');
  }
}
