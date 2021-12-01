import 'package:flutter/material.dart';
import 'package:uidraft1/utils/dictionary/dictionary_util_methods.dart';

class WordDefinition extends StatefulWidget {
  const WordDefinition({
    Key? key,
    required this.word,
  }) : super(key: key);

  final String word;

  @override
  State<WordDefinition> createState() => _WordDefinitionState();
}

class _WordDefinitionState extends State<WordDefinition> {
  bool _loading = true;
  WordDictionary? _wordDictionary;

  @override
  void initState() {
    getDefinition(widget.word).then((data) {
      _wordDictionary = WordDictionary.fromJson(data);
      print("WordDic: " +
          _wordDictionary!.meanings[0].definitions[0].synonyms.toString());
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  Widget getWordDefinition() {
    if (!_loading && _wordDictionary != null) {
      //Word Definition
      return WordDictionaryItem(wordDictionary: _wordDictionary);
    } else if (_loading) {
      //Loading
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Text("Definition for ${widget.word} is loading...")
        ],
      );
    } else {
      //Error
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text("Error while Loading Definition for ${widget.word}")],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getWordDefinition();
  }
}

class WordDictionaryItem extends StatelessWidget {
  const WordDictionaryItem({
    Key? key,
    required WordDictionary? wordDictionary,
  })  : _wordDictionary = wordDictionary,
        super(key: key);

  final WordDictionary? _wordDictionary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            _wordDictionary!.word,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          _wordDictionary!.phonetic.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      "phonetic: " + _wordDictionary!.phonetic,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )
              : const SizedBox(),
          _wordDictionary!.origin.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      "origin: " + _wordDictionary!.origin,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )
              : const SizedBox(),
          _wordDictionary!.meanings.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      "Meaning",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: getMeanings(_wordDictionary!.meanings),
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  List<Column> getMeanings(List<Meaning> meanings) {
    List<Column> columns = <Column>[];
    for (int i = 0; i < meanings.length; i++) {
      if (meanings.elementAt(i).partOfSpeech.isNotEmpty) {
        columns.add(
          Column(
            children: [
              Text(meanings.elementAt(i).partOfSpeech),
              const SizedBox(
                height: 15,
              ),
              meanings.elementAt(i).definitions.isNotEmpty
                  //TODO Prüf obs Fälle gib wo mehr wia onae definition isch
                  ? getDefinition(meanings.elementAt(i).definitions[0])
                  : const SizedBox(),
            ],
          ),
        );
      }
    }
    return columns;
  }

  Column getDefinition(Definition definition) {
    return Column(
      children: [
        definition.definition.isNotEmpty
            ? Column(
                children: [
                  Text(
                    "definition: " + definition.definition,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )
            : const SizedBox(),
        definition.example.isNotEmpty
            ? Column(
                children: [
                  Text(
                    "example: " + definition.example,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )
            : const SizedBox(),
        definition.synonyms.isNotEmpty
            ? Column(children: [
                Text("Synonyms"),
                Column(children: getOnyms(definition.synonyms)),
                const SizedBox(
                  height: 15,
                ),
              ])
            : const SizedBox(),
        definition.antonyms.isNotEmpty
            ? Column(children: [
                Text("Antonym"),
                Column(children: getOnyms(definition.antonyms)),
                const SizedBox(
                  height: 15,
                ),
              ])
            : const SizedBox(),
      ],
    );
  }

  List<Text> getOnyms(List<String> onyms) {
    List<Text> onytexts = <Text>[];
    for (int i = 0; i < onyms.length; i++) {
      onytexts.add(Text(onyms.elementAt(i)));
    }
    return onytexts;
  }
}

//Word Dictionary Data
class WordDictionary {
  String word;
  String phonetic;
  String origin;
  List<Meaning> meanings;

  WordDictionary({
    required this.word,
    required this.phonetic,
    required this.origin,
    required this.meanings,
  });

  factory WordDictionary.fromJson(Map<String, dynamic> data) {
    List<Meaning> meanings = [];

    for (int i = 0; i < (data['meanings'] as List).length; i++) {
      meanings.add(Meaning.fromJson(data['meanings'][i]));
    }

    return WordDictionary(
      word: data['word'] ?? "",
      phonetic: data['phonetic'] ?? "",
      origin: data['origin'] ?? "",
      meanings: meanings,
    );
  }
}

//Meanings for defined Word
class Meaning {
  String partOfSpeech;
  List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> data) {
    List<Definition> definitions = [];

    for (int i = 0; i < (data['definitions'] as List).length; i++) {
      definitions.add(Definition.fromJson(data['definitions'][i]));
    }

    return Meaning(
        partOfSpeech: data['partOfSpeech'] ?? "", definitions: definitions);
  }
}

//Word Definitions
class Definition {
  String definition;
  String example;
  List<String> synonyms;
  List<String> antonyms;

  Definition(
      {required this.definition,
      required this.example,
      required this.synonyms,
      required this.antonyms});

  factory Definition.fromJson(Map<String, dynamic> data) {
    List<String> synonyms = [];
    List<String> antonyms = [];

    for (int i = 0; i < (data['synonyms'] as List).length; i++) {
      synonyms.add(data['synonyms'][i].toString());
    }
    for (int i = 0; i < (data['antonyms'] as List).length; i++) {
      synonyms.add(data['antonyms'][i].toString());
    }

    return Definition(
        definition: data['definition'] ?? "",
        example: data['example'] ?? "",
        synonyms: synonyms,
        antonyms: antonyms);
  }
}
