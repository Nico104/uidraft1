import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

String baseURL = 'http://localhost:3000/';

Future<void> fetchMembersBy(String search, int method, String subchannelname,
    Function(String, String) handleUserName) async {
  try {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse(
          baseURL + 'user/searchSubchannelMemberBy/$subchannelname/$search'),
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
