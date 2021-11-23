import 'dart:convert';

import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchAllWords(int postId) async {
  final response =
      await http.get(Uri.parse(baseURL + 'transcript/getAllWords/$postId'));

  // print("response body: " + response.body);
  print("penis1: " + response.statusCode.toString());
  if (response.statusCode == 200) {
    // List<Map<String, dynamic>> words = json.decode(response.body);
    // print("penis");
    // if (words.isNotEmpty) {
    //   print("Word Lenght: " + words.length.toString());
    //   return words;
    // } else {
    //   // throw Exception('Failed to load all words');
    //   return [];
    // }

    List<Map<String, dynamic>> words = <Map<String, dynamic>>[];
    List<dynamic> values = <dynamic>[];
    values = json.decode(response.body);
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          words.add(map);
        }
      }
    }
    return words;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load all words');
  }
}
