import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

String baseURL = 'http://localhost:3000/';

//Send Comment
Future<void> sendComment(int postId, String commentText) async {
  var url = Uri.parse(baseURL + 'comment/createComment_CommentAnaytics');
  String? token = await getToken();

  final response = await http.post(url,
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

Future<List<int>> fetchPostComments(int postId) async {
  try {
    final response = await http.get(
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
