import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class VideoPreviewDividerDot extends StatelessWidget {
  const VideoPreviewDividerDot(
      {Key? key, required this.diameter, required this.spacing})
      : super(key: key);

  final double diameter;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: spacing,
        ),
        Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.navBarIconColor,
          ),
        ),
        SizedBox(
          width: spacing,
        ),
      ],
    );
  }
}
