import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

enum SharingType { copy, link }

Future<void> incrementPostViewsByOne(int postId, http.Client client) async {
  final response = await client
      .patch(Uri.parse(baseURL + 'post/incrementPostViews/$postId'));

  if (response.statusCode == 200) {
    print("Vies for post $postId incremented by 1");
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to increment post');
  }
}

//rates a Post
//Requires to be logged in
Future<void> ratePost(int postId, int rating, http.Client client) async {
  try {
    String? token = await getToken();
    final response =
        await client.post(Uri.parse(baseURL + 'post/createPostRating'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'postId': '$postId',
              'rating': '$rating',
            }));
    // print(response.body);
    // print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like post');
  }
}

//Changes a Post Rating
Future<void> updatePostRating(
    int postId, int rating, http.Client client) async {
  try {
    String? token = await getToken();
    final response =
        await client.patch(Uri.parse(baseURL + 'post/updatePostRating'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'postId': '$postId',
              'rating': '$rating',
            }));
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to like post');
  }
}

//Deletes a Post Rating
Future<void> deletePostRating(int postId, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client
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
Future<int> getUserPostRating(int postId, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client
        .get(Uri.parse(baseURL + 'post/getUserPostRating/$postId'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print(response.body);
      if (response.body.isNotEmpty) {
        // if (json.decode(response.body)['postRating'] == 'LIKE') {
        //   return 1;
        // } else if (json.decode(response.body)['postRating'] == 'DISLIKE') {
        //   return 2;
        // } else {
        //   return 0;
        // }
        int rating = json.decode(response.body)['postRating'];
        if (rating > 25) {
          return 25;
        } else if (rating < -25) {
          return -25;
        } else {
          return rating;
        }
      } else {
        // print("empty rating");
        return 0;
      }
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    print("Error userpostrating: " + e.toString());
    throw Exception('Failed to load posts3');
  }
}

//Get Post Rating Data by Id
Future<int> getPostRatingData(
    int id, String ratingType, http.Client client) async {
  final http.Response response;

  if (ratingType == "like") {
    response =
        await client.get(Uri.parse(baseURL + 'post/getPostRatingLikes/$id'));
  } else {
    response =
        await client.get(Uri.parse(baseURL + 'post/getPostRatingDislikes/$id'));
  }

  if (response.statusCode == 200) {
    // Map<String, dynamic> map = json.decode(response.body);
    // if (map.isNotEmpty) {
    //   return map['_count']['postRatingUsername'];
    // } else {
    //   return 0;
    // }
    return int.parse(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load postrating');
  }
}

///Retunr all Data needed to display and play the post with postId [postId]
Future<Map<String, dynamic>> fetchPostData(int id, http.Client client) async {
  final response = await client.get(Uri.parse(baseURL + 'post/getPost/$id'));

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

//Get Post RatingScore
Future<int> getPostRatingScore(int id, http.Client client) async {
  final response =
      await client.get(Uri.parse(baseURL + 'post/getPostRatingScore/$id'));

  if (response.statusCode == 200) {
    print("Rating" + int.parse(response.body).toString());
    return int.parse(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post rating');
  }
}

///Creates a whatchtime Analytics DB entry for the post with postId [postId]
///and a whatchtime of [postWT]
///passes also the User if one is logged in
//! no http Client
Future<void> createWhatchtimeAnalyticPost(int postId, int postWT) async {
  http.Client client = http.Client();
  if (await isAuthenticated(client) == 200) {
    try {
      print("auth wt");
      String? token = await getToken();
      final response = await client.post(
          Uri.parse(baseURL + 'post/createPostWhatchtimeAnalyticWithUser'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'postId': '$postId',
            'postWhatchTime': '$postWT'
          }));
      // print(response.body);
      // print(response.statusCode);
    } catch (e) {
      print("Error: " + e.toString());
      throw Exception('Failed to create post whatchtime analytic AUTH');
    }
  } else {
    try {
      // print("no auth wt " + postId.toString());
      final response = await http.post(
          Uri.parse(baseURL + 'post/createPostWhatchtimeAnalytic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'postId': '$postId',
            'postWhatchTime': '$postWT'
          }));
      // print(response.body);
      // print(response.statusCode);
    } catch (e) {
      print("Error: " + e.toString());
      throw Exception('Failed to create post whatchtime analytic NOAUTH');
    }
  }
}

///Creates a sharing Analytics DB entry for the post with postId [postId]
///and a sharing type of [sharingType], which can be either
///copy of the postlink or standard share
Future<void> createSharingAnalyticPost(
    int postId, SharingType sharingtype, http.Client client) async {
  int sharetypeint;
  if (sharingtype == SharingType.copy) {
    sharetypeint = 0;
  } else {
    sharetypeint = 1;
  }

  if (await isAuthenticated(client) == 200) {
    try {
      print("auth wt");
      String? token = await getToken();
      final response = await client.post(
          Uri.parse(baseURL + 'post/createPostSharingAnalyticWithUser'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'postId': '$postId',
            "sharingtype": "$sharetypeint"
          }));
      // print(response.body);
      // print(response.statusCode);
    } catch (e) {
      print("Error: " + e.toString());
      throw Exception('Failed to create post whatchtime analytic AUTH');
    }
  } else {
    try {
      // print("no auth wt " + postId.toString());
      final response = await http.post(
          Uri.parse(baseURL + 'post/createPostSharingAnalytic'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'postId': '$postId',
            "sharingtype": "$sharetypeint"
          }));
      // print(response.body);
      // print(response.statusCode);
    } catch (e) {
      print("Error: " + e.toString());
      throw Exception('Failed to create post whatchtime analytic NOAUTH');
    }
  }
}

///Reports the Post with postId [postId]
Future<void> reportPost(int postId, http.Client client) async {
  print("report");
  try {
    String? token = await getToken();
    final response =
        await client.post(Uri.parse(baseURL + 'post/createPostReport'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'postId': '$postId',
            }));
    print(response.body);
    print(response.statusCode);
  } catch (e) {
    print("Error: " + e.toString());
    throw Exception('Failed to report post');
  }
}

///Return 1 if the logged in User already reported the Post with postId [postId]
///or 0 if the logged in User has not
Future<int> getUserPostReport(int postId, http.Client client) async {
  try {
    String? token = await getToken();
    final response = await client
        .get(Uri.parse(baseURL + 'post/getUserPostReport/$postId'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print("User Report: " + response.body);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return 1;
      } else {
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
