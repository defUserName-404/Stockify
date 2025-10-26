import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';

class SettingsProvider extends ChangeNotifier {
  final DataService _dataService;
  bool _showShortcuts = false;

  SettingsProvider(this._dataService);

  bool get showShortcuts => _showShortcuts;

  void toggleShortcuts() {
    _showShortcuts = !_showShortcuts;
    notifyListeners();
  }

  Future<void> importFromCsv() async {
    await _dataService.importItemsFromCsv();
  }

  Future<void> importFromExcel() async {
    await _dataService.importItemsFromExcel();
  }

  Future<void> exportToCsv() async {
    await _dataService.exportItemsToCsv();
  }

  Future<void> exportToExcel() async {
    await _dataService.exportItemsToExcel();
  }

  Future<void> generateReport() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Report',
      fileName: 'inventory_report.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (outputFile != null) {
      await _dataService.generatePdfReport(filePath: outputFile);
    } else {
      throw Exception('Report generation cancelled.');
    }
  }
}
