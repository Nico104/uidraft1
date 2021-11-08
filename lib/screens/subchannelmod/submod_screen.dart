import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/profile/large/profile_large_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uidraft1/widgets/submod/submod_sidebar_widget.dart';

class SubMod extends StatefulWidget {
  const SubMod({Key? key}) : super(key: key);

  @override
  _SubModState createState() => _SubModState();
}

class _SubModState extends State<SubMod> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  double _elevation = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen:
          // Scaffold(
          //   body: Row(
          //     children: <Widget>[
          //       NavigationRail(
          //         selectedIndex: _selectedIndex,
          //         onDestinationSelected: (int index) {
          //           setState(() {
          //             _selectedIndex = index;
          //           });
          //         },
          //         labelType: NavigationRailLabelType.selected,
          //         destinations: const [
          //           NavigationRailDestination(
          //             icon: Icon(Icons.favorite_border),
          //             selectedIcon: Icon(Icons.favorite),
          //             label: Text('First'),
          //           ),
          //           NavigationRailDestination(
          //             icon: Icon(Icons.bookmark_border),
          //             selectedIcon: Icon(Icons.book),
          //             label: Text('Second'),
          //           ),
          //           NavigationRailDestination(
          //             icon: Icon(Icons.star_border),
          //             selectedIcon: Icon(Icons.star),
          //             label: Text('Third'),
          //           ),
          //         ],
          //       ),
          //       const VerticalDivider(thickness: 1, width: 1),
          //       // This is the main content.
          //       Expanded(
          //         child: Center(
          //           child: Text('selectedIndex: $_selectedIndex'),
          //         ),
          //       )
          //     ],
          //   ),
          // ),

          // Scaffold(
          //     key: scaffoldKey,
          //     drawer: ClipRRect(
          //       borderRadius: const BorderRadius.only(
          //           topRight: Radius.circular(25),
          //           bottomRight: Radius.circular(25)),
          //       child: SizedBox(
          //         width: 250,
          //         child: Drawer(
          //           child: Container(
          //             color: Colors.grey.shade500,
          //             child: ListView(
          //               children: [
          //                 InkWell(
          //                   onTap: () => Navigator.pop(context),
          //                   onHover: (val) {
          //                     print(val);
          //                     if (val) {
          //                       setState(() {
          //                         _elevation = 18;
          //                       });
          //                     } else {
          //                       setState(() {
          //                         _elevation = 0;
          //                       });
          //                     }
          //                   },
          //                   child: Padding(
          //                     padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
          //                     child: AnimatedPhysicalModel(
          //                       duration: const Duration(milliseconds: 500),
          //                       curve: Curves.fastOutSlowIn,
          //                       elevation: _elevation,
          //                       shape: BoxShape.rectangle,
          //                       shadowColor: Colors.black,
          //                       color: Colors.green,
          //                       // borderRadius: _first
          //                       //     ? const BorderRadius.all(Radius.circular(0))
          //                       //     : const BorderRadius.all(Radius.circular(10)),
          //                       child: const Icon(Icons.menu),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     body: Stack(
          //       children: <Widget>[
          //         // new Center(
          //         //     child: new Column(
          //         //   children: <Widget>[],
          //         // )),
          //         Container(
          //             width: double.infinity,
          //             height: double.infinity,
          //             color: Colors.purple),
          //         Positioned(
          //           left: 10,
          //           top: 20,
          //           child: IconButton(
          //             icon: const Icon(Icons.menu),
          //             onPressed: () => scaffoldKey.currentState!.openDrawer(),
          //           ),
          //         ),
          //       ],
          //     )),
          Material(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.blueGrey,
            ),
            Row(
              children: const [
                // Container(
                //   width: 100,
                //   height: double.infinity,
                //   color: Colors.white54,
                // ),
                SubModSideBar(),
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    // color: Colors.blueGrey,
                    child: Center(child: Text("test")),
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
