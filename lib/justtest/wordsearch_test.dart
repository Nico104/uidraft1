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

  double _widthfactor = 0.7;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: [
        Flexible(
            flex: 5,
            child: Container(
              color: Colors.transparent,
            )),
        Flexible(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    // alignment: Alignment.topCenter,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _widthfactor = 0.9;
                            });
                          },
                          child: Container(
                            height: 300,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.topLeft,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          child: FractionallySizedBox(
                            widthFactor: _widthfactor,
                            child: Container(
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormFieldNormal(
                                    controller: TextEditingController(),
                                    labelText: 'test',
                                    fontSize: 14,
                                    focusNode: FocusNode()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
