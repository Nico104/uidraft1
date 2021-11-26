import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_normal_widget.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class WordSearchTest extends StatefulWidget {
  const WordSearchTest({Key? key}) : super(key: key);

  @override
  _WordSearchTestState createState() => _WordSearchTestState();
}

class _WordSearchTestState extends State<WordSearchTest> {
  // double _he = 100;
  bool _showWords = false;
  double _opacity = 0;

  double _widthfactor = 0.8;
  double _padding = 0;

  double _scriptWidthfactor = 0.17;

  double _scriptHeight = 60;

  double _borderRadius = 50;

  void initiateAnimation() {
    setState(() {
      if (_widthfactor == 1) {
        // _widthfactor = 0.8;
        // _padding = 0;
        _scriptHeight = 60;
        _borderRadius = 50;
        _scriptWidthfactor = 0.17;
        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            _widthfactor = 0.8;
            _padding = 0;
            // _scriptHeight = 60;
            // _borderRadius = 50;
            // _scriptWidthfactor = 0.17;
          });
        });
      } else {
        _widthfactor = 1;
        _padding = 100;
        // _scriptHeight = 400;
        // _borderRadius = 12;
        // _scriptWidthfactor = 1;
        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            _scriptHeight = 400;
            _borderRadius = 12;
            _scriptWidthfactor = 1;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: [
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.transparent,
            )),
        Flexible(
          flex: 3,
          child: Container(
            // width: 100,
            height: 100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: Offset(-6.0, -6.0),
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(6.0, 6.0),
                  blurRadius: 16.0,
                ),
              ],
              // color: Color(0xFF292D32),
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.transparent,
            )),
        Flexible(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Stack(
                        // alignment: Alignment.topCenter,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: AnimatedPadding(
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.only(top: _padding),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => initiateAnimation.call(),
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(milliseconds: 200),
                                  width:
                                      constraints.maxWidth * _scriptWidthfactor,
                                  height: _scriptHeight,
                                  // decoration: BoxDecoration(
                                  //     color: Colors.blue,
                                  //     borderRadius:
                                  //         BorderRadius.circular(_borderRadius)),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.1),
                                        offset: Offset(-6.0, -6.0),
                                        blurRadius: 16.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        offset: Offset(6.0, 6.0),
                                        blurRadius: 16.0,
                                      ),
                                    ],
                                    // color: Color(0xFF292D32),
                                    color: Theme.of(context).canvasColor,
                                    borderRadius:
                                        BorderRadius.circular(_borderRadius),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedContainer(
                                    color: Colors.green,
                                    // alignment: Alignment.centerLeft,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.fastOutSlowIn,
                                    width: constraints.maxWidth * _widthfactor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormFieldNormal(
                                          controller: TextEditingController(),
                                          labelText: 'test',
                                          fontSize: 14,
                                          focusNode: FocusNode()),
                                    ),
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
                ))),
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.transparent,
            )),
      ],
    ));
  }
}
