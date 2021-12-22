import 'dart:ui';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:substring_highlight/substring_highlight.dart';
import 'package:uidraft1/justtest/glassmorphism.dart';
import 'package:uidraft1/uiwidgets/shadows/inner_shadow_class.dart';
import 'package:uidraft1/uiwidgets/textfields/search_textfield/search_textformfield_widget.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_normal_widget.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/navbar/search/search_bar_navbar_large_widget.dart';
import 'package:uidraft1/widgets/slider/slidertest.dart';

class WordSearchTest extends StatefulWidget {
  const WordSearchTest({Key? key}) : super(key: key);

  @override
  _WordSearchTestState createState() => _WordSearchTestState();
}

class _WordSearchTestState extends State<WordSearchTest> {
  double _widthfactor = 0.8;
  double _padding = 0;

  double _scriptWidthfactor = 0.17;

  double _scriptHeight = 60;

  double _borderRadius = 50;

  final Curve _curve = Curves.fastOutSlowIn;
  final Duration _duration = const Duration(milliseconds: 180);

  TextEditingController controller = TextEditingController();

  void initiateAnimation() {
    setState(() {
      if (_widthfactor == 1) {
        // _widthfactor = 0.8;
        // _padding = 0;
        _scriptHeight = 60;
        _borderRadius = 50;
        _scriptWidthfactor = 0.17;
        Future.delayed(_duration ~/ 4, () {
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
        Future.delayed(_duration ~/ 4, () {
          setState(() {
            _scriptHeight = 700;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.transparent,
            )),
        Flexible(
          flex: 6,
          // child: Padding(
          //   padding: const EdgeInsets.only(top: 15),
          //   // child: SearchBarTest(
          //   //   searchBarController: controller,
          //   // ),
          //   child: Image.network(
          //     // baseURL + "${snapshot.data!['postTumbnailPath']}",
          //     spacesEndpoint +
          //         "post/thumbnail/eae36a5d7f265d16015eeacdaab92ee6",
          //     fit: BoxFit.cover,
          //     alignment: Alignment.center,
          //   ),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  // bottom: Radius.elliptical(
                  //     MediaQuery.of(context).size.width, 100.0),
                  bottom: Radius.elliptical(200, 5.0),
                  top: Radius.elliptical(200, 5.0),
                  // right: Radius.elliptical(200, 10.0),
                  // left: Radius.elliptical(200, 10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    // bottom: Radius.elliptical(
                    //     MediaQuery.of(context).size.width, 100.0),
                    // bottom: Radius.elliptical(200, 10.0),
                    // top: Radius.elliptical(200, 10.0),
                    right: Radius.elliptical(5, 200.0),
                    left: Radius.elliptical(5, 200.0),
                  ),
                  child: InnerShadow(
                    blur: 16,
                    offset: const Offset(-3, -8),
                    color: Colors.black38.withOpacity(0.3),
                    child: InnerShadow(
                      blur: 16,
                      offset: const Offset(3, 8),
                      color: Colors.white12.withOpacity(0.2),
                      child: InnerShadow(
                        blur: 48,
                        offset: const Offset(-8, -3),
                        color: Colors.black12.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(0.8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(42)),
                            child: Container(
                              height: 200.0,
                              // color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Colors.blue.shade800.withOpacity(0.7),
                                //     Colors.blue.shade800.withOpacity(0.95),
                                //     // Colors.black.withOpacity(start),
                                //     // Colors.black.withOpacity(end),
                                //   ],
                                //   begin: AlignmentDirectional.topStart,
                                //   end: AlignmentDirectional.bottomEnd,
                                // ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // SLiderTestAnimRive
        const Flexible(
          flex: 10,
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: SLiderTestAnimRive(),
          ),
        ),
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
                              curve: _curve,
                              duration: _duration,
                              padding: EdgeInsets.only(top: _padding),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => initiateAnimation.call(),
                                child: AnimatedContainer(
                                  curve: _curve,
                                  duration: _duration,
                                  width:
                                      constraints.maxWidth * _scriptWidthfactor,
                                  height: _scriptHeight,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.circular(_borderRadius)),
                                  // decoration: BoxDecoration(
                                  //   boxShadow: [
                                  //     BoxShadow(
                                  //       color: Colors.white.withOpacity(0.1),
                                  //       offset: Offset(-6.0, -6.0),
                                  //       blurRadius: 16.0,
                                  //     ),
                                  //     BoxShadow(
                                  //       color: Colors.black.withOpacity(0.4),
                                  //       offset: Offset(6.0, 6.0),
                                  //       blurRadius: 16.0,
                                  //     ),
                                  //   ],
                                  //   // color: Color(0xFF292D32),
                                  //   color: Theme.of(context).canvasColor,
                                  //   borderRadius:
                                  //       BorderRadius.circular(_borderRadius),
                                  // ),
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
                                    duration: _duration,
                                    curve: _curve,
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

class SearchBarTest extends StatefulWidget {
  const SearchBarTest({
    Key? key,
    required this.searchBarController,
  }) : super(key: key);

  final TextEditingController searchBarController;

  @override
  State<SearchBarTest> createState() => _SearchBarTestState();
}

class _SearchBarTestState extends State<SearchBarTest> {
  // List<String> autocompleteTerms = <String>[
  //   "cdkshfds",
  //   "klgfdhjgdflsk",
  //   "fhdasfhsl"
  // ];
  List<String> autocompleteTerms = <String>[];

  // SMITrigger? _bump;
  // SMIInput<bool>? _hoverInput;

  // var controller;

  // void _onRiveInit(Artboard artboard) {
  //   controller = StateMachineController.fromArtboard(artboard, 'files');
  //   artboard.addController(controller!);
  //   // _bump = controller.findInput<bool>('onHover') as SMITrigger;
  //   _hoverInput = controller.findInput('onHover');
  // }

  // void _hitBump() => _bump?.fire();

  // SMITrigger? _bump;
  rive.SMIBool? onHover;

  void _onRiveInit(rive.Artboard artboard) {
    final controller =
        rive.StateMachineController.fromArtboard(artboard, 'controller');
    artboard.addController(controller!);
    // _bump = controller.findInput<bool>('bump') as SMITrigger;
    onHover = controller.findInput<bool>('onHover') as rive.SMIBool;
  }

  // void _hitBump() => _bump?.fire();
  void _changeOnHoverToTrue() => onHover?.change(true);
  void _changeOnHoverToFalse() => onHover?.change(false);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onHover: (_) => _changeOnHoverToTrue(),
        onExit: (_) => _changeOnHoverToFalse(),
        child: GestureDetector(
          // child: RiveAnimation.network(
          //   'https://cdn.rive.app/animations/vehicles.riv',
          //   fit: BoxFit.cover,
          //   onInit: _onRiveInit,
          // ),
          child: rive.RiveAnimation.asset(
            'assets/animations/rive/hoverAnim.riv',
            // fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
          // onTap: _hitBump,
        ),
      ),
    );
    // return Stack(
    //   // crossAxisAlignment: CrossAxisAlignment.start,
    //   // mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     //! Check if without Animation better
    //     Padding(
    //       padding: const EdgeInsets.only(top: 15.0),
    //       child: AnimatedSize(
    //         duration: const Duration(milliseconds: 120),
    //         alignment: Alignment.bottomCenter,
    //         // child: GlassMorphism(
    //         //   start: 0.9,
    //         //   end: 0.6,
    //         // child: BackdropFilter(
    //         //   filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    //         child: Container(
    //           width: double.infinity,
    //           height: autocompleteTerms.isEmpty ? 0 : null,
    //           decoration: BoxDecoration(
    //               color: Theme.of(context).canvasColor.withOpacity(0.8),
    //               borderRadius: const BorderRadius.only(
    //                   bottomLeft: Radius.circular(14),
    //                   bottomRight: Radius.circular(14)),
    //               border: Border.all(color: Colors.blue, width: 0.5)),
    //           child: AnimatedSize(
    //             alignment: Alignment.topCenter,
    //             duration: const Duration(milliseconds: 120),
    //             child: Padding(
    //               padding: const EdgeInsets.fromLTRB(8, 26, 8, 8),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: getAutocompleteWidgets(autocompleteTerms, "nono"),
    //               ),
    //             ),
    //           ),
    //         ),
    //         // ),
    //         // ),
    //       ),
    //     ),
    //     SearchBarTextFormField(
    //       focusNode: FocusNode(),
    //       searchBarController: widget.searchBarController,
    //       onChange: (search) {
    //         EasyDebounce.debounce(
    //             'searchbar', // <-- An ID for this particular debouncer
    //             const Duration(milliseconds: 500), // <-- The debounce duration
    //             () async {
    //           // List<String> autocompleteTermsTemp =
    //           //     await getAutocompleteSearchTerms(search);
    //           // print("Autocomplete Terms: " + autocompleteTermsTemp.toString());
    //           // setState(() {
    //           //   autocompleteTerms = autocompleteTermsTemp;
    //           // });
    //           if (search.isNotEmpty) {
    //             if (int.parse(search) == 1) {
    //               autocompleteTerms = <String>["cdkshfds"];
    //             } else if (int.parse(search) == 2) {
    //               autocompleteTerms = <String>["cdkshfds", "klgfdhjgdflsk"];
    //             } else if (int.parse(search) == 3) {
    //               autocompleteTerms = <String>[
    //                 "cdkshfds",
    //                 "klgfdhjgdflsk",
    //                 "fhdasfhsl"
    //               ];
    //             } else {
    //               autocompleteTerms = <String>[];
    //             }
    //           } else {
    //             autocompleteTerms = <String>[];
    //           }

    //           setState(() {});
    //         });
    //       },
    //     ),
    //   ],
    // );
  }
}

List<Widget> getAutocompleteWidgets(
    List<String> autocompleteTerms, String search) {
  List<Widget> widgets = <Widget>[];

  if (search.isNotEmpty) {
    for (int i = 0; i < autocompleteTerms.length; i++) {
      widgets.add(
        SubstringHighlight(
          text: autocompleteTerms
              .elementAt(i), // each string needing highlighting
          term: search, // user typed "m4a"
          textStyle: const TextStyle(
            // non-highlight style
            color: Colors.green,
          ),
          textStyleHighlight: const TextStyle(
            // highlight style
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      );
      if (i < autocompleteTerms.length - 1) {
        widgets.add(Divider(
          color: Colors.orange.withOpacity(0.3),
        ));
      }
      // widgets.add(Text("fdfsfdsf"));
    }
  }

  return widgets;
}

class SLiderTestAnimRive extends StatefulWidget {
  const SLiderTestAnimRive({Key? key}) : super(key: key);

  @override
  _SLiderTestAnimRiveState createState() => _SLiderTestAnimRiveState();
}

class _SLiderTestAnimRiveState extends State<SLiderTestAnimRive> {
  rive.SMINumber? _level;
  double _value = 10;

  void _onRiveInit(rive.Artboard artboard) {
    final controller =
        rive.StateMachineController.fromArtboard(artboard, 'State Machine');
    artboard.addController(controller!);
    // _bump = controller.findInput<bool>('bump') as SMITrigger;
    _level = controller.findInput<double>('Level') as rive.SMINumber;
    _level!.change(10);
    // _level!.change(10);
    // _level!.value = 10;
  }

  @override
  void initState() {
    // _level!.change(10);
    super.initState();
  }

  // void _hitBump() => _bump?.fire();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: rive.RiveAnimation.asset(
            'assets/animations/rive/water_bar_demo.riv',
            fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
        ),
        const SizedBox(height: 15),
        Slider(
            min: 0,
            max: 100,
            value: _value,
            onChanged: (val) => setState(() {
                  _value = val;
                  _level!.change(val);
                }))
      ],
    );
  }
}
