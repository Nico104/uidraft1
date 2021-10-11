import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/videoplayer/video_player_test2_widget.dart';
import 'package:uidraft1/widgets/videoplayer/video_player_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          // children: [ChapterVideoPlayer(), const NavBarLargeProfile()],
          children: [VideoPlayerApp(), const NavBarLargeProfile()],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
