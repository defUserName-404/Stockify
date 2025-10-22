import 'dart:ffi';
import 'dart:io';

import 'ffi_item.dart';
import 'ffi_user.dart';

class FFIBridge {
  late DynamicLibrary _lib;

  // Item FFI
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
      _lib = DynamicLibrary.open("libinventory.dll");
    } else if (Platform.isLinux) {
      _lib = DynamicLibrary.open("libinventory.so");
    } else if (Platform.isMacOS) {
      _lib = DynamicLibrary.open("libinventory.dylib");
    } else {
      throw UnsupportedError("Platform not supported");
    }

    // Item FFI
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
