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

//Get Comment Data by Id
Future<List<int>> getSubCommentIds(int commentId) async {
  try {
    final response = await http
        .get(Uri.parse(baseURL + 'comment/getCommentChildren/$commentId'));

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

//rates a Comment (like, dislike, superlike, superdislike)
Future<void> rateComment(int commentId, String rating) async {
  try {
    String? token = await getToken();
    final response =
        await http.post(Uri.parse(baseURL + 'comment/createCommentRating'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'commentId': '$commentId',
              'ratingType': rating,
            }));
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like comment');
  }
}

//Changes a Comment Rating
Future<void> updateCommentRating(int commentId, String rating) async {
  try {
    String? token = await getToken();
    final response =
        await http.patch(Uri.parse(baseURL + 'comment/updateCommentRating'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'commentId': '$commentId',
              'ratingType': rating,
            }));
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like comment');
  }
}

//Deletes a Comment Rating
Future<void> deleteCommentRating(int commentId) async {
  try {
    String? token = await getToken();
    final response = await http.delete(
        Uri.parse(baseURL + 'comment/deleteCommentRating/$commentId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like comment');
  }
}

//Get User Comment Rating
Future<int> getUserCommentRating(int commentId) async {
  try {
    String? token = await getToken();
    final response = await http.get(
        Uri.parse(baseURL + 'comment/getUserCommentRating/$commentId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      print(response.body);
      if (response.body.isNotEmpty) {
        if (json.decode(response.body)['commentRating'] == 'LIKE') {
          return 1;
        } else if (json.decode(response.body)['commentRating'] == 'DISLIKE') {
          return 2;
        } else {
          return 0;
        }
      } else {
        // print("empty rating");
        return 0;
      }
    } else {
      throw Exception('Failed to load comments');
    }
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to load comments3');
  }
}
