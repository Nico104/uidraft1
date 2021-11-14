import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

enum CFElement { tag, subchannel, creator }

//Get User Custom Feeds
Future<List<Map<String, dynamic>>> fetchUserCustomFeeds() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'customfeed/getUserCustomFeeds'),
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

//Get User Custom Feeds
Future<List<Map<String, dynamic>>> fetchUserCustomFeedsPreview() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'customfeed/getUserCustomFeedsPreview'),
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

//Get User Custom Feeds
Future<Map<String, dynamic>> getCustomFeed(int cfId) async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'customfeed/getCustomFeed/$cfId'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load cf');
  }
}

//Add element to CustomFeed
Future<void> addToCustomFeed(
    CFElement cfe, int cfId, String elementName) async {
  Uri uri;
  switch (cfe) {
    case CFElement.tag:
      uri = Uri.parse(baseURL + 'customfeed/addTag');
      break;
    case CFElement.subchannel:
      uri = Uri.parse(baseURL + 'customfeed/addSubchannel');
      break;
    case CFElement.creator:
      uri = Uri.parse(baseURL + 'customfeed/addCreator');
      break;
  }

  String? token = await getToken();
  final response = await http.patch(uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(
          <String, String>{'customFeedId': '$cfId', 'element': elementName}));

  print(response.statusCode);
  print(response.body);
}

//remove element to CustomFeed
Future<void> removeFromCustomFeed(
    CFElement cfe, int cfId, String elementName) async {
  Uri uri;
  switch (cfe) {
    case CFElement.tag:
      uri = Uri.parse(baseURL + 'customfeed/removeTag');
      break;
    case CFElement.subchannel:
      uri = Uri.parse(baseURL + 'customfeed/removeSubchannel');
      break;
    case CFElement.creator:
      uri = Uri.parse(baseURL + 'customfeed/removeCreator');
      break;
  }

  String? token = await getToken();
  final response = await http.patch(uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(
          <String, String>{'customFeedId': '$cfId', 'element': elementName}));

  print(response.statusCode);
  print(response.body);
}

//change CustomFeed name
Future<void> changeCustomFeedName(int cfId, String cfName) async {
  if (cfName.isNotEmpty) {
    Uri uri = Uri.parse(baseURL + 'customfeed/changeName');

    String? token = await getToken();
    final response = await http.patch(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json
            .encode(<String, String>{'customFeedId': '$cfId', 'name': cfName}));

    print(response.statusCode);
    print(response.body);
  }
}

//create CustomFeed
Future<void> createCustomFeed() async {
  Uri uri = Uri.parse(baseURL + 'customfeed/createCustomFeed');

  String? token = await getToken();
  final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(<String, String>{'customFeedName': 'newCF'}));

  print(response.statusCode);
  print(response.body);
}

//delete CustomFeed
Future<void> deleteCustomFeed(int cfId) async {
  Uri uri = Uri.parse(baseURL + 'customfeed/$cfId');

  String? token = await getToken();
  final response = await http.delete(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(response.statusCode);
  print(response.body);
}



// //Send Message to User
// Future<void> sendMessageToUser(
//     String toUsername, String notificationText) async {
//   String? token = await getToken();
//   final response = await http.post(
//       Uri.parse(baseURL + 'user/createUserNotification'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: json.encode(<String, String>{
//         "toUsername": toUsername,
//         "notificationtext": notificationText
//       }));

//   print("Status Code: " + response.statusCode.toString());
//   print(response.body);
// }

// //Get Comment Data by Id
// Future<List<Map<String, dynamic>>> fetchConversationWithUser(
//     String username) async {
//   String? token = await getToken();
//   final response = await http.get(
//     Uri.parse(baseURL + 'user/getConversationWithUser/$username'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     },
//   );

//   print("Status Code: " + response.statusCode.toString());
//   print(response.body);
//   if (response.statusCode == 200) {
//     List<Map<String, dynamic>> notifications = <Map<String, dynamic>>[];
//     List<dynamic> values = <dynamic>[];
//     values = json.decode(response.body);
//     if (values.isNotEmpty) {
//       for (int i = 0; i < values.length; i++) {
//         if (values[i] != null) {
//           Map<String, dynamic> map = values[i];
//           notifications.add(map);
//         }
//       }
//     }
//     return notifications;
//   } else {
//     // If that call was not successful, throw an error.
//     throw Exception('Failed to load conversation');
//   }
// }


//   print("Status Code: " + response.statusCode.toString());
//   print(response.body);
//   // if (response.statusCode == 200) {
//   //   List<Map<String, dynamic>> notifications = <Map<String, dynamic>>[];
//   //   List<dynamic> values = <dynamic>[];
//   //   values = json.decode(response.body);
//   //   if (values.isNotEmpty) {
//   //     for (int i = 0; i < values.length; i++) {
//   //       if (values[i] != null) {
//   //         Map<String, dynamic> map = values[i];
//   //         notifications.add(map);
//   //       }
//   //     }
//   //   }
//   //   return notifications;
//   // } else {
//   //   // If that call was not successful, throw an error.
//   //   throw Exception('Failed to load conversation');
//   // }
// }
