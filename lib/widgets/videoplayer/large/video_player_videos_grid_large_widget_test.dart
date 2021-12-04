import 'package:flutter/material.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_video_preview_large_widget.dart';
import 'dart:html' as html;

//! In use

class VideoPlayerVideosLargeScreenTest extends StatefulWidget {
  VideoPlayerVideosLargeScreenTest(
      {Key? key,
      required this.setSkipToId,
      required this.postIds,
      required this.isAuth})
      : super(key: videoPlayerRecommendedKey);

  final Function(int) setSkipToId;
  final List<int> postIds;
  final bool isAuth;

  static final GlobalKey<_VideoPlayerVideosStateTest>
      videoPlayerRecommendedKey = GlobalKey<_VideoPlayerVideosStateTest>();

  @override
  _VideoPlayerVideosStateTest createState() => _VideoPlayerVideosStateTest();
}

class _VideoPlayerVideosStateTest
    extends State<VideoPlayerVideosLargeScreenTest> {
  static const _pageSize = 8;
  int _pageKey = 0;

  List<VideoPlayerVideoPreview> videoPreviews = <VideoPlayerVideoPreview>[];

  @override
  void initState() {
    videoPreviews.addAll(getNewRecommendedVideos(
        _pageKey, _pageSize, widget.postIds, widget.isAuth));
    super.initState();
    html.document.onContextMenu.listen((event) => event.preventDefault());
  }

  void appendRecommendedVideos() {
    print("Ah sheesh here we go appending videos again");
    videoPreviews.addAll(getNewRecommendedVideos(
        _pageKey, _pageSize, widget.postIds, widget.isAuth));
    setState(() {
      _pageKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: videoPreviews.length,
      itemBuilder: (context, i) {
        return AspectRatio(
          aspectRatio: (600 / 180),
          child: videoPreviews.elementAt(i),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 20,
      ),
    );
  }
}

List<VideoPlayerVideoPreview> getNewRecommendedVideos(
    int pageKey, int _pageSize, List<int> videoIds, bool isAuth) {
  final int currentIndex = pageKey * _pageSize;
  List<VideoPlayerVideoPreview> videoList = <VideoPlayerVideoPreview>[];
  for (int i = currentIndex; i < currentIndex + _pageSize; i++) {
    videoList.add(VideoPlayerVideoPreview(
      postId: videoIds.elementAt(i),
      isAuth: isAuth,
    ));
  }
  return videoList;
}
