import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

///Follow user
Future<void> followUser(String creator) async {
  String? token = await getToken();
  final response = await http.patch(
    Uri.parse(baseURL + 'user/followUser/$creator'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
}

///Follow user
Future<void> unfollowUser(String creator) async {
  String? token = await getToken();
  final response = await http.patch(
    Uri.parse(baseURL + 'user/unfollowUser/$creator'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
}

///Is Following Creator
Future<bool> isFollowingCreator(String creator) async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(baseURL + 'user/isFollowingCreator/$creator'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}
