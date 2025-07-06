import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../exceptions/data_exception.dart';

class DataService {
  final ItemService _itemService = ItemServiceImplementation.instance;
  final UserService _userService = UserServiceImplementation.instance;

  DataService._();

  static final _instance = DataService._();

  static DataService get instance => _instance;

  Future<void> exportItemsToCsv(BuildContext context) async {
    try {
      List<Item> items = _itemService.getAllItems();
      List<List<dynamic>> csvData = [];
      // Add header row
      csvData.add([
        'ID',
        'AssetNo',
        'ModelNo',
        'DeviceType',
        'SerialNo',
        'ReceivedDate',
        'WarrantyDate',
        'AssetStatus',
        'HostName',
        'IpPort',
        'MacAddress',
        'OsVersion',
        'FacePlateName',
        'SwitchPort',
        'SwitchIpAddress',
        'IsPasswordProtected',
        'AssignedToID',
        'AssignedToUserName',
      ]);
      // Add item data
      for (var item in items) {
        csvData.add([
          item.id,
          item.assetNo,
          item.modelNo,
          item.deviceType.name,
          item.serialNo,
          item.receivedDate?.toIso8601String(),
          item.warrantyDate.toIso8601String(),
          item.assetStatus.name,
          item.hostName,
          item.ipPort,
          item.macAddress,
          item.osVersion,
          item.facePlateName,
          item.switchPort,
          item.switchIpAddress,
          item.isPasswordProtected == true ? 1 : 0,
          item.assignedTo?.id,
          item.assignedTo?.userName,
        ]);
      }
      String csv = const ListToCsvConverter().convert(csvData);
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Items CSV',
        fileName: 'items_export.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(csv);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Items exported successfully to $outputFile')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export cancelled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting items: $e')),
      );
    }
  }

  Future<void> importItemsFromCsv(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String csvString = await file.readAsString();
        List<List<dynamic>> csvList =
            const CsvToListConverter().convert(csvString);
        if (csvList.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV file is empty')),
          );
          return;
        }
        List<dynamic> header = csvList[0];
        List<List<dynamic>> data = csvList.sublist(1);
        int importedCount = 0;
        for (var row in data) {
          try {
            Map<String, dynamic> itemMap = {};
            for (int i = 0; i < header.length; i++) {
              itemMap[header[i].toString()] = row[i];
            }
            // Convert data types
            DeviceType deviceType = DeviceType.values.firstWhere(
                (e) => e.name == itemMap['DeviceType'],
                orElse: () => DeviceType.Unknown);
            AssetStatus assetStatus = AssetStatus.values.firstWhere(
                (e) => e.name == itemMap['AssetStatus'],
                orElse: () => AssetStatus.Unknown);
            DateTime? receivedDate;
            if (itemMap['ReceivedDate'] != null &&
                itemMap['ReceivedDate'].toString().isNotEmpty) {
              receivedDate = DateTime.tryParse(itemMap['ReceivedDate']);
            }
            DateTime warrantyDate =
                DateTime.tryParse(itemMap['WarrantyDate']) ?? DateTime.now();
            User? assignedTo;
            if (itemMap['AssignedToID'] != null) {
              try {
                assignedTo = _userService.getUser(itemMap['AssignedToID']);
              } catch (e) {
                assignedTo = null;
              }
            }
            Item item = Item(
              assetNo: itemMap['AssetNo'].toString(),
              modelNo: itemMap['ModelNo'].toString(),
              deviceType: deviceType,
              serialNo: itemMap['SerialNo'].toString(),
              receivedDate: receivedDate,
              warrantyDate: warrantyDate,
              assetStatus: assetStatus,
              hostName: itemMap['HostName']?.toString(),
              ipPort: itemMap['IpPort']?.toString(),
              macAddress: itemMap['MacAddress']?.toString(),
              osVersion: itemMap['OsVersion']?.toString(),
              facePlateName: itemMap['FacePlateName']?.toString(),
              switchPort: itemMap['SwitchPort']?.toString(),
              switchIpAddress: itemMap['SwitchIpAddress']?.toString(),
              isPasswordProtected: itemMap['IsPasswordProtected'] == 1,
              assignedTo: assignedTo,
            );
            _itemService.addItem(item);
            importedCount++;
          } catch (e) {
            throw DataImportException('Error processing row: $row, Error: $e');
          }
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Successfully imported $importedCount items')),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import cancelled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing items: $e')),
      );
    }
  }

  Future<void> exportItemsToExcel(BuildContext context) async {
    try {
      List<Item> items = _itemService.getAllItems();
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      // Add header row
      List<String> header = [
        'ID',
        'AssetNo',
        'ModelNo',
        'DeviceType',
        'SerialNo',
        'ReceivedDate',
        'WarrantyDate',
        'AssetStatus',
        'HostName',
        'IpPort',
        'MacAddress',
        'OsVersion',
        'FacePlateName',
        'SwitchPort',
        'SwitchIpAddress',
        'IsPasswordProtected',
        'AssignedToID',
        'AssignedToUserName',
      ];
      sheetObject.insertRowIterables(header, 0);
      // Add item data
      for (int i = 0; i < items.length; i++) {
        Item item = items[i];
        List<dynamic> rowData = [
          item.id,
          item.assetNo,
          item.modelNo,
          item.deviceType.name,
          item.serialNo,
          item.receivedDate?.toIso8601String(),
          item.warrantyDate.toIso8601String(),
          item.assetStatus.name,
          item.hostName,
          item.ipPort,
          item.macAddress,
          item.osVersion,
          item.facePlateName,
          item.switchPort,
          item.switchIpAddress,
          item.isPasswordProtected == true ? 1 : 0,
          item.assignedTo?.id,
          item.assignedTo?.userName,
        ];
        sheetObject.insertRowIterables(rowData, i + 1);
      }
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Items Excel',
        fileName: 'items_export.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (outputFile != null) {
        final file = File(outputFile);
        List<int>? excelBytes = excel.encode();
        if (excelBytes != null) {
          await file.writeAsBytes(excelBytes);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Items exported successfully to $outputFile')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to encode Excel file')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export cancelled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting items: $e')),
      );
    }
  }

  Future<void> importItemsFromExcel(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        int importedCount = 0;
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet == null || sheet.rows.isEmpty) continue;
          List<dynamic> header = sheet.rows[0].map((e) => e?.value).toList();
          for (int i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            try {
              Map<String, dynamic> itemMap = {};
              for (int j = 0; j < header.length; j++) {
                itemMap[header[j].toString()] = row[j]?.value;
              }
              // Convert data types
              DeviceType deviceType = DeviceType.values.firstWhere(
                  (e) => e.name == itemMap['DeviceType'],
                  orElse: () => DeviceType.Unknown);
              AssetStatus assetStatus = AssetStatus.values.firstWhere(
                  (e) => e.name == itemMap['AssetStatus'],
                  orElse: () => AssetStatus.Unknown);
              DateTime? receivedDate;
              if (itemMap['ReceivedDate'] != null &&
                  itemMap['ReceivedDate'].toString().isNotEmpty) {
                receivedDate = DateTime.tryParse(itemMap['ReceivedDate']);
              }
              DateTime warrantyDate =
                  DateTime.tryParse(itemMap['WarrantyDate']) ?? DateTime.now();
              User? assignedTo;
              if (itemMap['AssignedToID'] != null) {
                try {
                  assignedTo = _userService.getUser(itemMap['AssignedToID']);
                } catch (e) {
                  // User not found, assign null
                  assignedTo = null;
                }
              }
              Item item = Item(
                assetNo: itemMap['AssetNo'].toString(),
                modelNo: itemMap['ModelNo'].toString(),
                deviceType: deviceType,
                serialNo: itemMap['SerialNo'].toString(),
                receivedDate: receivedDate,
                warrantyDate: warrantyDate,
                assetStatus: assetStatus,
                hostName: itemMap['HostName']?.toString(),
                ipPort: itemMap['IpPort']?.toString(),
                macAddress: itemMap['MacAddress']?.toString(),
                osVersion: itemMap['OsVersion']?.toString(),
                facePlateName: itemMap['FacePlateName']?.toString(),
                switchPort: itemMap['SwitchPort']?.toString(),
                switchIpAddress: itemMap['SwitchIpAddress']?.toString(),
                isPasswordProtected: itemMap['IsPasswordProtected'] == 1,
                assignedTo: assignedTo,
              );
              _itemService.addItem(item);
              importedCount++;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error processing row: $row, Error: $e')),
              );
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully imported $importedCount items')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import cancelled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing items: $e')),
      );
    }
  }
}
