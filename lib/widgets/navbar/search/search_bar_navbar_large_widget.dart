import 'dart:ui';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:uidraft1/uiwidgets/textfields/search_textfield/search_textformfield_widget.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/navbar/search/search_util_methods.dart';
// import 'dart:html' as html;

enum ArrowKey { up, down }

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.searchBarController,
  }) : super(key: key);

  final TextEditingController searchBarController;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final FocusNode _searchBarFocusNode;
  final FocusNode _keyboardFocusNode = FocusNode();

  List<String> autocompleteTerms = <String>[];

  int cursorPos = 0;

  int _activeIndex = 0;

  @override
  void initState() {
    _searchBarFocusNode = FocusNode(onKeyEvent: (focusNode, event) {
      print("Evvent: " + event.toString());
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          print("arrow up pressed");
          changeActiveIndex(ArrowKey.up);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          changeActiveIndex(ArrowKey.down);
        }
        // if (onCapsLock != null) {
        //   onCapsLock!.call();
        // }
      } else {
        if (event is KeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            // widget.searchBarController.value = TextEditingValue(
            //   text: widget.searchBarController.text,
            //   selection: TextSelection.collapsed(
            //       offset: widget.searchBarController.text.length),
            // );
            widget.searchBarController.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.searchBarController.text.length));
          }
        }
      }
      return KeyEventResult.ignored;
    }
        // onKeyEvent: (event) {
        //   // print("Evvent: " + event.toString());
        //   if (event is KeyDownEvent) {
        //     if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        //       print("arrow up pressed");
        //       changeActiveIndex(ArrowKey.up);
        //     } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        //       changeActiveIndex(ArrowKey.down);
        //     }
        //     // if (onCapsLock != null) {
        //     //   onCapsLock!.call();
        //     // }
        //   } else {
        //     if (event is KeyUpEvent) {
        //       if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        //         // widget.searchBarController.value = TextEditingValue(
        //         //   text: widget.searchBarController.text,
        //         //   selection: TextSelection.collapsed(
        //         //       offset: widget.searchBarController.text.length),
        //         // );
        //         widget.searchBarController.selection = TextSelection.fromPosition(
        //             TextPosition(offset: widget.searchBarController.text.length));
        //       }
        //     }
        //   }
        // },
        );
    super.initState();
    // _searchBarFocusNode.addListener(() {
    //   print("Has focus: ${_searchBarFocusNode.hasFocus}");
    // });
    // html.document.onKeyDown.listen((event) => event.preventDefault());
    // html.document.onKeyPress.listen((event) => event.preventDefault());
    // html.document.onKeyUp.listen((event) => event.preventDefault());
  }

  @override
  void dispose() {
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  void changeActiveIndex(ArrowKey arrowKey) {
    // setState(() {
    //   widget.searchBarController.value = TextEditingValue(
    //     text: widget.searchBarController.text,
    //     selection: TextSelection.collapsed(
    //         offset: widget.searchBarController.text.length),
    //   );
    // });

    switch (arrowKey) {
      case ArrowKey.up:
        if (_activeIndex == 0) {
          setState(() {
            _activeIndex = autocompleteTerms.length - 1;
          });
        } else {
          setState(() {
            _activeIndex--;
          });
        }
        break;
      case ArrowKey.down:
        if (_activeIndex == autocompleteTerms.length - 1) {
          setState(() {
            _activeIndex = 0;
          });
        } else {
          setState(() {
            _activeIndex++;
          });
        }
        break;
    }

    widget.searchBarController.text = autocompleteTerms.elementAt(_activeIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Autocomnplete
        //! Check if without Animation better
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 120),
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  width: double.infinity,
                  height: (autocompleteTerms.isEmpty ||
                          !_searchBarFocusNode.hasFocus)
                      ? 0
                      : null,
                  decoration: BoxDecoration(
                    // color: Theme.of(context).canvasColor.withOpacity(0.95),
                    color: Theme.of(context)
                        .colorScheme
                        .searchBarColor
                        .withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.brandColor,
                        width: 0.5),
                  ),
                  child: AnimatedSize(
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 120),
                    child: Padding(
                      // padding: const EdgeInsets.fromLTRB(8, 26, 8, 8),
                      padding: const EdgeInsets.fromLTRB(0, 26, 0, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getAutocompleteWidgets(
                          autocompleteTerms,
                          widget.searchBarController.text,
                          Theme.of(context)
                              .colorScheme
                              .navBarIconColor
                              .withOpacity(0.2),
                          Colors.white,
                          _activeIndex,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SearchBarTextFormField(
          searchBarController: widget.searchBarController,
          focusNode: _searchBarFocusNode,
          onChange: (search) {
            EasyDebounce.debounce(
                'searchbar', // <-- An ID for this particular debouncer
                const Duration(milliseconds: 500), // <-- The debounce duration
                () async {
              List<String> autocompleteTermsTemp =
                  await getAutocompleteSearchTerms(search);
              print("Autocomplete Terms: " + autocompleteTermsTemp.toString());
              setState(() {
                autocompleteTerms = autocompleteTermsTemp;
              });
              // _keyboardFocusNode.requestFocus();
            });
          },
        ),
      ],
    );
  }
}

List<Widget> getAutocompleteWidgets(List<String> autocompleteTerms,
    String search, Color dividerColor, Color textcolor, int activeIndex) {
  List<Widget> widgets = <Widget>[];

  if (search.isNotEmpty) {
    for (int i = 0; i < autocompleteTerms.length; i++) {
      widgets.add(
        InkWell(
          child: Container(
            width: double.infinity,
            color: (activeIndex == i) ? Colors.grey.withOpacity(0.5) : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: SubstringHighlight(
                text: autocompleteTerms
                    .elementAt(i), // each string needing highlighting
                term: search, // user typed "m4a"
                textStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Segoe UI',
                    letterSpacing: 0.3,
                    color: textcolor),
                textStyleHighlight: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Segoe UI',
                    letterSpacing: 0.3,
                    color: textcolor,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      );
      if (i < autocompleteTerms.length - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Divider(color: dividerColor),
          ),
        );
      }
    }
  }

  return widgets;
}
