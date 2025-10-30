import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';

class SettingsProvider extends ChangeNotifier {
  final DataService _dataService;
  bool _showShortcuts = false;

  bool get showShortcuts => _showShortcuts;

  SettingsProvider(this._dataService);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleShortcuts() {
    _showShortcuts = !_showShortcuts;
    notifyListeners();
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Backward compatible methods
  Future<void> importFromCsv() async {
    _setLoading(true);
    try {
      await _dataService.importItemsFromCsv();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> importFromExcel() async {
    _setLoading(true);
    try {
      await _dataService.importItemsFromExcel();
    } finally {
      _setLoading(false);
    }
  }

  // New methods with options and result
  Future<ImportResult> importFromCsvWithOptions(
      [ImportOptions? options]) async {
    _setLoading(true);
    try {
      return await _dataService.importItemsFromCsvWithOptions(options: options);
    } finally {
      _setLoading(false);
    }
  }

  Future<ImportResult> importFromExcelWithOptions(
      [ImportOptions? options]) async {
    _setLoading(true);
    try {
      return await _dataService.importItemsFromExcelWithOptions(
          options: options);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> exportToCsv() async {
    _setLoading(true);
    try {
      await _dataService.exportItemsToCsv();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> exportToExcel() async {
    _setLoading(true);
    try {
      await _dataService.exportItemsToExcel();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> exportTemplateCsv() async {
    _setLoading(true);
    try {
      await _dataService.exportTemplateCsv();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateReport() async {
    _setLoading(true);
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Report',
        fileName: 'inventory_report.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (outputFile != null) {
        await _dataService.generatePdfReport(filePath: outputFile);
      }
    } finally {
      _setLoading(false);
    }
  }
}