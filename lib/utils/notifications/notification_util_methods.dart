import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

String baseURL = 'http://localhost:3000/';

//Get Comment Data by Id
Future<List<Map<String, dynamic>>> fetchUserNotifications() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'user/getMyUnseenNotifications'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> notifications = <Map<String, dynamic>>[];
    List<dynamic> values = <dynamic>[];
    values = json.decode(response.body);
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          notifications.add(map);
        }
      }
    }
    return notifications;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load notifications');
  }
}

//Send Message to User
Future<void> sendMessageToUser(
    String toUsername, String notificationText) async {
  String? token = await getToken();
  final response = await http.post(
      Uri.parse(baseURL + 'user/createUserNotification'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(<String, String>{
        "toUsername": toUsername,
        "notificationtext": notificationText
      }));

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
}

//Get Comment Data by Id
Future<List<Map<String, dynamic>>> fetchConversationWithUser(
    String username) async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'user/getConversationWithUser/$username'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> notifications = <Map<String, dynamic>>[];
    List<dynamic> values = <dynamic>[];
    values = json.decode(response.body);
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          notifications.add(map);
        }
      }
    }
    return notifications;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load conversation');
  }
}
