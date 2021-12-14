import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

///Fetches all postId of the posts the logged in User has posted
Future<List<int>> fetchUserPosts(http.Client client) async {
  String? token = await getToken();
  final response =
      await client.get(Uri.parse(baseURL + 'post/getUserPostIds'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    List<int> posts = <int>[];
    List<dynamic> values = <dynamic>[];
    values = json.decode(response.body);
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          posts.add(map['postId']);
        }
      }
    }
    return posts;
  } else {
    throw Exception('Failed to load post');
  }
}

///Fetches all Data needed to display the Post with postId [pstId] in the Studio Preview List
Future<Map<String, dynamic>> fetchPostStudioPreviewData(
    int id, http.Client client) async {
  final response = await client
      .get(Uri.parse(baseURL + 'post/getPostStudioPreviewData/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      return map;
    } else {
      throw Exception('Failed to load post');
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

///Fetches Metrics needed to display the Post with postId [id] in the Studio View
Future<Map<String, dynamic>> fetchPostStudioMetrics(
    int id, http.Client client) async {
  String? token = await getToken();
  final response = await client
      .get(Uri.parse(baseURL + 'post/getPostStudioMetrics/$id'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      return map;
    } else {
      throw Exception('Failed to load post');
    }
  } else {
    throw Exception('Failed to load post');
  }
}

///Returns the absolut Whatchtime the Post with postId [id] has
Future<int> getPostAbsoluteWhatchtime(int id, http.Client client) async {
  final response = await client
      .get(Uri.parse(baseURL + 'post/getPostAbsoluteWhatchtime/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      return map[0]['_sum']['postWhatchTime'];
    } else {
      return 0;
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load postrating');
  }
}

///Updates the Posts with postId [id]
///changes the Post Title to [title]
///changes the Post Description to [desc]
Future<void> updatePostData(
    int id, String title, String desc, http.Client client) async {
  String? token = await getToken();
  final response = await client.patch(
      Uri.parse(baseURL + 'post/updatePostData/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          <String, String>{"postTitle": title, "postDescription": desc}));

  print(response.statusCode);
  print(response.body);
}

///Updates the Posts with postId [id]
///changes the Post Thumbnail to [thumbnail]
Future<void> updatePostThumbnail(int id, Uint8List thumbnail) async {
  var url = Uri.parse(baseURL + 'post/updatePostThumbnail/$id');
  String? token = await getToken();

  var request = http.MultipartRequest('POST', url);

  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(http.MultipartFile.fromBytes(
    'picture', thumbnail,
    filename: "thumbnailname",
    // contentType: MediaType(
    //   'image',
    //   'png',
    // )
  ));

  var response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 201) {
    print('Uploaded!');
  } else {
    print('Upload Error!');
  }
}

///Updates the Posts with postId [id]
///removes the Post Tag to [tag]
Future<void> removePostTag(int id, String tag, http.Client client) async {
  String? token = await getToken();
  final response =
      await client.patch(Uri.parse(baseURL + 'post/removePostTag/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{"tagname": tag}));

  print(response.statusCode);
  print(response.body);
}

///Updates the Posts with postId [id]
///add the Post Tag to [tag]
Future<void> addPostTag(int id, String tag, http.Client client) async {
  String? token = await getToken();
  final response =
      await client.patch(Uri.parse(baseURL + 'post/addPostTag/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{"tagname": tag}));

  print(response.statusCode);
  print(response.body);
}

///Upodate Post with postId [id] Publicity
///to Public if [isPublic] is true
///to Archived if [isPublic] is false
Future<void> updatePostPublicity(
    int id, bool isPublic, http.Client client) async {
  String dir = "unarchivePost";
  if (isPublic) {
    dir = "archivePost";
  }

  print(dir);

  String? token = await getToken();
  final response = await client.patch(
    Uri.parse(baseURL + 'post/$dir/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(response.statusCode);
  print(response.body);
}

///deltes Post with postId [id]
Future<void> deletePost(int id, http.Client client) async {
  String? token = await getToken();
  final response = await client.patch(
    Uri.parse(baseURL + 'post/deletePost/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(response.statusCode);
  print(response.body);
}
