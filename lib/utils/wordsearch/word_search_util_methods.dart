import 'dart:convert';

import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:http/http.dart' as http;

enum ScrollPressMethod { smallUp, smallDown, start, end }
enum WordMode { closed, script, definition }

Future<List<Map<String, dynamic>>> fetchAllWords(
    int postId, http.Client client) async {
  final response =
      await client.get(Uri.parse(baseURL + 'transcript/getAllWords/$postId'));

  // print("response body: " + response.body);
  print("penis1: " + response.statusCode.toString());
  if (response.statusCode == 200) {
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

Future<List<double>> searchWords(
    int postId, String search, http.Client client) async {
  if (search.isNotEmpty) {
    final response = await client
        .get(Uri.parse(baseURL + 'transcript/searchWords/$postId/$search'));

    print("response body: " + response.body);
    if (response.statusCode == 200) {
      List<double> matches = <double>[];
      List<dynamic> values = <dynamic>[];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          double match = values.elementAt(i);
          matches.add(match);
        }
      }
      return matches;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load all words');
    }
  } else {
    return <double>[];
  }
}
