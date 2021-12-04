import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

String formatNotificationDate(String ufDate) {
  DateTime date = DateTime.parse(ufDate);
  final DateFormat formatter = DateFormat('dd MMM\nhh:mm');
  final String formatted = formatter.format(date);
  return formatted;
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
