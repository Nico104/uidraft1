import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

///posts a comment to the post with [postId]
///and a comment text of [commentText]
Future<void> sendComment(
    int postId, String commentText, http.Client client) async {
  var url = Uri.parse(baseURL + 'comment/createComment_CommentAnaytics');
  String? token = await getToken();

  final response = await client.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          <String, String>{'postId': '$postId', 'commentText': commentText}));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 201) {
    throw Error();
  }
}

///Fetches all comment IDs without parents (top lvel comments) of post with [postId]
Future<List<int>> fetchPostComments(int postId, http.Client client) async {
  try {
    final response = await client.get(
        Uri.parse(baseURL + 'comment/getPostCommentsWithoutParent/$postId'));

    if (response.statusCode == 200) {
      List<int> comments = <int>[];
      List<dynamic> values = <dynamic>[];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            comments.add(map['commentId']);
          }
        }
      }
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to load comments2');
  }
}
