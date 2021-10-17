import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_large_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        // child: Stack(
        //   alignment: Alignment.topCenter,
        //   // children: [ChapterVideoPlayer(), const NavBarLargeProfile()],
        //   children: const [VideoPlayerHome(), NavBarLargeProfile()],
        // ),
        child: VideoPlayerHome(),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
