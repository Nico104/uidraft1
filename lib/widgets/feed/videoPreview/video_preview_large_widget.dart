import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/videopreview/videopreview_utils_methods.dart'
    as vputils;
import 'package:uidraft1/utils/widgets/videopreview/video_preview_feed_data/video_preview_feed_data_large_widget.dart';

class VideoPreview extends StatefulWidget {
  final int postId;
  final bool isAuth;

  const VideoPreview({Key? key, required this.postId, required this.isAuth})
      : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  String baseURL = 'http://localhost:3000/';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: vputils.fetchPostPreviewData(widget.postId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Beamer.of(context)
                    .beamToNamed('whatchintern/' + widget.postId.toString());
              },
              child: Column(
                children: [
                  //Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      "http://localhost:3000/${snapshot.data!['postTumbnailPath']}",
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
                          child: VideoPreviewFeedDataLarge(
                            auth: widget.isAuth,
                            postId: widget.postId,
                            commentCount: snapshot.data!['_count']['comments'],
                            picturePath: snapshot.data!['postSubchannel']
                                    ['subchannelPreview']
                                ['subchannelSubchannelPicturePath'],
                            subchannelName: snapshot.data!['postSubchannel']
                                ['subchannelName'],
                            title: snapshot.data!['postTitle'],
                            username: snapshot.data!['username'],
                            views: snapshot.data!['_count']
                                ['postWhatchtimeAnalytics'],
                          )),
                    );
                  })
                ],
              ),
            );
          } else {
            return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Theme.of(context).canvasColor,
                child: const Text("loading"));
          }
        });
  }
}
