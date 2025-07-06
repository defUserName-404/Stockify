import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:stockify_app_flutter/common/ffi/ffi_bridge.dart';

import '../model/user.dart';

class UserRepository {
  UserRepository._privateConstructor();

  static final UserRepository _instance = UserRepository._privateConstructor();
  static final _ffi = FFIBridge();

  static UserRepository get instance => _instance;

  Pointer<Utf8> _toUtf8(String? str) =>
      str != null ? str.toNativeUtf8() : nullptr;

  List<User> getAllUsers() {
    final resultPtr = _ffi.getAllUsers();
    final jsonString = resultPtr.toDartString();
    _ffi.freeCString(resultPtr);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  User getUser(int id) {
    final resultPtr = _ffi.getUserById(id);
    final jsonString = resultPtr.toDartString();
    _ffi.freeCString(resultPtr);
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return User.fromJson(jsonMap);
  }

  void addUser(User user) {
    final userNamePtr = _toUtf8(user.userName);
    final designationPtr = _toUtf8(user.designation);
    final sapIdPtr = _toUtf8(user.sapId);
    final ipPhonePtr = _toUtf8(user.ipPhone);
    final roomNoPtr = _toUtf8(user.roomNo);
    final floorPtr = _toUtf8(user.floor);

    _ffi.addUser(
      userNamePtr,
      designationPtr,
      sapIdPtr,
      ipPhonePtr,
      roomNoPtr,
      floorPtr,
    );
    calloc.free(userNamePtr);
    calloc.free(designationPtr);
    calloc.free(sapIdPtr);
    calloc.free(ipPhonePtr);
    calloc.free(roomNoPtr);
    calloc.free(floorPtr);
  }

  void editUser(User user) {
    final userNamePtr = _toUtf8(user.userName);
    final designationPtr = _toUtf8(user.designation);
    final sapIdPtr = _toUtf8(user.sapId);
    final ipPhonePtr = _toUtf8(user.ipPhone);
    final roomNoPtr = _toUtf8(user.roomNo);
    final floorPtr = _toUtf8(user.floor);
    _ffi.updateUser(
      user.id!,
      userNamePtr,
      designationPtr,
      sapIdPtr,
      ipPhonePtr,
      roomNoPtr,
      floorPtr,
    );
    calloc.free(userNamePtr);
    calloc.free(designationPtr);
    calloc.free(sapIdPtr);
    calloc.free(ipPhonePtr);
    calloc.free(roomNoPtr);
    calloc.free(floorPtr);
  }

  void deleteUser(int id) {
    _ffi.deleteUserById(id);
  }
}
