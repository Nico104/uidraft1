import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/dividerDot/video_preview_divider_dot_widget.dart';

class VideoPreviewRatingScore extends StatelessWidget {
  const VideoPreviewRatingScore(
      {Key? key, required this.auth, required this.postId})
      : super(key: key);

  final bool auth;
  final int postId;

  @override
  Widget build(BuildContext context) {
    if (auth) {
      return Consumer<ConnectionService>(builder: (context, connection, _) {
        return FutureBuilder(
            future: getPostRatingScore(postId, connection.returnConnection()),
            builder: (BuildContext context, AsyncSnapshot<int> snapshotRating) {
              if (snapshotRating.hasData) {
                return Row(
                  children: [
                    Icon(
                      Icons.trending_up_outlined,
                      color: Theme.of(context).colorScheme.navBarIconColor,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    //Score
                    Text(snapshotRating.data.toString()),
                    const VideoPreviewDividerDot(diameter: 5, spacing: 10)
                  ],
                );
              } else {
                return const SizedBox();
              }
            });
      });
    } else {
      return const SizedBox();
    }
  }
}
