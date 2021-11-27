import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';
import 'package:uidraft1/widgets/videoplayer/wordsearch/word_search_bar_widget.dart';

class VideoPlayerWordSearchLarge extends StatefulWidget {
  const VideoPlayerWordSearchLarge(
      {Key? key,
      required this.postId,
      required this.seekToSecond,
      required this.pos})
      : super(key: key);

  final Function(double) seekToSecond;
  final int postId;

  final Duration pos;

  @override
  _VideoPlayerWordSearchLargeState createState() =>
      _VideoPlayerWordSearchLargeState();
}

class _VideoPlayerWordSearchLargeState
    extends State<VideoPlayerWordSearchLarge> {
  bool _showWords = false;

  late List<Map<String, dynamic>> words = [];

  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchAllWords(widget.postId).then((value) {
        words = value;
        if (words.elementAt(0)['word'] == 'the') {
          words.removeAt(0);
        }
        if (words.last['word'] == 'the') {
          words.removeLast();
        }
        for (int i = 0; i < words.length - 1; i++) {
          if (double.parse(words.elementAt(i)['end']) !=
              double.parse(words.elementAt(i + 1)['start'])) {
            if ((double.parse(words.elementAt(i + 1)['start']) -
                    double.parse(words.elementAt(i)['end'])) >
                1) {
              words.elementAt(i)['word'] = words.elementAt(i)['word'] +
                  ' ' +
                  // (double.parse(words.elementAt(i + 1)['start']) -
                  //         double.parse(words.elementAt(i)['end']))
                  //     .toStringAsFixed(2) +
                  '\n\n';
            } else if ((double.parse(words.elementAt(i + 1)['start']) -
                    double.parse(words.elementAt(i)['end'])) >
                0.2) {
              words.elementAt(i)['word'] = words.elementAt(i)['word'] +
                  ' ' +
                  // (double.parse(words.elementAt(i + 1)['start']) -
                  //         double.parse(words.elementAt(i)['end']))
                  //     .toStringAsFixed(2) +
                  '\n';
            } else {
              words.elementAt(i)['word'] = words.elementAt(i)['word'] + '...';
            }
          } else {
            words.elementAt(i)['word'] = words.elementAt(i)['word'] + ' ';
          }
        }
        setState(() {});
      });
    });
  }

  void handleScrollButtonPressed(ScrollPressMethod method) {
    switch (method) {
      case ScrollPressMethod.smallUp:
        _scrollController.animateTo(_scrollController.position.pixels - 250,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn);
        break;
      case ScrollPressMethod.smallDown:
        _scrollController.animateTo(_scrollController.position.pixels + 250,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn);
        break;
      case ScrollPressMethod.start:
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn);
        break;
      case ScrollPressMethod.end:
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Word SearchBar
        WordSearchBar(
          postId: widget.postId,
          pos: widget.pos,
          seekToSecond: (sec) => widget.seekToSecond.call(sec),
        ),
        const SizedBox(height: 15),
        AnimatedContainer(
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
                        autofocus: false,
                        focusNode: _focusNode,
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .searchBarTextColor),
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
                        onFieldSubmitted: (_) => _focusNode.requestFocus(),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () => setState(() {
                            _showWords = !_showWords;
                          }),
                      icon: const Icon(Icons.architecture_rounded))
                ],
              ),
              _showWords
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AllWordsWrap(
                              words: words,
                              seekToSecond: (id) =>
                                  widget.seekToSecond.call(id),
                              pos: widget.pos,
                              scrollController: _scrollController,
                            ),
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       children: [
                          //         const SizedBox(height: 10),
                          //         InkWell(
                          //             onTap: () => handleScrollButtonPressed(
                          //                 ScrollPressMethod.smallUp),
                          //             // onDoubleTap: () => handleScrollButtonPressed(
                          //             //     ScrollPressMethod.start),
                          //             onLongPress: () => handleScrollButtonPressed(
                          //                 ScrollPressMethod.start),
                          //             child: const Icon(Icons.arrow_upward)),
                          //       ],
                          //     ),
                          //     Column(
                          //       mainAxisAlignment: MainAxisAlignment.end,
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       children: [
                          //         InkWell(
                          //             onTap: () => handleScrollButtonPressed(
                          //                 ScrollPressMethod.smallDown),
                          //             // onDoubleTap: () => handleScrollButtonPressed(
                          //             //     ScrollPressMethod.end),
                          //             onLongPress: () => handleScrollButtonPressed(
                          //                 ScrollPressMethod.end),
                          //             child: const Icon(Icons.arrow_downward)),
                          //         const SizedBox(height: 10)
                          //       ],
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ))
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}

class AllWordsWrap extends StatefulWidget {
  const AllWordsWrap({
    Key? key,
    required this.words,
    required this.seekToSecond,
    required this.pos,
    required this.scrollController,
  }) : super(key: key);

  final List<Map<String, dynamic>> words;
  final Function(double) seekToSecond;

  final Duration pos;

  final ScrollController scrollController;

  @override
  State<AllWordsWrap> createState() => _AllWordsWrapState();
}

class _AllWordsWrapState extends State<AllWordsWrap> {
  GlobalKey key = GlobalKey();
  bool _tempDeactivateAutoScroll = false;

  @override
  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (key.currentContext != null && !_tempDeactivateAutoScroll) {
      print("LEsgo");
      Scrollable.ensureVisible(key.currentContext!, alignment: 0.4);
    } else {
      print("´Current Context is null");
    }
  }

  void temporaryDeactivateAutoScroll() {
    if (mounted) {
      if (!_tempDeactivateAutoScroll) {
        setState(() {
          _tempDeactivateAutoScroll = true;
        });
      }
    }
    EasyDebounce.debounce(
        'temporaryDeactivateAutoScroll', // <-- An ID for this particular debouncer
        const Duration(seconds: 3), // <-- The debounce duration
        () {
      if (mounted) {
        setState(() {
          _tempDeactivateAutoScroll = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          temporaryDeactivateAutoScroll();
          print('Scrolled');
        }
      },
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                    // default text style
                    children: getWords(widget.words, widget.pos,
                        widget.seekToSecond, widget.scrollController, key)),
              ),
            ],
          ),
          // child: getWords(words, pos, seekToSecond),
        ),
      ),
    );
  }
}

TextSpan getWord(
    Map<String, dynamic> word, Duration pos, Function(double) seekToSecond) {
  return TextSpan(
    text: word['word'],
    style: (pos.inMilliseconds / 1000 > double.parse(word['start']))
        ? const TextStyle(fontSize: 16, color: Colors.purple)
        : const TextStyle(fontSize: 16, color: Colors.white),
    recognizer: TapGestureRecognizer()
      ..onTap = () => seekToSecond.call(double.parse(word['start'])),
  );
}

List<InlineSpan> getWords(
    List<Map<String, dynamic>> words,
    Duration pos,
    Function(double) seekToSecond,
    ScrollController scrollController,
    GlobalKey key) {
  bool _keyGiven = false;
  print("generate list");
  List<InlineSpan> wordList = [];
  for (int i = 0; i < words.length; i++) {
    if (pos.inMilliseconds / 1000 < double.parse(words.elementAt(i)['start']) &&
        !_keyGiven) {
      wordList.add(WidgetSpan(
        child: SizedBox.fromSize(
          size: Size.zero,
          key: key,
        ),
      ));
      _keyGiven = true;
      print("Key given to: " + words.elementAt(i)['word']);
    }
    wordList.add(getWord(words.elementAt(i), pos, seekToSecond));
  }

  return wordList;
}
