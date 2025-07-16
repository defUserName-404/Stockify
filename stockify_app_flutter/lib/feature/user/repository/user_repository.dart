import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:stockify_app_flutter/common/ffi/ffi_bridge.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';

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
    if (designationPtr != nullptr) calloc.free(designationPtr);
    if (sapIdPtr != nullptr) calloc.free(sapIdPtr);
    if (ipPhonePtr != nullptr) calloc.free(ipPhonePtr);
    if (roomNoPtr != nullptr) calloc.free(roomNoPtr);
    if (floorPtr != nullptr) calloc.free(floorPtr);
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
    if (designationPtr != nullptr) calloc.free(designationPtr);
    if (sapIdPtr != nullptr) calloc.free(sapIdPtr);
    if (ipPhonePtr != nullptr) calloc.free(ipPhonePtr);
    if (roomNoPtr != nullptr) calloc.free(roomNoPtr);
    if (floorPtr != nullptr) calloc.free(floorPtr);
  }

  void deleteUser(int id) {
    _ffi.deleteUserById(id);
  }

  List<User> getFilteredUsers(UserFilterParams params) {
    final searchPtr = _toUtf8(params.search);
    final sortByPtr = _toUtf8(params.sortBy);
    final sortOrderPtr = _toUtf8(params.sortOrder);
    final resultPtr = _ffi.getFilteredUsers(
      searchPtr,
      sortByPtr,
      sortOrderPtr,
    );
    final jsonString = resultPtr.toDartString();
    _ffi.freeCString(resultPtr);
    calloc.free(searchPtr);
    if (sortByPtr != nullptr) calloc.free(sortByPtr);
    calloc.free(sortOrderPtr);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}
