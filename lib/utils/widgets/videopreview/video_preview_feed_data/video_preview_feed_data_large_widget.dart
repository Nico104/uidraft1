import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/dividerDot/video_preview_divider_dot_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/metrics/comments/video_preview_comments_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/metrics/ratingscore/video_preview_rating_score_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/metrics/views/video_preview_views_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/picture/video_preview_picture_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/subchannel/video_preview_subchannel_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/title/video_preview_title_widget.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_elements/user/video_preview_user_widget.dart';

class VideoPreviewFeedDataLarge extends StatelessWidget {
  const VideoPreviewFeedDataLarge(
      {Key? key,
      required this.picturePath,
      required this.subchannelName,
      required this.title,
      required this.username,
      required this.auth,
      required this.commentCount,
      required this.views,
      required this.postId})
      : super(key: key);

  final int postId;
  final String picturePath;
  final String subchannelName;
  final String title;
  final String username;
  final bool auth;
  final int commentCount;
  final int views;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 3,
        ),
        //Profile Pictrue / Subchannel Profile Picture
        VideoPreviewPicture(
          height: 40,
          width: 40,
          picturePath: picturePath,
          onTap: () {
            Beamer.of(context).beamToNamed('subchannel/' + subchannelName);
            print("go to subchnanel or profile");
          },
        ),
        const SizedBox(width: 10),
        //Metrics
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            VideoPreviewTitleLarge(
              title: title,
              leftSpacing: 2,
            ),
            const SizedBox(
              height: 7,
            ),
            //User and Subchannel Information
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //User
                VideoPreviewUsernameLarge(
                  username: username,
                ),
                //Dot in the middle
                const VideoPreviewDividerDot(diameter: 5, spacing: 10),
                //Subchannel
                VideoPreviewSubchannelLarge(subchannelname: subchannelName),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            //Metrics
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Score - trending icon
                VideoPreviewRatingScore(
                  auth: auth,
                  postId: postId,
                ),
                //Comments Icon
                VideoPreviewCommentsCount(commentCount: commentCount),
                //Divider Dot in the middle
                const VideoPreviewDividerDot(diameter: 5, spacing: 10),
                //Views Icon
                VideoPreviewViews(views: views),
              ],
            )
          ],
        )
      ],
    );
  }
}
