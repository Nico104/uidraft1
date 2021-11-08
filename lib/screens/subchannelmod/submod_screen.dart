import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/profile/large/profile_large_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uidraft1/widgets/submod/sidebar/submod_sidebar_widget.dart';
import 'package:uidraft1/widgets/submod/sidebar/users/userlist.dart';

class SubMod extends StatefulWidget {
  const SubMod({Key? key}) : super(key: key);

  @override
  _SubModState createState() => _SubModState();
}

class _SubModState extends State<SubMod> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void setSelectedIndex(int i) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
    //       _selectedIndex = i;
    //     }));
    // print(_selectedIndex);
    setState(() {
      _selectedIndex = i;
    });

    print(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          children: [
            Row(
              children: [
                //SideBar
                SubModSideBar(setIndex: setSelectedIndex),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.white54,
                ),
                //Tab
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: getBody(_selectedIndex),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}

Widget getBody(int index) {
  switch (index) {
    case (0):
      return Container(
          key: ValueKey<int>(index),
          color: Colors.blue,
          child: const Center(child: Text("0")));
    case (1):
      return Container(
          key: ValueKey<int>(index),
          // color: Colors.green,
          child: Row(
            children: [
              Flexible(flex: 1, child: Container()),
              Expanded(
                flex: 4,
                child: Container(
                    color: Colors.amber.shade900,
                    height: 800,
                    width: 500,
                    child: SubmodUserlist()),
              ),
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 4,
                child: Container(
                  color: Colors.purple,
                  width: 500,
                  height: 800,
                ),
              ),
              Flexible(flex: 1, child: Container()),
            ],
          ));
    case (2):
      return Container(
          key: ValueKey<int>(index),
          color: Colors.yellow,
          child: const Center(child: Text("2")));
    default:
      return const Center(child: Text("default"));
  }
}
