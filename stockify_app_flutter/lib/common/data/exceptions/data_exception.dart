abstract interface class DataException {}

final class DataExportException implements DataException {
  final String message;

  DataExportException(this.message);

  @override
  String toString() => message;
}

final class DataImportException implements DataException {
  final String message;

  DataImportException(this.message);

  @override
  String toString() => message;
}

final class DataGenerateReportException implements DataException {
  final String message;

  DataGenerateReportException(this.message);

  @override
  String toString() => '$message';
}

final class DataCancelledException implements DataException {
  final String message;

  DataCancelledException(this.message);

  @override
  String toString() => message;
}
