import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class VideoPreviewViews extends StatelessWidget {
  const VideoPreviewViews({Key? key, required this.views}) : super(key: key);

  final int views;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.visibility_outlined,
          color: Theme.of(context).colorScheme.navBarIconColor,
          size: 17,
        ),
        const SizedBox(
          width: 4,
        ),
        //Views
        Text(views.toString()),
      ],
    );
  }
}
