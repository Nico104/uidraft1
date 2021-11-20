import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class VideoPreviewTitleLarge extends StatelessWidget {
  const VideoPreviewTitleLarge(
      {Key? key, required this.title, required this.leftSpacing})
      : super(key: key);

  final String title;
  final double leftSpacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: leftSpacing,
        ),
        //Title
        SizedBox(
          width: 320,
          child: Text(
            title,
            //overflow: TextOverflow.fade,
            //softWrap: false,
            maxLines: 2,
            style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 17,
                color: Theme.of(context).colorScheme.videoPreviewTextColor,
                letterSpacing: 1),
          ),
        ),
      ],
    );
  }
}
