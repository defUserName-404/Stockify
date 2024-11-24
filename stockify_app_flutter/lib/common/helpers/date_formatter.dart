class DateFormatter {
  DateFormatter._();

  static String extractDateFromDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
