import 'package:flutter/material.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
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
  @override
  void initState() {
    // incrementPostViewsByOne(widget.postId);
    // createWhatchtimeAnalyticPost(widget.postId);
    super.initState();
  }

  // @override
  // void dispose() {
  //   print("dispose");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: fetchPostData(widget.postId),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ResponsiveWidget(
                smallScreen: const Text("smallScreen"),
                mediumScreen: const Text("mediumScreen"),
                largeScreen: Material(
                  // child: Stack(
                  //   alignment: Alignment.topCenter,
                  //   // children: [ChapterVideoPlayer(), const NavBarLargeProfile()],
                  //   children: const [VideoPlayerHome(), NavBarLargeProfile()],
                  // ),
                  child: VideoPlayerHome(
                    postData: snapshot.data!,
                    firtTimeExternAccess: widget.firtTimeExternAccess,
                    navbar: NavBarLarge(
                      setActiveFeed: (_) {},
                      activeFeed: 0,
                      customFeed: false,
                    ),
                  ),
                ),
                veryLargeScreen: const Text("veryLargeScreen"),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
