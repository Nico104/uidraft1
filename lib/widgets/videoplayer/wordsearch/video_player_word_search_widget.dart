import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';

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
  late List<Map<String, dynamic>> words = [];

  final ScrollController _scrollController = ScrollController();

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
              words.elementAt(i)['word'] =
                  words.elementAt(i)['word'] + ' ' + '\n\n';
            } else if ((double.parse(words.elementAt(i + 1)['start']) -
                    double.parse(words.elementAt(i)['end'])) >
                0.2) {
              words.elementAt(i)['word'] =
                  words.elementAt(i)['word'] + ' ' + '\n';
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

  @override
  Widget build(BuildContext context) {
    return words.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: AllWordsWrap(
                words: words,
                seekToSecond: (id) => widget.seekToSecond.call(id),
                pos: widget.pos,
                scrollController: _scrollController,
              ),
            ),
          )
        : const CircularProgressIndicator();
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
    scrollToActiveWord();
  }

  // @override
  // void initState() {
  //   super.initState();
  // // Context is null
  //   scrollToActiveWord();
  //   print("initS2");
  // }

  void scrollToActiveWord() {
    if (key.currentContext != null && !_tempDeactivateAutoScroll) {
      // Scrollable.ensureVisible(key.currentContext!, alignment: 0.8);
      Scrollable.ensureVisible(key.currentContext!, alignment: 0.6);
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


 // void handleScrollButtonPressed(ScrollPressMethod method) {
  //   switch (method) {
  //     case ScrollPressMethod.smallUp:
  //       _scrollController.animateTo(_scrollController.position.pixels - 250,
  //           duration: const Duration(milliseconds: 100),
  //           curve: Curves.fastOutSlowIn);
  //       break;
  //     case ScrollPressMethod.smallDown:
  //       _scrollController.animateTo(_scrollController.position.pixels + 250,
  //           duration: const Duration(milliseconds: 100),
  //           curve: Curves.fastOutSlowIn);
  //       break;
  //     case ScrollPressMethod.start:
  //       _scrollController.animateTo(_scrollController.position.minScrollExtent,
  //           duration: const Duration(milliseconds: 100),
  //           curve: Curves.fastOutSlowIn);
  //       break;
  //     case ScrollPressMethod.end:
  //       _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //           duration: const Duration(milliseconds: 100),
  //           curve: Curves.fastOutSlowIn);
  //       break;
  //   }
  // }