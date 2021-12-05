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

//Get Profile Data by Username
Future<Map<String, dynamic>> fetchProfileData(String username) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/user/getProfile/$username'));

  print("Staus profile code: " + response.statusCode.toString());

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      print("test2");
      return map;
    } else {
      print("empty map");
      throw Exception('Failed to load post');
    }
  } else {
    print("error");
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
