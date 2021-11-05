import 'package:intl/intl.dart';

String capitalizeOnlyFirstLater(String string) {
  if (string.trim().isEmpty) return "";

  return "${string[0].toUpperCase()}${string.substring(1)}";
}

String formatDate(String ufDate) {
  DateTime date = DateTime.parse(ufDate);
  final DateFormat formatter = DateFormat('dd MMMM yyyy hh:mm');
  final String formatted = formatter.format(date);
  return formatted;
}
