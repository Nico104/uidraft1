import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

String baseURL = 'http://localhost:3000/';

enum SubModData { none, banner, picture, about }

Future<void> fetchMembersBy(String search, int method, String subchannelname,
    Function(String, String) handleUserName) async {
  print("Method: " + method.toString());
  try {
    String? token = await getToken();
    Uri uri;
    switch (method) {
      case 0:
        uri = Uri.parse(
            baseURL + 'user/searchSubchannelMemberBy/$subchannelname/$search');
        break;
      case 1:
        uri = Uri.parse(
            baseURL + 'user/searchSubchannelPostersBy/$subchannelname/$search');
        print("Uri: " + uri.toString());
        break;
      case 2:
        uri = Uri.parse(
            baseURL + 'user/searchSubchannelModsBy/$subchannelname/$search');
        break;
      case 3:
        uri = Uri.parse(
            baseURL + 'user/getBannedFromSubchannel/$subchannelname/$search');
        break;
      default:
        uri = Uri.parse(
            baseURL + 'user/searchSubchannelMembersBy/$subchannelname/$search');
        break;
    }
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // userNames.clear();
      List<dynamic> values = <dynamic>[];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            // userNames.add([
            //   '${map['username']}',
            //   '${map['userProfile']['profilePicturePath']}'
            // ]);
            handleUserName('${map['username']}',
                '${map['userProfile']['profilePicturePath']}');
          }
        }
      }
      // setState(() {
      //   _loading = false;
      // });
    } else {
      throw Exception('Failed to load members');
    }
  } catch (e) {
    print("Error: " + e.toString());
  }
}

Future<Map<String, dynamic>> getSubModUserData(
    String username, String subchannelname) async {
  try {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + 'user/getSubModUserData/$subchannelname/$username'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        return map;
      } else {
        throw Exception('Failed to load userdata');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load userdata');
    }
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to load userdata');
  }
}

Future<void> banUser(String username, String subchannelname) async {
  try {
    String? token = await getToken();
    final response = await http.post(Uri.parse(baseURL + 'subchannel/banUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, String>{
          "subchannelName": subchannelname,
          "username": username
        }));

    print(response.statusCode);
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to ban User');
  }
}

Future<void> makeUserSubchannelMod(
    String username, String subchannelname) async {
  try {
    String? token = await getToken();
    final response = await http.patch(
        Uri.parse(baseURL + 'subchannel/makeUserSubchannelMod'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, String>{
          "subchannelName": subchannelname,
          "username": username
        }));

    print("MakeUserMod: " + response.statusCode.toString());
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to make $username Mod of $subchannelname');
  }
}

Future<void> whiteListPost(int postId) async {
  try {
    String? token = await getToken();
    final response = await http.patch(
      Uri.parse(baseURL + 'post/whitelistPost/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to whitelist $postId');
  }
}

Future<void> removePostReports(int postId) async {
  try {
    String? token = await getToken();
    final response = await http.patch(
      Uri.parse(baseURL + 'post/removePostReports/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to remove $postId reports');
  }
}
