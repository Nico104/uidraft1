import 'dart:typed_data';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

class UploadVideoPlayerVideoPreview extends StatelessWidget {
  final String postTitle;
  final String postSubchannel;
  final String postUsername;
  final Uint8List? thumbnailPreview;

  const UploadVideoPlayerVideoPreview(
      {Key? key,
      required this.postTitle,
      required this.postSubchannel,
      required this.postUsername,
      required this.thumbnailPreview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Thumbnail
        Flexible(
          // fit: FlexFit.tight,
          flex: 6,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: thumbnailPreview != null
                  ? Image.memory(
                      thumbnailPreview!,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      baseURL +
                          "uploads/default/defaultUploadVideoThumbnailPreview.png",
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        //Data Preview
        Flexible(
          //fit: FlexFit.loose,
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  postTitle,
                  //overflow: TextOverflow.fade,
                  // softWrap: false,
                  maxLines: MediaQuery.of(context).size.width >= 1650 ? 3 : 2,
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize:
                          MediaQuery.of(context).size.width >= 1650 ? 15 : 13,
                      color:
                          Theme.of(context).colorScheme.videoPreviewTextColor,
                      letterSpacing: 1),
                ),
                const SizedBox(
                  height: 12,
                ),
                //Video Preview Data
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Subchannel
                    Row(
                      children: [
                        //Subchannel icon
                        Icon(
                          Icons.smart_display_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 10,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        //Subchannelname
                        Text(
                          postSubchannel,
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  MediaQuery.of(context).size.width >= 1650
                                      ? 12
                                      : 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .videoPreviewTextColor,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    //User
                    Row(
                      children: [
                        //User icon
                        Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 10,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        //Subchannelname
                        Text(
                          postUsername,
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  MediaQuery.of(context).size.width >= 1650
                                      ? 12
                                      : 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .videoPreviewTextColor,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    //Metrics
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Score - trending icon
                        Icon(
                          Icons.trending_up_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 10,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        //Score
                        Text(
                          "699",
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  MediaQuery.of(context).size.width >= 1650
                                      ? 12
                                      : 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .videoPreviewTextColor,
                              letterSpacing: 1),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Dot in the middle
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).colorScheme.navBarIconColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Comments Icon
                        Icon(
                          Icons.mode_comment_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 10,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        //Comment Count
                        Text(
                          "304",
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize:
                                  MediaQuery.of(context).size.width >= 1650
                                      ? 12
                                      : 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .videoPreviewTextColor,
                              letterSpacing: 1),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
