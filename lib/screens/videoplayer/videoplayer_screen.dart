import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/uiwidgets/blindgaenger/navbar/empty_navbar_widget.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_large_widget.dart';
// import 'dart:html' as html;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {Key? key, required this.postId, required this.firtTimeExternAccess})
      : super(key: key);

  final int postId;
  final bool firtTimeExternAccess;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  Widget _navbar = const EmptyNavBarLarge();

  void initNavBar() async {
    if (NavBarLarge.globalKey.currentState == null) {
      setState(() {
        _navbar = NavBarLarge(
          setActiveFeed: (_) {},
          activeFeed: 0,
          customFeed: false,
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
    return Scaffold(
      body: Consumer<ConnectionService>(builder: (context, connection, _) {
        return FutureBuilder(
            future: fetchPostData(widget.postId, connection.returnConnection()),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                return ResponsiveWidget(
                  smallScreen: const Text("smallScreen"),
                  mediumScreen: const Text("mediumScreen"),
                  largeScreen: Material(
                    child: VideoPlayerHome(
                      postData: snapshot.data!,
                      firtTimeExternAccess: widget.firtTimeExternAccess,
                      // navbar: NavBarLarge(
                      //   setActiveFeed: (_) {},
                      //   activeFeed: 0,
                      //   customFeed: false,
                      // ),
                      navbar: _navbar,
                    ),
                  ),
                  veryLargeScreen: const Text("veryLargeScreen"),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      }),
    );
  }
}
