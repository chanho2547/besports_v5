/// Converts a DateTime object to a string in the format YYYY-MM-DD.
String dateTimeToString(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

/// Converts a string in the format YYYY-MM-DD to a DateTime object.
DateTime stringToDateTime(String str) {
  List<String> parts = str.split('-');
  return DateTime(
      int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

String? recivedDataToLowData(String data) {
  return data.replaceAll("\$r", '').replaceAll(';', '');
}
