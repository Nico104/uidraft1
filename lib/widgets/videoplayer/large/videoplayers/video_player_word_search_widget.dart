import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';

class VideoPlayerWordSearchLarge extends StatefulWidget {
  const VideoPlayerWordSearchLarge(
      {Key? key, required this.postId, required this.seekToSecond})
      : super(key: key);

  final Function(double) seekToSecond;
  final int postId;

  @override
  _VideoPlayerWordSearchLargeState createState() =>
      _VideoPlayerWordSearchLargeState();
}

class _VideoPlayerWordSearchLargeState
    extends State<VideoPlayerWordSearchLarge> {
  bool _showWords = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      height: _showWords ? 400 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.blue,
      ),
      child: Column(
        children: [
          //TextFormfield
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: true,
                    // controller: _usernameTextController,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Segoe UI',
                        letterSpacing: 0.3),
                    cursorColor:
                        Theme.of(context).colorScheme.textInputCursorColor,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.brandColor,
                            width: 0.5),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.brandColor,
                            width: 2),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).canvasColor,
                      labelText: 'Username...',
                      labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color:
                              Theme.of(context).colorScheme.searchBarTextColor),
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 15, top: 15, left: 15, right: 10),
                      //Error
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 14.0, fontFamily: 'Segoe UI'),
                    ),
                    validator: (value) {
                      //check if username exists
                      if (value == null || value.isEmpty) {
                        return 'You may enter your username, sir';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              // SizedBox(width: 3),
              IconButton(
                  onPressed: () => setState(() {
                        _showWords = !_showWords;
                      }),
                  icon: const Icon(Icons.architecture_rounded))
            ],
          ),
          _showWords
              ? Expanded(
                  child: FutureBuilder(
                  // future: fetchAllWords(widget.postId),
                  future: fetchAllWords(55),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          //? You can get the exaxt same effect by making a standalone widget
                          // child: Builder(builder: (BuildContext context) {
                          //   return SingleChildScrollView(
                          //     child:
                          //         Wrap(spacing: 10, runSpacing: 10, children: [
                          //       for (var word in snapshot.data!)
                          //         Text(word['word']),
                          //     ]),
                          //   );
                          // }),
                          child: AllWordsWrap(
                              words: snapshot.data!,
                              seekToSecond: (id) =>
                                  widget.seekToSecond.call(id)),
                        );

                        // ListView.builder(
                        //   itemCount: snapshot.data!.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return Wrap(spacing: 10, runSpacing: 10, children: [
                        //       for (var word in snapshot.data!)
                        //         Text(word['word']),
                        //     ]);
                        //   },
                        // );
                      } else {
                        return const Center(child: Text("no words available"));
                      }
                    } else {
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.brandColor,
                      );
                    }
                  },
                ))
              : const SizedBox()
        ],
      ),
    );
  }
}

class AllWordsWrap extends StatelessWidget {
  const AllWordsWrap({
    Key? key,
    required this.words,
    required this.seekToSecond,
  }) : super(key: key);

  final List<Map<String, dynamic>> words;
  final Function(double) seekToSecond;

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < words.length - 1; i++) {
    //   if (double.parse(words.elementAt(i)['end']) !=
    //       double.parse(words.elementAt(i + 1)['start'])) {
    //     words.elementAt(i)['word'] = words.elementAt(i)['word'] + '\n';
    //   } else {
    //     words.elementAt(i)['word'] = words.elementAt(i)['word'] + ' ';
    //   }
    // }

    return SingleChildScrollView(
        // child: Wrap(spacing: 5, runSpacing: 5, children: [
        //   for (var word in words)
        //     WordWidget(seekToSecond: seekToSecond, word: word),
        // ]),

        child: Text.rich(
      TextSpan(
        // default text style
        children: <TextSpan>[
          for (var word in words)
            TextSpan(
              text: word['word'] + ' ',
              style: const TextStyle(fontSize: 18),
              recognizer: TapGestureRecognizer()
                ..onTap = () => seekToSecond.call(double.parse(word['start'])),
            )
        ],
      ),
    ));
    // return ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: words.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Text(index.toString());
    //   },
    // );
  }
}

class WordWidget extends StatelessWidget {
  const WordWidget({
    Key? key,
    required this.seekToSecond,
    required this.word,
  }) : super(key: key);

  final Function(double p1) seekToSecond;
  final Map<String, dynamic> word;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => seekToSecond.call(double.parse(word['start'])),
        child: Text(
          word['word'],
          style: const TextStyle(fontSize: 16),
        ));
  }
}
