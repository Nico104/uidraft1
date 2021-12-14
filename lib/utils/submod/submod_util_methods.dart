import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

enum SubModData { none, banner, picture, about }

///Fetches all members of subchannel [subchannel]
///which contain [search]
///by [method]
///1: Members of [subchannel]
///2: Posters(have posted at least one in [subchannel])
///3: Mods of [subchannel]
///4: Banned from [subchannel]
///
///[handleUsername] is executed for every returned User and handles the User accordingly to the Method passed
///
///Returns 0 on success and 1 on error
///
///might night a retouch and return the Users directly
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
      return 0;
    } else {
      throw Exception('Failed to load members');
    }
  } catch (e) {
    print("Error: " + e.toString());
    return 1;
  }
}

///Retrun all User Data of user [username] a SUbMod is allowed to see
///including comments
///
///[subchannelname] is the subchannel Name of the current SubMod Menu
Future<Map<String, dynamic>> getSubModUserData(
    String username, String subchannelname, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.get(
      Uri.parse(baseURL + 'user/getSubModUserData/$subchannelname/$username'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        return map;
      } else {
        throw Exception('Failed to load userdata');
      }
    } else {
      throw Exception('Failed to load userdata');
    }
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to load userdata');
  }
}

///Bans the user [username] from the Sucbahnnel [subchannelname]
Future<void> banUser(
    String username, String subchannelname, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.post(
        Uri.parse(baseURL + 'subchannel/banUser'),
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

///Unbans the user [username] from the Sucbahnnel [subchannelname]
Future<void> unbanUser(
    String username, String subchannelname, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.post(
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

///Makes the user [username] a Mod of the Subchannel [subchannelname]
Future<void> makeUserSubchannelMod(
    String username, String subchannelname, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.patch(
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

///Removes the Mod status of user [username] from the Subchannel [subchannelName]
Future<void> removeUserSubchannelMod(
    String username, String subchannelname, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.patch(
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

///Whitelists the Post with postId [postId]
///making the Post not showing up as a reported Post again,
///regardless if it received new reports
Future<void> whiteListPost(int postId, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.patch(
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

///Unvlidates all Reports the Post with postId [postId] received
Future<void> removePostReports(int postId, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.patch(
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

///Updates the Subchannel [subchannelname] picture with [picture]
Future<void> updateSubchannelPicture(
    String subchannelname, Uint8List picture) async {
  var url =
      Uri.parse(baseURL + 'subchannel/updateSubchannelPicture/$subchannelname');
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
  request.send();
}

///Updates the Subchannel [subchannelname] banner with [banner]
Future<void> updateSubchannelBanner(
    String subchannelname, Uint8List banner) async {
  var url =
      Uri.parse(baseURL + 'subchannel/updateSubchannelBanner/$subchannelname');
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
  request.send();
}

///Updates the Subchannel [subchannelname] About Text with [abouttext]
Future<void> updateSubchannelAboutText(
    String subchannelname, String abouttext, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.patch(
        Uri.parse(baseURL + 'subchannel/updateSubchannelAbout/$subchannelname'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, String>{"aboutText": abouttext}));

    print(response.statusCode);
    print(response.body);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to update $subchannelname AbouText');
  }
}

///Fetches all Posts of Subchannel [subchannelname] with UNHANDLED Reports
///filtered by [search]
///sorted by reports
Future<List<int>> fetchReportedPostIds(
    String subchannelname, String search, http.Client client) async {
  try {
    final response = await client.get(Uri.parse(baseURL +
        'post/getSubchannelReportedPublicPostIds/$subchannelname/$search'));

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

///Fetches all SubMod Menu Metrics of Post with postId [id]
Future<Map<String, dynamic>> getSubModPostMetrics(
    int id, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client.get(
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

///Sends an Announcement Notification to all Members of Subchannel [subchannelName]
///with Notification Title [title]
///and Notification Text [notificationText]
Future<void> sendAnnouncementToMembers(String subchannelName, String title,
    String notificationText, http.Client client) async {
  String? token = await getToken();
  final response = await client.post(
      Uri.parse(baseURL + 'user/createSubchannelAnnoucementNotification'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(<String, String>{
        "subchannelname": subchannelName,
        "title": title,
        "notificationtext": notificationText,
      }));

  print("Status Code: " + response.statusCode.toString());
  print(response.body);
}
