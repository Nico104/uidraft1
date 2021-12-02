import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/constants/global_constants.dart';

///Returns a List of autocomplete Search Terms accordigly to the passed search parameter [search]
///Returns nothing if the search is empty or if there is no autocomplete Search Term dor [search]
Future<List<String>> getAutocompleteSearchTerms(String search) async {
  List<String> autocompleteSearchTerms = <String>[];
  if (search.isNotEmpty) {
    final response = await http
        .get(Uri.parse(baseURL + 'search/autocompleteSearch/$search'));

    List<dynamic> values = json.decode(response.body);
    for (int i = 0; i < values.length; i++) {
      autocompleteSearchTerms.add(values.elementAt(i).toString());
    }
    // autocompleteSearchTerms = json.decode(response.body);
  }
  return autocompleteSearchTerms;
}
