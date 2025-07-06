class DataExportException implements Exception {
  final String message;
  DataExportException(this.message);
  @override
  String toString() => 'DataExportException: $message';
}

class DataImportException implements Exception {
  final String message;
  DataImportException(this.message);
  @override
  String toString() => 'DataImportException: $message';
}

class DataCancelledException implements Exception {
  final String message;
  DataCancelledException(this.message);
  @override
  String toString() => 'DataCancelledException: $message';
}