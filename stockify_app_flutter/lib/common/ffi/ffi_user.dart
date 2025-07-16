import 'dart:ffi';

import 'package:ffi/ffi.dart';

// Define C function signatures

typedef AddUserC = Void Function(
  Pointer<Utf8> userName,
  Pointer<Utf8> designation,
  Pointer<Utf8> sapId,
  Pointer<Utf8> ipPhone,
  Pointer<Utf8> roomNo,
  Pointer<Utf8> floor,
);
typedef AddUserDart = void Function(
  Pointer<Utf8> userName,
  Pointer<Utf8> designation,
  Pointer<Utf8> sapId,
  Pointer<Utf8> ipPhone,
  Pointer<Utf8> roomNo,
  Pointer<Utf8> floor,
);

typedef GetAllUsersC = Pointer<Utf8> Function();
typedef GetAllUsersDart = Pointer<Utf8> Function();

typedef GetUserByIdC = Pointer<Utf8> Function(Uint64 id);
typedef GetUserByIdDart = Pointer<Utf8> Function(int id);

typedef UpdateUserC = Void Function(
  Uint64 id,
  Pointer<Utf8> userName,
  Pointer<Utf8> designation,
  Pointer<Utf8> sapId,
  Pointer<Utf8> ipPhone,
  Pointer<Utf8> roomNo,
  Pointer<Utf8> floor,
);
typedef UpdateUserDart = void Function(
  int id,
  Pointer<Utf8> userName,
  Pointer<Utf8> designation,
  Pointer<Utf8> sapId,
  Pointer<Utf8> ipPhone,
  Pointer<Utf8> roomNo,
  Pointer<Utf8> floor,
);

typedef DeleteUserByIdC = Void Function(Uint64 id);
typedef DeleteUserByIdDart = void Function(int id);

typedef GetFilteredUsersC = Pointer<Utf8> Function(
  Pointer<Utf8> search,
  Pointer<Utf8> sortBy,
  Pointer<Utf8> sortOrder,
);
typedef GetFilteredUsersDart = Pointer<Utf8> Function(
  Pointer<Utf8> search,
  Pointer<Utf8> sortBy,
  Pointer<Utf8> sortOrder,
);
