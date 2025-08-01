import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:stockify_app_flutter/common/ffi/ffi_user.dart';

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
  int assignedToID,
);

typedef DeleteItemByIdC = Void Function(Uint64 id);
typedef DeleteItemByIdDart = void Function(int id);

typedef GetFilteredItemsC = Pointer<Utf8> Function(
  Pointer<Utf8> deviceType,
  Pointer<Utf8> assetStatus,
  Int64 warrantyDate,
  Pointer<Utf8> search,
  Pointer<Utf8> sortBy,
  Pointer<Utf8> sortOrder,
);
typedef GetFilteredItemsDart = Pointer<Utf8> Function(
  Pointer<Utf8> deviceType,
  Pointer<Utf8> assetStatus,
  int warrantyDate,
  Pointer<Utf8> search,
  Pointer<Utf8> sortBy,
  Pointer<Utf8> sortOrder,
);

typedef FreeCStringC = Void Function(Pointer<Utf8> str);
typedef FreeCStringDart = void Function(Pointer<Utf8> str);

class FFIBridge {
  late DynamicLibrary _lib;
  late AddItemFullDart addItemFull;
  late GetAllItemsDart getAllItems;
  late GetItemByIdDart getItemById;
  late UpdateItemFullDart updateItemFull;
  late DeleteItemByIdDart deleteItemById;
  late GetFilteredItemsDart getFilteredItems;
  late FreeCStringDart freeCString;

  // User FFI
  late AddUserDart addUser;
  late GetAllUsersDart getAllUsers;
  late GetUserByIdDart getUserById;
  late UpdateUserDart updateUser;
  late DeleteUserByIdDart deleteUserById;
  late GetFilteredUsersDart getFilteredUsers;

  FFIBridge() {
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
    getFilteredItems =
        _lib.lookupFunction<GetFilteredItemsC, GetFilteredItemsDart>(
            'GetFilteredItems');
    freeCString =
        _lib.lookupFunction<FreeCStringC, FreeCStringDart>('FreeCString');

    // User FFI
    addUser = _lib.lookupFunction<AddUserC, AddUserDart>('AddUser');
    getAllUsers =
        _lib.lookupFunction<GetAllUsersC, GetAllUsersDart>('GetAllUsers');
    getUserById =
        _lib.lookupFunction<GetUserByIdC, GetUserByIdDart>('GetUserById');
    updateUser = _lib.lookupFunction<UpdateUserC, UpdateUserDart>('UpdateUser');
    deleteUserById = _lib
        .lookupFunction<DeleteUserByIdC, DeleteUserByIdDart>('DeleteUserById');
    getFilteredUsers =
        _lib.lookupFunction<GetFilteredUsersC, GetFilteredUsersDart>(
            'GetFilteredUsers');
  }
}
