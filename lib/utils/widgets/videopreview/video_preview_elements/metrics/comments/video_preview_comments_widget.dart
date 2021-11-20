import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class VideoPreviewCommentsCount extends StatelessWidget {
  const VideoPreviewCommentsCount({Key? key, required this.commentCount})
      : super(key: key);

  final int commentCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.mode_comment_outlined,
          color: Theme.of(context).colorScheme.navBarIconColor,
          size: 17,
        ),
        const SizedBox(
          width: 4,
        ),
        //Comment Count
        Text(commentCount.toString())
      ],
    );
  }
}
