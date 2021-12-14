import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:http_parser/http_parser.dart';

///Follow user
Future<void> followUser(String creator, http.Client client) async {
  String? token = await getToken();
  final response = await client.patch(
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
Future<void> unfollowUser(String creator, http.Client client) async {
  String? token = await getToken();
  final response = await client.patch(
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
Future<bool> isFollowingCreator(String creator, http.Client client) async {
  String? token = await getToken();
  final response = await client.get(
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
Future<Map<String, dynamic>> fetchProfileData(
    String username, http.Client client) async {
  final response =
      await client.get(Uri.parse(baseURL + 'user/getProfile/$username'));

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

//Update Profile
Future<String?> updateProfile(
    String profileBio, List<int>? profilePicture, http.Client client) async {
  var url = Uri.parse(baseURL + 'user/updateMyUserProfile');
  String? token = await getToken();

  var request = http.MultipartRequest('PATCH', url);

  request.headers['Authorization'] = 'Bearer $token';
  request.fields['profileBio'] = profileBio;

  if (profilePicture != null) {
    print("profilePic not null");
    request.files.add(http.MultipartFile.fromBytes('picture', profilePicture,
        filename: "picture", contentType: MediaType('image', 'png')));
  } else {
    print("profilePic is null");
  }

  var response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    print('Updated!');
  } else {
    print('Update Error!');
  }

  String? un = await getMyUsername(client);
  return un;
}

Future<bool> isThisMe(String username, http.Client client) async {
  if (await isAuthenticated(client) == 200) {
    if (await getMyUsername(client) == username) {
      print("This is me");
      return true;
    } else {
      print("This is not me");
      return false;
    }
  } else {
    print("You are not even signed in");
    return false;
  }
}
