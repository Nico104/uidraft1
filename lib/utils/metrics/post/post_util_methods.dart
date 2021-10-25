import 'package:http/http.dart' as http;

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
