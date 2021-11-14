import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

//Get Post  Data by Id
Future<List<int>> fetchUserPosts() async {
  String? token = await getToken();
  final response =
      await http.get(Uri.parse(baseURL + 'post/getUserPostIds'), headers: {
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
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

//Get PostPreview Data by Id
Future<Map<String, dynamic>> fetchPostStudioPreviewData(int id) async {
  final response =
      await http.get(Uri.parse(baseURL + 'post/getPostStudioPreviewData/$id'));

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

//Get PostPreview Data by Id
Future<Map<String, dynamic>> fetchPostStudioMetrics(int id) async {
  String? token = await getToken();
  final response = await http
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
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

//Get Post Absolute Whatchtime
Future<int> getPostAbsoluteWhatchtime(int id) async {
  final response =
      await http.get(Uri.parse(baseURL + 'post/getPostAbsoluteWhatchtime/$id'));

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

//Get Post Absolute Whatchtime
Future<void> updatePostData(int id, String title, String desc) async {
  String? token = await getToken();
  final response = await http.patch(
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

Future<void> updatePostThumbnail(int id, Uint8List thumbnail) async {
  var url = Uri.parse('http://localhost:3000/post/updatePostThumbnail/$id');
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

//Upodate Post Publicity
Future<void> updatePostPublicity(int id, bool isPublic) async {
  String dir = "unarchivePost";
  if (isPublic) {
    dir = "archivePost";
  }

  print(dir);

  String? token = await getToken();
  final response = await http.patch(
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

//Delete Post
Future<void> deletePost(int id) async {
  String? token = await getToken();
  final response = await http.patch(
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
