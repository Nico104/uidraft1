import 'package:flutter/material.dart';
import 'package:uidraft1/utils/dictionary/dictionary_util_methods.dart';

class WordDefinition extends StatefulWidget {
  const WordDefinition({
    Key? key,
    required this.word,
    required this.animateToScript,
    required this.start,
    required this.end,
    required this.pos,
    required this.seekToSecond,
  }) : super(key: key);

  final String word;
  final Function() animateToScript;

  final double start;
  final double end;
  final Duration pos;
  final Function(double, bool) seekToSecond;

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
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
    super.initState();
  }

  Widget getWordDefinition() {
    if (!_loading && _wordDictionary != null) {
      //Word Definition
      return WordDictionaryItem(
        wordDictionary: _wordDictionary,
        animateToScript: widget.animateToScript,
        start: widget.start,
        end: widget.end,
        pos: widget.pos,
        seekToSecond: widget.seekToSecond,
      );
    } else if (_loading) {
      //Loading
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Text("Definition for ${widget.word} is loading..."),
          const SizedBox(height: 15),
          InkWell(
              onTap: () => widget.animateToScript.call(),
              child: const Icon(Icons.arrow_back))
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

class WordDictionaryItem extends StatefulWidget {
  const WordDictionaryItem({
    Key? key,
    required WordDictionary? wordDictionary,
    required this.animateToScript,
    required this.start,
    required this.end,
    required this.pos,
    required this.seekToSecond,
  })  : _wordDictionary = wordDictionary,
        super(key: key);

  final WordDictionary? _wordDictionary;
  final Function() animateToScript;

  final double start;
  final double end;
  final Duration pos;
  final Function(double, bool) seekToSecond;

  @override
  State<WordDictionaryItem> createState() => _WordDictionaryItemState();
}

class _WordDictionaryItemState extends State<WordDictionaryItem> {
  double currentSecond = 0;
  bool _isLooping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      currentSecond = widget.pos.inMilliseconds / 1000;
    });
  }

  void seekIfWordEnded() {
    if (_isLooping && widget.pos.inMilliseconds > (widget.end * 1000)) {
      widget.seekToSecond(widget.start, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    seekIfWordEnded();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Menu and Word
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () {
                          widget.seekToSecond.call(currentSecond, false);
                          if (mounted) {
                            setState(() {
                              _isLooping = false;
                            });
                          }

                          widget.animateToScript.call();
                        },
                        child: const Icon(Icons.arrow_back)),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget._wordDictionary!.word,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      //PlayButton, when clicked loop word in video, when clicked again resume video on where it left
                      InkWell(
                          onTap: () {
                            if (_isLooping) {
                              widget.seekToSecond.call(currentSecond, true);
                              if (mounted) {
                                setState(() {
                                  _isLooping = false;
                                });
                              }
                            } else {
                              widget.seekToSecond.call(widget.start, false);
                              if (mounted) {
                                setState(() {
                                  _isLooping = true;
                                });
                              }
                            }
                          },
                          child: Icon(_isLooping
                              ? Icons.loop
                              : Icons.play_arrow_outlined))
                    ],
                  ),
                ),
                const Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Text(
                      "english",
                      textAlign: TextAlign.end,
                    ))
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            //No Font installed for phenitc
            // _wordDictionary!.phonetic.isNotEmpty
            //     ? Column(
            //         children: [
            //           Text(
            //             "phonetic: " + _wordDictionary!.phonetic,
            //             style: const TextStyle(fontSize: 16),
            //           ),
            //           const SizedBox(
            //             height: 15,
            //           ),
            //         ],
            //       )
            //     : const SizedBox(),
            widget._wordDictionary!.origin.isNotEmpty
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Origin: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 4),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              widget._wordDictionary!.origin,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                    ],
                  )
                : const SizedBox(),
            widget._wordDictionary!.meanings.isNotEmpty
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Meaning",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getMeanings(widget._wordDictionary!.meanings),
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  List<Column> getMeanings(List<Meaning> meanings) {
    List<Column> columns = <Column>[];
    for (int i = 0; i < meanings.length; i++) {
      if (meanings.elementAt(i).partOfSpeech.isNotEmpty) {
        columns.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meanings.elementAt(i).partOfSpeech,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        definition.definition.isNotEmpty
            ? Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            "definition: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4)
                        ],
                      ),
                      Expanded(
                        child: Text(
                          definition.definition,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
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
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            "example: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4)
                        ],
                      ),
                      Expanded(
                        child: Text(
                          definition.example,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )
            : const SizedBox(),
        definition.synonyms.isNotEmpty
            ? Column(children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text("Synonyms: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(width: 12)
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getOnyms(definition.synonyms)),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ])
            : const SizedBox(),
        definition.antonyms.isNotEmpty
            ? Column(children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text("Antonyms: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(width: 12)
                      ],
                    ),
                    Column(children: getOnyms(definition.antonyms)),
                  ],
                ),
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
      onytexts.add(Text(
        onyms.elementAt(i),
        textAlign: TextAlign.start,
      ));
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
