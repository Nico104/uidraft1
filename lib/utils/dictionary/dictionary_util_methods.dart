import 'dart:convert';
import 'package:http/http.dart' as http;

///Cuts [word] of after every ' or .
String prepareWord(String word) {
  if (word.contains(".")) {
    word = word.substring(0, word.indexOf('.'));
  }
  if (word.contains("'")) {
    word = word.substring(0, word.indexOf("'"));
  }
  return word;
}

///Return all available Dictionary Data for the word [word]
Future<Map<String, dynamic>> getDefinition(String word) async {
  if (word.isNotEmpty) {
    Uri uri =
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/' + word);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Failed to load Definition');
    }
  } else {
    throw Exception("Word cannot be empty bro");
  }
}
