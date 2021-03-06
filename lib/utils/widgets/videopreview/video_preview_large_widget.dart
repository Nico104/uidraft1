import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/videopreview/videopreview_utils_methods.dart'
    as vputils;
import 'package:uidraft1/utils/widgets/videopreview/video_preview_feed_data/video_preview_feed_data_large_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_profile_data/video_preview_profile_data_large_profile.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_subchannel_data/video_preview_subchannel_data_large_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview(
      {Key? key,
      required this.postId,
      required this.isAuth,
      required this.videoPreviewMode})
      : super(key: key);

  final int postId;
  final bool isAuth;
  final vputils.VideoPreviewMode videoPreviewMode;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future: vputils.fetchPostPreviewData(
              widget.postId, connection.returnConnection()),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Listener(
                onPointerDown: (ev) => vputils.onPointerDown(
                    context,
                    ev,
                    snapshot.data!['postId'],
                    snapshot.data!['postSubchannel']['subchannelName'],
                    snapshot.data!['username']),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Beamer.of(context).beamToNamed(
                        'whatchintern/' + widget.postId.toString());
                    if (NavBarLarge.globalKey.currentState == null) {
                      print("current NavBarState null");
                    } else {
                      NavBarLarge.globalKey.currentState!.collapseMenus();
                    }
                    // if (globalKey.currentState == null) {
                    //   print("current NavBarState null");
                    // } else {
                    //   globalKey.currentState!.collapseMenus();
                    // }
                  },
                  child: Column(
                    children: [
                      //Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          // baseURL + "${snapshot.data!['postTumbnailPath']}",
                          spacesEndpoint +
                              "${snapshot.data!['postTumbnailPath']}",
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      //Data Preview
                      LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topLeft,
                              child: getVideoPreviewDataWidget(snapshot)),
                        );
                      })
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  //Thumbnail
                  Expanded(
                    flex: 8,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12.0),
                    )),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12.0),
                    )),
                  ),
                ],
              );
            }
          });
    });
  }

  //Returns correct VideoPreviewData Widget for wherever the Video Prefview is shown
  Widget getVideoPreviewDataWidget(
      AsyncSnapshot<Map<String, dynamic>> snapshot) {
    switch (widget.videoPreviewMode) {
      //Feed Video Preview
      case vputils.VideoPreviewMode.feed:
        return VideoPreviewFeedDataLarge(
          auth: widget.isAuth,
          postId: widget.postId,
          commentCount: snapshot.data!['_count']['comments'],
          picturePath: snapshot.data!['postSubchannel']['subchannelPreview']
              ['subchannelSubchannelPicturePath'],
          subchannelName: snapshot.data!['postSubchannel']['subchannelName'],
          title: snapshot.data!['postTitle'],
          username: snapshot.data!['username'],
          views: snapshot.data!['_count']['postWhatchtimeAnalytics'],
        );
      //Subchannel Video Preview
      case vputils.VideoPreviewMode.subchannel:
        return VideoPreviewSubchannelDataLarge(
          auth: widget.isAuth,
          postId: widget.postId,
          commentCount: snapshot.data!['_count']['comments'],
          picturePath: snapshot.data!['user']['userProfile']
              ['profilePicturePath'],
          title: snapshot.data!['postTitle'],
          username: snapshot.data!['username'],
          views: snapshot.data!['_count']['postWhatchtimeAnalytics'],
        );
      //Profile Video preview
      case vputils.VideoPreviewMode.profile:
        return VideoPreviewProfileDataLarge(
          auth: widget.isAuth,
          postId: widget.postId,
          commentCount: snapshot.data!['_count']['comments'],
          picturePath: snapshot.data!['postSubchannel']['subchannelPreview']
              ['subchannelSubchannelPicturePath'],
          subchannelName: snapshot.data!['postSubchannel']['subchannelName'],
          title: snapshot.data!['postTitle'],
          views: snapshot.data!['_count']['postWhatchtimeAnalytics'],
        );
    }
  }
}
