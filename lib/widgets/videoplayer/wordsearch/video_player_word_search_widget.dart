import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';

class VideoPlayerWordSearchLarge extends StatefulWidget {
  const VideoPlayerWordSearchLarge({
    Key? key,
    required this.postId,
    required this.seekToSecond,
    required this.pos,
    required this.animateToScript,
    required this.openDefintion,
  }) : super(key: key);

  final Function(double, bool) seekToSecond;
  final int postId;

  final Duration pos;

  final Function() animateToScript;
  final Function(String, double, double) openDefintion;

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
                seekToSecond: (sec, ease) =>
                    widget.seekToSecond.call(sec, ease),
                pos: widget.pos,
                scrollController: _scrollController,
                animateToScript: widget.animateToScript,
                openDefintion: widget.openDefintion,
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
    required this.animateToScript,
    required this.openDefintion,
  }) : super(key: key);

  final List<Map<String, dynamic>> words;
  final Function(double, bool) seekToSecond;

  final Duration pos;

  final Function() animateToScript;
  final Function(String, double, double) openDefintion;

  final ScrollController scrollController;

  @override
  State<AllWordsWrap> createState() => _AllWordsWrapState();
}

class _AllWordsWrapState extends State<AllWordsWrap> {
  final GlobalKey key = GlobalKey();
  bool _tempDeactivateAutoScroll = false;

  String tappedStartTime = "";

  @override
  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    // scrollToActiveWord();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      scrollToActiveWord();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    children: getWords(
                  widget.words,
                  widget.pos,
                  widget.seekToSecond,
                  widget.scrollController,
                  key,
                  tappedStartTime,
                  (time) => setTappedStartTime.call(time),
                  widget.animateToScript,
                  widget.openDefintion,
                )),
              ),
            ],
          ),
          // child: getWords(words, pos, seekToSecond),
        ),
      ),
    );
  }

  void setTappedStartTime(String time) {
    setState(() {
      tappedStartTime = time;
    });
  }
}

TextSpan getWord(
  Map<String, dynamic> word,
  Duration pos,
  Function(double, bool) seekToSecond,
  String tappedStartTime,
  Function(String) setTappedStartTime,
  Function(String, double, double) openDefintion,
) {
  DoubleTapGestureRecognizer _gesture = DoubleTapGestureRecognizer();
  _gesture.onDoubleTap = () => print("DoubleTap");
  _gesture.onDoubleTapCancel = () => print("OneTap");
  _gesture.onDoubleTapDown = (_) => print("DoubleDown");

  var _gesture2 = TapGestureRecognizer();
  _gesture2.onTap = () {
    if (tappedStartTime == word['start']) {
      EasyDebounce.cancel('tap');
      setTappedStartTime("");
      //Execute when double tapped
      print("DoubleTap");
      openDefintion.call(
          word['word'], double.parse(word['start']), double.parse(word['end']));
    } else {
      setTappedStartTime(word['start']);
      EasyDebounce.cancel('tap');
      EasyDebounce.debounce('tap', const Duration(milliseconds: 250), () {
        setTappedStartTime("");
        //Execute when single tapped
        seekToSecond.call(double.parse(word['start']), true);
      });
    }
  };

  return TextSpan(
    text: word['word'],
    style: (pos.inMilliseconds / 1000 > double.parse(word['start']))
        ? const TextStyle(fontSize: 16, color: Colors.purple)
        : const TextStyle(fontSize: 16, color: Colors.white),
    // recognizer: TapGestureRecognizer()
    //   ..onTap = () => seekToSecond.call(double.parse(word['start'])),
    recognizer: _gesture2,
  );
}

List<InlineSpan> getWords(
  List<Map<String, dynamic>> words,
  Duration pos,
  Function(double, bool) seekToSecond,
  ScrollController scrollController,
  GlobalKey key,
  // LocalKey key,
  String getTappedStartTime,
  Function(String) setTappedStartTime,
  Function() animateToScript,
  Function(String, double, double) openDefintion,
) {
  bool _keyGiven = false;
  // print("generate list");
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
    }
    wordList.add(getWord(words.elementAt(i), pos, seekToSecond,
        getTappedStartTime, setTappedStartTime, openDefintion));
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