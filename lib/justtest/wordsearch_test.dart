import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class WordSearchTest extends StatefulWidget {
  const WordSearchTest({Key? key}) : super(key: key);

  @override
  _WordSearchTestState createState() => _WordSearchTestState();
}

class _WordSearchTestState extends State<WordSearchTest> {
  double _width = 100;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: [
        Flexible(
            flex: 6,
            child: Container(
              color: Colors.transparent,
            )),
        Flexible(
            flex: 3,
            child: InkWell(
              onTap: () => setState(() {
                if (_width == 100) {
                  _width = 200;
                } else {
                  _width = 100;
                }
              }),
              child: Container(
                color: Colors.blue,
                child: Column(
                  children: [
                    //TextFormfield
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      // reverseDuration: const Duration(milliseconds: 200),
                      // width: _width,
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
                      ),
                    ),
                    Expanded(child: ListView())
                  ],
                ),
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.transparent,
            )),
      ],
    ));
  }
}
