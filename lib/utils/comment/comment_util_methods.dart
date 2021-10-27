import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

String baseURL = 'http://localhost:3000/';

//Get Comment Data by Id
Future<Map<String, dynamic>> fetchCommentData(int id) async {
  final response =
      await http.get(Uri.parse(baseURL + 'comment/getCommentData/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      return map;
    } else {
      throw Exception('Failed to load comment');
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load comment');
  }
}

//Send Comment Reply
Future<void> sendReplyComment(
    int postId, int parentCommentId, String commentText) async {
  var url =
      Uri.parse(baseURL + 'comment/createComment_CommentAnayticsWithParent');
  String? token = await getToken();

  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'postId': '$postId',
        'commentText': commentText,
        'parentCommentId': '$parentCommentId'
      }));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 201) {
    throw Error();
  }
}
