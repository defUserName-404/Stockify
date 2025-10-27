import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:stockify_app_flutter/common/data/service/report_service.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../exceptions/data_exception.dart';

// Import Options
class ImportOptions {
  final bool skipErrors;
  final bool updateExisting;
  final String matchField; // 'assetNo' or 'serialNo'
  final bool validateOnly;
  final Function(int current, int total)? onProgress;

  ImportOptions({
    this.skipErrors = false,
    this.updateExisting = false,
    this.matchField = 'assetNo',
    this.validateOnly = false,
    this.onProgress,
  });
}

// Import Result
class ImportResult {
  final int totalRows;
  int successCount;
  int errorCount;
  int updatedCount;
  final List<ImportError> errors;
  final List<String> warnings;

  ImportResult({
    required this.totalRows,
    this.successCount = 0,
    this.errorCount = 0,
    this.updatedCount = 0,
    List<ImportError>? errors,
    List<String>? warnings,
  })
      : errors = errors ?? [],
        warnings = warnings ?? [];

  bool get hasErrors => errorCount > 0;

  bool get isSuccess => errorCount == 0 && successCount > 0;

  @override
  String toString() {
    return 'ImportResult(total: $totalRows, success: $successCount, '
        'updated: $updatedCount, errors: $errorCount)';
  }
}

// Import Error
class ImportError {
  final int row;
  final String? field;
  final String message;

  ImportError({
    required this.row,
    this.field,
    required this.message,
  });

  @override
  String toString() {
    if (field != null) {
      return 'Row $row, Field "$field": $message';
    }
    return 'Row $row: $message';
  }
}

class DataService {
  final ItemService _itemService = ItemServiceImplementation.instance;
  final UserService _userService = UserServiceImplementation.instance;

  DataService._();

  static final DataService _instance = DataService._();

  static DataService get instance => _instance;

  // ========== EXPORT METHODS (Unchanged) ==========

  Future<void> exportItemsToCsv() async {
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
        'AssignedToID',
        'AssignedToUserName',
      ]);
      // Add item data
      for (var item in items) {
        csvData.add([
          item.id ?? '',
          item.assetNo,
          item.modelNo,
          item.deviceType.name,
          item.serialNo,
          item.receivedDate != null
              ? DateFormat('yyyy-MM-dd').format(item.receivedDate!)
              : '',
          DateFormat('yyyy-MM-dd').format(item.warrantyDate),
          item.assetStatus.name,
          item.hostName ?? '',
          item.ipPort ?? '',
          item.macAddress ?? '',
          item.osVersion ?? '',
          item.facePlateName ?? '',
          item.switchPort ?? '',
          item.switchIpAddress ?? '',
          item.assignedTo?.id ?? '',
          item.assignedTo?.userName ?? '',
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
      } else {
        throw DataCancelledException('Export cancelled');
      }
    } catch (e) {
      throw DataExportException('Error exporting items: $e');
    }
  }

  Future<void> exportItemsToExcel() async {
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
        'AssignedToID',
        'AssignedToUserName',
      ];
      sheetObject.insertRowIterables(
          header.map((e) => TextCellValue(e)).toList(), 0);
      // Add item data
      for (int i = 0; i < items.length; i++) {
        Item item = items[i];
        List<dynamic> rowData = [
          item.id ?? '',
          item.assetNo,
          item.modelNo,
          item.deviceType.name,
          item.serialNo,
          item.receivedDate != null
              ? DateFormat('yyyy-MM-dd').format(item.receivedDate!)
              : '',
          DateFormat('yyyy-MM-dd').format(item.warrantyDate),
          item.assetStatus.name,
          item.hostName ?? '',
          item.ipPort ?? '',
          item.macAddress ?? '',
          item.osVersion ?? '',
          item.facePlateName ?? '',
          item.switchPort ?? '',
          item.switchIpAddress ?? '',
          item.assignedTo?.id ?? '',
          item.assignedTo?.userName ?? '',
        ];
        sheetObject.insertRowIterables(
            rowData.map((e) => TextCellValue(e.toString())).toList(), i + 1);
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
        } else {
          throw DataExportException('Failed to encode Excel file');
        }
      } else {
        throw DataCancelledException('Export cancelled');
      }
    } catch (e) {
      if (e is DataCancelledException) rethrow;
      throw DataExportException('Error exporting items: $e');
    }
  }

  // Export template with sample data
  Future<void> exportTemplateCsv() async {
    try {
      List<List<dynamic>> csvData = [];
      // Add header row
      csvData.add([
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
        'AssignedToID',
      ]);
      // Add sample row with instructions
      csvData.add([
        'ASSET001',
        'Dell OptiPlex 7090',
        'Desktop', // Use enum names: Desktop, Laptop, Server, etc.
        'SN12345678',
        '2024-01-15', // Format: yyyy-MM-dd or dd/MM/yyyy or MM/dd/yyyy
        '2027-01-15',
        'Available', // Use enum names: Available, InUse, Maintenance, etc.
        'WORKSTATION-01',
        '192.168.1.100',
        'AA:BB:CC:DD:EE:FF',
        'Windows 11',
        'Building A - Floor 2',
        'Port 24',
        '192.168.1.1',
        '', // Leave empty if not assigned
      ]);

      String csv = const ListToCsvConverter().convert(csvData);
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Template CSV',
        fileName: 'items_template.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(csv);
      } else {
        throw DataCancelledException('Export cancelled');
      }
    } catch (e) {
      throw DataExportException('Error exporting template: $e');
    }
  }

  // ========== ENHANCED IMPORT METHODS ==========

  // Backward compatible - delegates to enhanced version with default options
  Future<void> importItemsFromCsv() async {
    final result = await importItemsFromCsvWithOptions();
    if (result.hasErrors && !result.isSuccess) {
      throw DataImportException(
          'Import failed: ${result.errorCount} errors. First error: ${result
              .errors.first}');
    }
  }

  // Enhanced CSV import with options
  Future<ImportResult> importItemsFromCsvWithOptions({
    ImportOptions? options,
  }) async {
    options ??= ImportOptions();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) {
        throw DataCancelledException('Import cancelled');
      }

      File file = File(result.files.single.path!);
      String csvString = await file.readAsString();
      List<List<dynamic>> csvList =
      const CsvToListConverter().convert(csvString);

      if (csvList.isEmpty) {
        throw DataImportException('CSV file is empty');
      }

      return await _processImport(csvList, options);
    } catch (e) {
      if (e is DataCancelledException) rethrow;
      if (e is DataImportException) rethrow;
      throw DataImportException('Error importing items: $e');
    }
  }

  // Backward compatible - delegates to enhanced version with default options
  Future<void> importItemsFromExcel() async {
    final result = await importItemsFromExcelWithOptions();
    if (result.hasErrors && !result.isSuccess) {
      throw DataImportException(
          'Import failed: ${result.errorCount} errors. First error: ${result
              .errors.first}');
    }
  }

  // Enhanced Excel import with options
  Future<ImportResult> importItemsFromExcelWithOptions({
    ImportOptions? options,
  }) async {
    options ??= ImportOptions();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'], // Only support .xlsx format
      );

      if (result == null || result.files.single.path == null) {
        throw DataCancelledException('Import cancelled');
      }

      File file = File(result.files.single.path!);
      String fileName = result.files.single.name.toLowerCase();

      // Validate file extension
      if (!fileName.endsWith('.xlsx')) {
        throw DataImportException(
            'Only .xlsx format is supported. Please convert your Excel file to .xlsx format and try again.'
        );
      }

      var bytes = file.readAsBytesSync();

      // Try to decode Excel file
      Excel? excel;
      try {
        excel = Excel.decodeBytes(bytes);
      } catch (e) {
        throw DataImportException(
            'Failed to read Excel file. Please ensure it is a valid .xlsx file. Error: $e'
        );
      }

      // Check if file has any sheets
      if (excel.tables.isEmpty) {
        throw DataImportException('Excel file contains no sheets');
      }

      // Get first sheet
      var table = excel.tables.keys.first;
      var sheet = excel.tables[table];

      if (sheet == null || sheet.rows.isEmpty) {
        throw DataImportException('Excel file is empty');
      }

      // Convert Excel format to CSV-like list
      List<List<dynamic>> csvList = sheet.rows
          .map((row) => row.map((cell) => cell?.value).toList())
          .toList();

      return await _processImport(csvList, options);
    } catch (e) {
      if (e is DataCancelledException) rethrow;
      if (e is DataImportException) rethrow;
      throw DataImportException('Error importing Excel file: $e');
    }
  }

  // Core import processing logic
  Future<ImportResult> _processImport(List<List<dynamic>> csvList,
      ImportOptions options,) async {
    List<dynamic> header = csvList[0].map((h) => h.toString().trim()).toList();
    List<List<dynamic>> data = csvList.sublist(1);

    ImportResult result = ImportResult(totalRows: data.length);

    for (int rowIndex = 0; rowIndex < data.length; rowIndex++) {
      var row = data[rowIndex];
      int rowNumber = rowIndex + 2; // +2 for header and 0-index

      // Report progress
      options.onProgress?.call(rowIndex + 1, data.length);

      // Skip completely empty rows
      if (row.every((cell) =>
      cell == null || cell
          .toString()
          .trim()
          .isEmpty)) {
        result.warnings.add('Row $rowNumber: Skipped empty row');
        continue;
      }

      try {
        // Build item map
        Map<String, dynamic> itemMap = {};
        for (int i = 0; i < header.length && i < row.length; i++) {
          itemMap[header[i]] = row[i];
        }

        // Validate
        List<ImportError> validationErrors =
        _validateItemData(itemMap, rowNumber);
        if (validationErrors.isNotEmpty) {
          result.errors.addAll(validationErrors);
          result.errorCount++;
          if (!options.skipErrors) {
            return result;
          }
          continue;
        }

        // Skip if validation only
        if (options.validateOnly) {
          result.successCount++;
          continue;
        }

        // Parse item
        Item item = _parseItemFromMap(itemMap);

        // Handle update existing
        if (options.updateExisting) {
          Item? existing = _findExistingItem(item, options.matchField);
          if (existing != null) {
            item = _copyItemWithId(item, existing.id);
            _itemService.updateItem(item);
            result.updatedCount++;
            result.successCount++;
            result.warnings
                .add('Row $rowNumber: Updated existing item ${item.assetNo}');
            continue;
          }
        }

        // Add new item
        _itemService.addItem(item);
        result.successCount++;
      } catch (e) {
        result.errors.add(ImportError(
          row: rowNumber,
          message: e.toString(),
        ));
        result.errorCount++;
        if (!options.skipErrors) {
          return result;
        }
      }
    }

    return result;
  }

  // Validation logic
  List<ImportError> _validateItemData(Map<String, dynamic> itemMap,
      int rowNumber) {
    List<ImportError> errors = [];

    // Required fields
    if (itemMap['AssetNo'] == null ||
        itemMap['AssetNo']
            .toString()
            .trim()
            .isEmpty) {
      errors.add(ImportError(
        row: rowNumber,
        field: 'AssetNo',
        message: 'AssetNo is required',
      ));
    }

    if (itemMap['ModelNo'] == null ||
        itemMap['ModelNo']
            .toString()
            .trim()
            .isEmpty) {
      errors.add(ImportError(
        row: rowNumber,
        field: 'ModelNo',
        message: 'ModelNo is required',
      ));
    }

    if (itemMap['SerialNo'] == null ||
        itemMap['SerialNo']
            .toString()
            .trim()
            .isEmpty) {
      errors.add(ImportError(
        row: rowNumber,
        field: 'SerialNo',
        message: 'SerialNo is required',
      ));
    }

    // Validate DeviceType enum
    if (itemMap['DeviceType'] == null ||
        itemMap['DeviceType']
            .toString()
            .trim()
            .isEmpty) {
      errors.add(ImportError(
        row: rowNumber,
        field: 'DeviceType',
        message: 'DeviceType is required',
      ));
    } else {
      try {
        DeviceType.values.firstWhere(
              (e) =>
          e.name.toLowerCase() ==
              itemMap['DeviceType'].toString().toLowerCase(),
        );
      } catch (e) {
        errors.add(ImportError(
          row: rowNumber,
          field: 'DeviceType',
          message:
          'Invalid DeviceType "${itemMap['DeviceType']}". Valid values: ${DeviceType
              .values.map((e) => e.name).join(", ")}',
        ));
      }
    }

    // Validate AssetStatus enum
    if (itemMap['AssetStatus'] == null ||
        itemMap['AssetStatus']
            .toString()
            .trim()
            .isEmpty) {
      errors.add(ImportError(
        row: rowNumber,
        field: 'AssetStatus',
        message: 'AssetStatus is required',
      ));
    } else {
      try {
        AssetStatus.values.firstWhere(
              (e) =>
          e.name.toLowerCase() ==
              itemMap['AssetStatus'].toString().toLowerCase(),
        );
      } catch (e) {
        errors.add(ImportError(
          row: rowNumber,
          field: 'AssetStatus',
          message:
          'Invalid AssetStatus "${itemMap['AssetStatus']}". Valid values: ${AssetStatus
              .values.map((e) => e.name).join(", ")}',
        ));
      }
    }

    // Validate dates
    if (itemMap['ReceivedDate'] != null &&
        itemMap['ReceivedDate']
            .toString()
            .trim()
            .isNotEmpty) {
      if (_parseFlexibleDate(itemMap['ReceivedDate'].toString()) == null) {
        errors.add(ImportError(
          row: rowNumber,
          field: 'ReceivedDate',
          message: 'Invalid date format. Use yyyy-MM-dd or dd/MM/yyyy',
        ));
      }
    }

    if (itemMap['WarrantyDate'] == null ||
        itemMap['WarrantyDate']
            .toString()
            .trim()
            .isEmpty) {
      errors.add(ImportError(
        row: rowNumber,
        field: 'WarrantyDate',
        message: 'WarrantyDate is required',
      ));
    } else {
      if (_parseFlexibleDate(itemMap['WarrantyDate'].toString()) == null) {
        errors.add(ImportError(
          row: rowNumber,
          field: 'WarrantyDate',
          message: 'Invalid date format. Use yyyy-MM-dd or dd/MM/yyyy',
        ));
      }
    }

    return errors;
  }

  // Parse flexible date formats
  DateTime? _parseFlexibleDate(String dateStr) {
    if (dateStr
        .trim()
        .isEmpty) return null;

    // List of date formats to try
    List<DateFormat> formats = [
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('yyyy/MM/dd'),
      DateFormat('dd.MM.yyyy'),
    ];

    // Try ISO 8601 first
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      // Try other formats
      for (DateFormat format in formats) {
        try {
          return format.parse(dateStr);
        } catch (e) {
          continue;
        }
      }
    }

    return null;
  }

  // Find existing item by match field
  Item? _findExistingItem(Item item, String matchField) {
    try {
      List<Item> allItems = _itemService.getAllItems();

      switch (matchField.toLowerCase()) {
        case 'assetno':
        case 'assetnumber':
          return allItems.firstWhere(
                (i) => i.assetNo.toLowerCase() == item.assetNo.toLowerCase(),
          );
        case 'serialno':
        case 'serialnumber':
          return allItems.firstWhere(
                (i) => i.serialNo.toLowerCase() == item.serialNo.toLowerCase(),
          );
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Parse item from map
  Item _parseItemFromMap(Map<String, dynamic> itemMap) {
    DeviceType deviceType = DeviceType.values.firstWhere(
          (e) =>
      e.name.toLowerCase() == itemMap['DeviceType'].toString().toLowerCase(),
    );

    AssetStatus assetStatus = AssetStatus.values.firstWhere(
          (e) =>
      e.name.toLowerCase() == itemMap['AssetStatus'].toString().toLowerCase(),
    );

    DateTime? receivedDate;
    if (itemMap['ReceivedDate'] != null &&
        itemMap['ReceivedDate']
            .toString()
            .trim()
            .isNotEmpty) {
      receivedDate = _parseFlexibleDate(itemMap['ReceivedDate'].toString());
    }

    DateTime warrantyDate =
        _parseFlexibleDate(itemMap['WarrantyDate'].toString()) ??
            DateTime.now();

    User? assignedTo;
    if (itemMap['AssignedToID'] != null &&
        itemMap['AssignedToID']
            .toString()
            .trim()
            .isNotEmpty) {
      try {
        // Handle both int and string IDs
        var assignedToId = itemMap['AssignedToID'];
        if (assignedToId is String) {
          assignedToId = int.tryParse(assignedToId);
        }
        if (assignedToId != null) {
          assignedTo = _userService.getUser(assignedToId);
        }
      } catch (e) {
        assignedTo = null;
      }
    }

    return Item(
      assetNo: itemMap['AssetNo'].toString().trim(),
      modelNo: itemMap['ModelNo'].toString().trim(),
      deviceType: deviceType,
      serialNo: itemMap['SerialNo'].toString().trim(),
      receivedDate: receivedDate,
      warrantyDate: warrantyDate,
      assetStatus: assetStatus,
      hostName: itemMap['HostName']?.toString().trim(),
      ipPort: itemMap['IpPort']?.toString().trim(),
      macAddress: itemMap['MacAddress']?.toString().trim(),
      osVersion: itemMap['OsVersion']?.toString().trim(),
      facePlateName: itemMap['FacePlateName']?.toString().trim(),
      switchPort: itemMap['SwitchPort']?.toString().trim(),
      switchIpAddress: itemMap['SwitchIpAddress']?.toString().trim(),
      assignedTo: assignedTo,
    );
  }

  // Helper to copy item with new ID (for updates)
  Item _copyItemWithId(Item item, int? id) {
    return Item(
      id: id,
      assetNo: item.assetNo,
      modelNo: item.modelNo,
      deviceType: item.deviceType,
      serialNo: item.serialNo,
      receivedDate: item.receivedDate,
      warrantyDate: item.warrantyDate,
      assetStatus: item.assetStatus,
      hostName: item.hostName,
      ipPort: item.ipPort,
      macAddress: item.macAddress,
      osVersion: item.osVersion,
      facePlateName: item.facePlateName,
      switchPort: item.switchPort,
      switchIpAddress: item.switchIpAddress,
      assignedTo: item.assignedTo,
    );
  }

  // ========== PDF REPORT (Unchanged) ==========

  Future<void> generatePdfReport({String? filePath}) async {
    try {
      final items = _itemService.getAllItems();
      if (filePath != null) {
        await ReportService.generatePdfReport(items, filePath: filePath);
      } else {
        await ReportService.generatePdfReport(items);
      }
    } catch (e) {
      throw DataGenerateReportException('Error generating report: $e');
    }
  }
}