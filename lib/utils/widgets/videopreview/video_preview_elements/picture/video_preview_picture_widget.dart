import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

class VideoPreviewPicture extends StatelessWidget {
  const VideoPreviewPicture(
      {Key? key,
      required this.width,
      required this.height,
      required this.picturePath,
      required this.onTap})
      : super(key: key);

  final double width;
  final double height;
  final String picturePath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      excludeFromSemantics: true,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap.call(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: Image.network(
          baseURL + picturePath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
