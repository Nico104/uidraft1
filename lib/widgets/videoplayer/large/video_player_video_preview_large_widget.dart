import 'dart:convert';
import 'package:beamer/beamer.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/videopreview/videopreview_utils_methods.dart'
    as vputils;

class VideoPlayerVideoPreview extends StatefulWidget {
  final int postId;
  final bool isAuth;

  const VideoPlayerVideoPreview(
      {Key? key, required this.postId, required this.isAuth})
      : super(key: key);

  @override
  State<VideoPlayerVideoPreview> createState() =>
      _VideoPlayerVideoPreviewState();
}

class _VideoPlayerVideoPreviewState extends State<VideoPlayerVideoPreview> {
  String baseURL = 'http://localhost:3000/';
  //Get PostPreview Data by Id
  Future<Map<String, dynamic>> fetchPostPreviewData(int id) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/post/getPostPreviewData/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        return map;
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPostPreviewData(widget.postId),
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
                  Beamer.of(context)
                      .beamToNamed('whatchintern/' + widget.postId.toString());
                },
                child: Row(
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
                          child: Image.network(
                            "http://localhost:3000/${snapshot.data!['postTumbnailPath']}",
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
                              snapshot.data!['postTitle'],
                              //overflow: TextOverflow.fade,
                              // softWrap: false,
                              maxLines:
                                  MediaQuery.of(context).size.width >= 1650
                                      ? 3
                                      : 2,
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      MediaQuery.of(context).size.width >= 1650
                                          ? 15
                                          : 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPreviewTextColor,
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
                                InkWell(
                                  excludeFromSemantics: true,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Beamer.of(context).beamToNamed(
                                        'subchannel/' +
                                            snapshot.data!['postSubchannel']
                                                ['subchannelName']);
                                    print("go to subchnanel or profile");
                                  },
                                  child: Row(
                                    children: [
                                      //Subchannel icon
                                      Icon(
                                        Icons.smart_display_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .navBarIconColor,
                                        size: 10,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      //Subchannelname
                                      Text(
                                        "c/" +
                                            snapshot.data!['postSubchannel']
                                                ['subchannelName'],
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1650
                                                ? 12
                                                : 8,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .videoPreviewTextColor,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                //User
                                InkWell(
                                  excludeFromSemantics: true,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Beamer.of(context).beamToNamed('profile/' +
                                        snapshot.data!['username']);
                                    print("go to subchnanel or profile");
                                  },
                                  child: Row(
                                    children: [
                                      //User icon
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .navBarIconColor,
                                        size: 10,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      //Subchannelname
                                      Text(
                                        snapshot.data!['username'],
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1650
                                                ? 12
                                                : 8,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .videoPreviewTextColor,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
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
                                    widget.isAuth
                                        ? FutureBuilder(
                                            future: getPostRatingScore(
                                                widget.postId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<int>
                                                    snapshotRating) {
                                              if (snapshotRating.hasData) {
                                                return Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .trending_up_outlined,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .navBarIconColor,
                                                      size: 10,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    //Score
                                                    Text(
                                                      snapshotRating.data
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Segoe UI',
                                                          fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width >=
                                                                  1650
                                                              ? 12
                                                              : 8,
                                                          color: Theme.of(
                                                                  context)
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
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .navBarIconColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            })
                                        : const SizedBox(),

                                    //Comments Icon
                                    Icon(
                                      Icons.mode_comment_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .navBarIconColor,
                                      size: 10,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    //Comment Count
                                    Text(
                                      snapshot.data!['_count']['comments']
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >=
                                                  1650
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
                ),
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
