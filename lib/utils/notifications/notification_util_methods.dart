import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

enum NotificationMode { chat, notification, none }

///Return all UNSEEN Notification the logged in User got
Future<List<Map<String, dynamic>>> fetchUserNotifications(
    http.Client client) async {
  String? token = await getToken();
  final response = await client.get(
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

///Sends a Message Notification to the User with username [toUSername]
///and a message text of [notificationText]
Future<void> sendMessageToUser(
    String toUsername, String notificationText, http.Client client) async {
  String? token = await getToken();
  final response = await client.post(
      Uri.parse(baseURL + 'user/createUserMessage'),
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

///Return all messages the logged in User send to and received from [username]
///sorted by date
Future<List<Map<String, dynamic>>> fetchConversationWithUser(
    String username, http.Client client) async {
  String? token = await getToken();
  final response = await client.get(
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
    throw Exception('Failed to load conversation');
  }
}

///Returns Details of the Notification with the notificationId [notiId]
Future<void> seeNotification(int notiId, http.Client client) async {
  print("NotiId: " + notiId.toString());
  final response = await client.patch(
    Uri.parse(baseURL + 'user/seeNotification/$notiId'),
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
}

Future<bool> submitMsg(
    String toUsername, String msg, http.Client client) async {
  if (msg.trim().isNotEmpty) {
    await sendMessageToUser(toUsername, msg.trim(), client);
    return true;
  } else {
    return false;
  }
}
