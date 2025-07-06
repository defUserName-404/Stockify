sealed class DataException implements Exception {
  final String message;

  DataException(this.message);
}

final class DataNotFoundException extends DataException {
  DataNotFoundException(String message) : super(message);
}

final class DataConflictException extends DataException {
  DataConflictException(String message) : super(message);
}

final class DataExportException extends DataException {
  DataExportException(String message) : super(message);
}

final class DataImportException extends DataException {
  DataImportException(String message) : super(message);
}

final class DataParseException extends DataException {
  DataParseException(String message) : super(message);
}

final class DataValidationException extends DataException {
  DataValidationException(String message) : super(message);
}
