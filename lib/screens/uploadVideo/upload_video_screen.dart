import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uidraft1/screens/feed/feed_screen.dart';
import 'package:uidraft1/uiwidgets/blindgaenger/navbar/empty_navbar_widget.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/uploadVideo/large/upload_video_data_large_widget.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({
    Key? key,
    required this.videoBytes,
    this.bypassNavBarFreeing = false,
  }) : super(key: key);

  final Uint8List videoBytes;
  final bool bypassNavBarFreeing;

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideoScreen> {
  Widget _navbar = const EmptyNavBarLarge();

  void initNavBar() async {
    if (NavBarLarge.globalKey.currentState == null ||
        widget.bypassNavBarFreeing) {
      setState(() {
        _navbar = NavBarLarge(
          // notification: false,
          customFeed: false,
          setActiveFeed: (i) {},
          activeFeed: 0,
          onLogoClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedScreen()),
            );
          },
        );
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 30), () {});
      initNavBar();
    }
  }

  @override
  void initState() {
    initNavBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            UploadVideoDataLargeScreen(videoBytes: widget.videoBytes),
            // NavBarLarge(
            //   notification: false,
            //   customFeed: false,
            //   setActiveFeed: (i) {},
            //   activeFeed: 0,
            //   onLogoClick: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const FeedScreen()),
            //     );
            //   },
            // )
            _navbar
          ],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
