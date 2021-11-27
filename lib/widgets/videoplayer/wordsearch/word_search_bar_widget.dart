import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_no_tab_widget.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_normal_widget.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';

class WordSearchBar extends StatefulWidget {
  const WordSearchBar(
      {Key? key,
      required this.postId,
      required this.seekToSecond,
      required this.pos})
      : super(key: key);

  final Function(double) seekToSecond;
  final int postId;

  final Duration pos;

  @override
  _WordSearchBarState createState() => _WordSearchBarState();
}

class _WordSearchBarState extends State<WordSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<double> matches = <double>[];

  String search = "";
  // int activeMatch = 0;
  //active match closest after current pos

  Future<void> findMatches() async {
    await searchWords(widget.postId, _controller.text)
        .then((value) => setState(() {
              matches = value;
            }));
  }

  void handleFieldSubmitted() {
    if (_controller.text != search) {
      print("unsame search");
      setState(() {
        search = _controller.text;
      });
    } else {
      print("same search");
    }
    findMatches().then((value) {
      if (matches.isNotEmpty) {
        // seekToClosestLargerMatch(widget.pos.inMilliseconds / 1000, matches);
        widget.seekToSecond.call(seekToClosestLargerMatch(
            widget.pos.inMilliseconds / 1000, matches));
        _focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormFieldNoTab(
            controller: _controller,
            focusNode: _focusNode,
            fontSize: 13,
            labelText: 'WordSearch',
            onFieldSubmitted: (_) {
              handleFieldSubmitted.call();
              _focusNode.requestFocus();
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(matches.length.toString())
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

double seekToClosestLargerMatch(double numberToMatch, List<double> matches) {
  // List<double> greater = matches.where((e) => e >= numberToMatch).toList()
  //   ..sort();
  List<double> greater = matches.where((e) => e > numberToMatch).toList()
    ..sort(); //List of the greater values

  if (greater.isNotEmpty) {
    print("Closes Larger Match: " + greater.first.toString());
    return greater.first;
  } else {
    print("Closes Larger Match: " + matches.first.toString());
    return matches.first;
  }
}
