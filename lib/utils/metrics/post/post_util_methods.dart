import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

String baseURL = 'http://localhost:3000/';

Future<void> incrementPostViewsByOne(int postId) async {
  final response =
      await http.patch(Uri.parse(baseURL + 'post/incrementPostViews/$postId'));

  if (response.statusCode == 200) {
    print("Vies for post $postId incremented by 1");
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to increment post');
  }
}

//rates a Post (like, dislike, superlike, superdislike)
Future<void> ratePost(int postId, String rating) async {
  try {
    String? token = await getToken();
    final response =
        await http.post(Uri.parse(baseURL + 'post/createPostRating'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'postId': '$postId',
              'ratingType': rating,
            }));
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like post');
  }
}

//Changes a Post Rating
Future<void> updatePostRating(int postId, String rating) async {
  try {
    String? token = await getToken();
    final response =
        await http.patch(Uri.parse(baseURL + 'post/updatePostRating'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'postId': '$postId',
              'ratingType': rating,
            }));
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like post');
  }
}

//Deletes a Post Rating
Future<void> deletePostRating(int postId) async {
  try {
    String? token = await getToken();
    final response = await http
        .delete(Uri.parse(baseURL + 'post/deletePostRating/$postId'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like post');
  }
}

//Get User Post Rating
Future<int> getUserPostRating(int postId) async {
  try {
    String? token = await getToken();
    final response = await http
        .get(Uri.parse(baseURL + 'post/getUserPostRating/$postId'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print(response.body);
      if (response.body.isNotEmpty) {
        if (json.decode(response.body)['postRating'] == 'LIKE') {
          return 1;
        } else if (json.decode(response.body)['postRating'] == 'DISLIKE') {
          return 2;
        } else {
          return 0;
        }
      } else {
        // print("empty rating");
        return 0;
      }
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to load posts3');
  }
}
