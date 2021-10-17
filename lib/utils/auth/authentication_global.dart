import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<int> isAuthenticated() async {
  var url = Uri.parse('http://localhost:3000/protected');
  String? token = await getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    return response.statusCode;
  }

  return response.statusCode;
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}
