import 'dart:ffi';

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
  Pointer<Utf8> warrantyDateFilterType,
  Uint64 assignedToID,
  Char isExpiring,
  Pointer<Utf8> search,
  Pointer<Utf8> sortBy,
  Pointer<Utf8> sortOrder,
);
typedef GetFilteredItemsDart = Pointer<Utf8> Function(
  Pointer<Utf8> deviceType,
  Pointer<Utf8> assetStatus,
  int warrantyDate,
  Pointer<Utf8> warrantyDateFilterType,
  int assignedToID,
  int isExpiring,
  Pointer<Utf8> search,
  Pointer<Utf8> sortBy,
  Pointer<Utf8> sortOrder,
);

typedef FreeCStringC = Void Function(Pointer<Utf8> str);
typedef FreeCStringDart = void Function(Pointer<Utf8> str);
