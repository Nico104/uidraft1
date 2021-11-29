import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

//Get Autocomplete Search Terms
Future<List<String>> getAutocompleteSearchTerms(String search) async {
  List<String> autocompleteSearchTerms = <String>[];
  if (search.isNotEmpty) {
    final response = await http
        .get(Uri.parse(baseURL + 'search/autocompleteSearch/$search'));

    // print("Status Code: " + response.statusCode.toString());
    // print("Notification Count" + response.body);

    List<dynamic> values = json.decode(response.body);
    for (int i = 0; i < values.length; i++) {
      autocompleteSearchTerms.add(values.elementAt(i).toString());
    }
    // autocompleteSearchTerms = json.decode(response.body);
  }
  return autocompleteSearchTerms;
}
