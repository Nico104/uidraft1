import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

enum Menu { none, menu, notification, customfeed, options }

///Returns the number count of unseen notifications the logged in User has
Future<int> getMyUnseenNotificationCount() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'user/getMyUnseenNotificationsCount'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print("Notification Count" + response.body);

  int result = json.decode(response.body)['_count']['userNotificationId'];
  return result;
}
