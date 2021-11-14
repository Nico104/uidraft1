import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

enum SubModData { none, banner, picture, about }

Future<int> fetchMembersBy(String search, int method, String subchannelname,
    Function(String, String, bool, bool) handleUserName) async {
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
      bool isMod = false;
      bool isBanned = false;
      List<dynamic> values = <dynamic>[];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];

            if ((map['subchannelsModerater'] as List).isNotEmpty) {
              isMod = true;
            } else if ((map['bannedFromSubchannel'] as List).isNotEmpty) {
              isBanned = true;
            }

            handleUserName('${map['username']}',
                '${map['userProfile']['profilePicturePath']}', isMod, isBanned);

            isMod = false;
            isBanned = false;
          }
        }
      }
      // setState(() {
      //   _loading = false;
      // });
      return 0;
    } else {
      throw Exception('Failed to load members');
    }
  } catch (e) {
    print("Error: " + e.toString());
    return 1;
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

    // print(response.statusCode);
    // print(response.body);
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

Future<void> unbanUser(String username, String subchannelname) async {
  try {
    String? token = await getToken();
    final response = await http.post(
        Uri.parse(baseURL + 'subchannel/unbanUser'),
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
    throw Exception('Failed to unban User');
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

Future<void> removeUserSubchannelMod(
    String username, String subchannelname) async {
  try {
    String? token = await getToken();
    final response = await http.patch(
        Uri.parse(baseURL + 'subchannel/removeUserSubchannelMod'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, String>{
          "subchannelName": subchannelname,
          "username": username
        }));

    print("RemoveUserMod: " + response.statusCode.toString());
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to remove $username Mod of $subchannelname');
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

Future<void> updateSubchannelPicture(
    String subchannelname, Uint8List picture) async {
  var url = Uri.parse(
      'http://localhost:3000/subchannel/updateSubchannelPicture/$subchannelname');
  String? token = await getToken();

  var request = http.MultipartRequest('POST', url);

  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(http.MultipartFile.fromBytes(
    'picture', picture,
    filename: "randomname",
    // contentType: MediaType(
    //   'image',
    //   'png',
    // )
  ));

  // print(request.send());
  request.send();
}

Future<void> updateSubchannelBanner(
    String subchannelname, Uint8List banner) async {
  var url = Uri.parse(
      'http://localhost:3000/subchannel/updateSubchannelBanner/$subchannelname');
  String? token = await getToken();

  var request = http.MultipartRequest('POST', url);

  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(http.MultipartFile.fromBytes(
    'banner', banner,
    filename: "randomname",
    // contentType: MediaType(
    //   'image',
    //   'png',
    // )
  ));

  // print(request.send());
  request.send();
}

Future<void> updateSubchannelAboutText(
    String subchannelname, String aboutext) async {
  try {
    String? token = await getToken();
    final response = await http.patch(
        Uri.parse(baseURL + 'subchannel/updateSubchannelAbout/$subchannelname'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, String>{"aboutText": aboutext}));

    print(response.statusCode);
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to update $subchannelname AbouText');
  }
}

//Get Reported PostIds List
Future<List<int>> fetchReportedPostIds(
    String subchannelname, String search) async {
  try {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/post/getSubchannelReportedPublicPostIds/$subchannelname/$search'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<int> postIds = <int>[];
      List<dynamic> values = <dynamic>[];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            postIds.add(map['postId']);
          }
        }
      }
      return postIds;
    } else {
      throw Exception('Failed to load post');
    }
  } catch (e) {
    //mounted to not call SetState after dispose()
    print("Error: " + e.toString());
    // return <int>[];
    throw Exception('Failed to load post');
  }
}

Future<Map<String, dynamic>> getSubModPostMetrics(int id) async {
  try {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + 'post/getPostSubModMetrics/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        return map;
      } else {
        throw Exception('Failed to load postmetrics');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load postmetrics');
    }
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to load postmetrics');
  }
}
