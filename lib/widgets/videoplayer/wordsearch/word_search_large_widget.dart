import 'package:flutter/material.dart';
import 'package:uidraft1/utils/dictionary/dictionary_util_methods.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';
import 'package:uidraft1/widgets/videoplayer/definition/definition_widget_large.dart';
import 'package:uidraft1/widgets/videoplayer/wordsearch/video_player_word_search_widget.dart';
import 'package:uidraft1/widgets/videoplayer/wordsearch/word_search_bar_widget.dart';

//!Fianl Widget

class WordSearchLarge extends StatefulWidget {
  WordSearchLarge(
      {Key? key,
      required this.seekToSecond,
      required this.postId,
      required this.pos})
      : super(key: globalKey);

  final Function(double) seekToSecond;
  final int postId;

  final Duration pos;

  static final GlobalKey<_WordSearchLargeState> globalKey =
      GlobalKey<_WordSearchLargeState>();

  @override
  _WordSearchLargeState createState() => _WordSearchLargeState();
}

class _WordSearchLargeState extends State<WordSearchLarge> {
  double _widthfactor = 0.8;
  double _padding = 0;
  double _scriptWidthfactor = 0.17;
  double _scriptHeight = 53;
  double _borderRadius = 50;
  double _searchBarBorderRadius = 24;

  final Curve _curve = Curves.fastOutSlowIn;
  final Duration _duration = const Duration(milliseconds: 180);

  // bool _showWords = false;
  WordMode _wordsMode = WordMode.closed;

  WordMode getShowWords() {
    return _wordsMode;
  }

  // void initiateAnimation() {
  //   setState(() {
  //     //collapse
  //     if (_widthfactor == 1) {
  //       _scriptHeight = 53;
  //       _borderRadius = 50;
  //       _scriptWidthfactor = 0.17;
  //       _searchBarBorderRadius = 24;
  //       _showWords = false;
  //       Future.delayed(_duration ~/ 4, () {
  //         setState(() {
  //           _widthfactor = 0.8;
  //           _padding = 0;
  //         });
  //       });
  //       //expand
  //     } else {
  //       _widthfactor = 1;
  //       _padding = 80;
  //       Future.delayed(_duration ~/ 4, () {
  //         setState(() {
  //           _scriptHeight = 500;
  //           _borderRadius = 12;
  //           _scriptWidthfactor = 1;
  //           _searchBarBorderRadius = 18;
  //           _showWords = true;
  //         });
  //       });
  //     }
  //   });
  // }

  void animateToClosed() {
    setState(() {
      _scriptHeight = 53;
      _borderRadius = 50;
      _scriptWidthfactor = 0.17;
      _searchBarBorderRadius = 24;
      // _showWords = false;
      _wordsMode = WordMode.closed;
      Future.delayed(_duration ~/ 4, () {
        setState(() {
          _widthfactor = 0.8;
          _padding = 0;
        });
      });
    });
  }

  void animateToScript() {
    setState(() {
      _widthfactor = 1;
      _padding = 80;
      Future.delayed(_duration ~/ 4, () {
        setState(() {
          _scriptHeight = 500;
          _borderRadius = 12;
          _scriptWidthfactor = 1;
          _searchBarBorderRadius = 18;
          // _showWords = true;
          _wordsMode = WordMode.script;
        });
      });
    });
  }

  void animateToDefinition() {
    setState(() {
      _widthfactor = 1;
      _padding = 80;
      Future.delayed(_duration ~/ 4, () {
        setState(() {
          _scriptHeight = 700;
          _borderRadius = 18;
          _scriptWidthfactor = 1;
          _searchBarBorderRadius = 18;
          // _showWords = true;
          _wordsMode = WordMode.definition;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              //!Script
              Align(
                alignment: Alignment.topRight,
                child: Script(
                  curve: _curve,
                  duration: _duration,
                  padding: _padding,
                  width: constraints.maxWidth * _scriptWidthfactor,
                  scriptHeight: _scriptHeight,
                  borderRadius: _borderRadius,
                  wordsMode: _wordsMode,
                  pos: widget.pos,
                  postId: widget.postId,
                  seekToSecond: (sec) => widget.seekToSecond.call(sec),
                  // initiateAnimation: () => initiateAnimation.call(),
                  animateToClosed: () => animateToClosed.call(),
                  animateToScript: () => animateToScript.call(),
                  animateToDefinition: () => animateToDefinition.call(),
                ),
              ),
              //!SearchBar
              Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBar(
                        duration: _duration,
                        curve: _curve,
                        width: constraints.maxWidth * _widthfactor,
                        searchBarBorderRadius: _searchBarBorderRadius,
                        pos: widget.pos,
                        postId: widget.postId,
                        seekToSecond: (sec) => widget.seekToSecond.call(sec),
                      ),
                      Expanded(
                          child: IgnorePointer(
                        child: Container(
                          height: 50,
                          color: Colors.transparent,
                        ),
                      ))
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}

class Script extends StatefulWidget {
  const Script({
    Key? key,
    required Curve curve,
    required Duration duration,
    required double padding,
    required double width,
    required double scriptHeight,
    required double borderRadius,
    required WordMode wordsMode,
    required this.seekToSecond,
    required this.postId,
    required this.pos,
    required this.animateToClosed,
    required this.animateToScript,
    required this.animateToDefinition,
  })  : _curve = curve,
        _duration = duration,
        _padding = padding,
        _width = width,
        _scriptHeight = scriptHeight,
        _borderRadius = borderRadius,
        _wordsMode = wordsMode,
        super(key: key);

  final Curve _curve;
  final Duration _duration;
  final double _padding;
  final double _width;
  final double _scriptHeight;
  final double _borderRadius;

  final WordMode _wordsMode;

  final Function(double) seekToSecond;
  final int postId;

  final Duration pos;

  final Function() animateToClosed;
  final Function() animateToScript;
  final Function() animateToDefinition;

  @override
  State<Script> createState() => _ScriptState();
}

class _ScriptState extends State<Script> {
  String _word = "";

  void openDefintion(String word) {
    String newword = prepareWord(word);
    if (newword.isNotEmpty) {
      setState(() {
        _word = newword;
      });
      widget.animateToDefinition.call();
    } else {
      print("word empty bro");
    }
  }

  Widget getWordWidget(WordMode wordMode) {
    switch (wordMode) {
      //Return Script Button
      case WordMode.closed:
        return InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => widget.animateToScript.call(),
            child: const Icon(Icons.bakery_dining));
      //Return Script
      case WordMode.script:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: VideoPlayerWordSearchLarge(
                pos: widget.pos,
                postId: widget.postId,
                seekToSecond: (sec) => widget.seekToSecond.call(sec),
                animateToScript: widget.animateToScript,
                openDefintion: (word) => openDefintion.call(word),
              ),
            ),
            IconButton(
                onPressed: () => widget.animateToClosed.call(),
                icon: const Icon(Icons.keyboard_arrow_up)),
          ],
        );
      //Return Definition
      case WordMode.definition:
        return WordDefinition(word: _word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      curve: widget._curve,
      duration: widget._duration,
      padding: EdgeInsets.only(top: widget._padding),
      child: AnimatedContainer(
        curve: widget._curve,
        duration: widget._duration,
        width: widget._width,
        height: widget._scriptHeight,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(widget._borderRadius),
        ),
        child: getWordWidget(widget._wordsMode),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required Duration duration,
    required Curve curve,
    required double width,
    required double searchBarBorderRadius,
    required this.seekToSecond,
    required this.postId,
    required this.pos,
  })  : _duration = duration,
        _curve = curve,
        _width = width,
        _searchBarBorderRadius = searchBarBorderRadius,
        super(key: key);

  final Duration _duration;
  final Curve _curve;
  final double _width;
  final double _searchBarBorderRadius;

  final Function(double) seekToSecond;
  final int postId;

  final Duration pos;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      width: _width,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(_searchBarBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WordSearchBar(
          pos: pos,
          postId: postId,
          seekToSecond: (sec) => seekToSecond.call(sec),
        ),
      ),
    );
  }
}
