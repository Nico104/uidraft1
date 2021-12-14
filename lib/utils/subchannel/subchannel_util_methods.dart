import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

///turns the logged in User into a Member of the Subchannel [subchannel]
Future<void> enterSubchannel(String subchannelName, http.Client client) async {
  String? token = await getToken();
  final response = await client.patch(
    Uri.parse(baseURL + 'subchannel/enterSubchannel/$subchannelName'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(response.statusCode);
  print(response.body);
}

///removes the logged in User from the Subchannel [subchannel]
Future<void> leaveSubchannel(String subchannelName, http.Client client) async {
  String? token = await getToken();
  final response = await client.patch(
    Uri.parse(baseURL + 'subchannel/leaveSubchannel/$subchannelName'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(response.statusCode);
  print(response.body);
}

///Returns true if the logged in User is a Member of the subchannel [subchannel]
///or false if the logged in User is not
Future<bool> isMember(String subchannelName, http.Client client) async {
  String? token = await getToken();
  final response = await client.get(
    Uri.parse(baseURL + 'subchannel/isMember/$subchannelName'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      print("Yes is a member");
      return true;
    } else {
      print("Nope not a member");
      return false;
    }
  } else {
    print("Nope not a member2");
    return false;
  }
}

///Returns true if the logged in User is a Mod of the subchannel [subchannel]
///or false if the logged in User is not
Future<bool> isMod(String subchannelName, http.Client client) async {
  String? token = await getToken();
  final response = await client.get(
    Uri.parse(baseURL + 'user/isMod/$subchannelName'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return response.body.toLowerCase() == 'true';
  } else {
    print("Nope not a mod");
    return false;
  }
}

//Get Subchannel Data by SubchannelName
Future<Map<String, dynamic>> fetchSubchannelData(
    String subchannelName, http.Client client) async {
  final response = await client.get(Uri.parse(
      baseURL + 'subchannel/getSubchannelWithPreview/' + subchannelName));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      print("test2");
      return map;
    } else {
      throw Exception('Failed to load post');
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
