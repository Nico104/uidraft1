import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';

import 'package:uidraft1/widgets/submod/sidebar/submod_sidebar_widget.dart';
import 'package:uidraft1/widgets/submod/submod_announcement/submod_announce_write_large_widget.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_data_tab_widget.dart';
import 'package:uidraft1/widgets/submod/submod_posts/submod_post_tab_widget.dart';
import 'package:uidraft1/widgets/submod/submod_users/submod_user_tab.dart';

class SubMod extends StatefulWidget {
  const SubMod({Key? key, required this.subchannelName}) : super(key: key);

  final String subchannelName;

  @override
  _SubModState createState() => _SubModState();
}

class _SubModState extends State<SubMod> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void setSelectedIndex(int i) {
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
                    child: getBody(_selectedIndex, widget.subchannelName),
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

Widget getBody(int index, String subchannelname) {
  switch (index) {
    case (0):
      return Container(
          key: ValueKey<int>(index),
          // color: Colors.blue,
          child: SubModDataTab(subchannelName: subchannelname));
    case (1):
      return Container(
          key: ValueKey<int>(index),
          // color: Colors.green,
          child: SubModUsersTab(subchannelName: subchannelname));
    case (2):
      return Container(
          key: ValueKey<int>(index),
          // color: Colors.yellow,
          child: SubModPostTab(subchannelName: subchannelname));
    case (3):
      return Container(
          key: ValueKey<int>(index),
          // color: Colors.yellow,
          child: SubModWriteAnnouncement(subchannelName: subchannelname));
    default:
      return const Center(child: Text("default"));
  }
}
