import 'dart:convert';
import 'package:beamer/beamer.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';

class SubchannelVideoPreview extends StatefulWidget {
  final int postId;
  final bool isAuth;

  const SubchannelVideoPreview(
      {Key? key, required this.postId, required this.isAuth})
      : super(key: key);

  @override
  State<SubchannelVideoPreview> createState() => _SubchannelVideoPreviewState();
}

class _SubchannelVideoPreviewState extends State<SubchannelVideoPreview> {
  String baseURL = 'http://localhost:3000/';
  //Get PostPreview Data by Id
  Future<Map<String, dynamic>> fetchPostPreviewData(int id) async {
    print("In Preview 2");
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 3,
                            ),
                            //Subchannel Pictrue / Subchannel Subchannel Picture
                            InkWell(
                              excludeFromSemantics: true,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Beamer.of(context).beamToNamed('profile/' +
                                    snapshot.data!['username'].toString());
                                print("go to profile");
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14.0),
                                child: Image.network(
                                  baseURL +
                                      snapshot.data!['user']['userProfile']
                                          ['profilePicturePath'],
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            //Metrics
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    //Title
                                    Container(
                                      color: Theme.of(context).canvasColor,
                                      width: 320,
                                      child: Text(
                                        snapshot.data!['postTitle'],
                                        //overflow: TextOverflow.fade,
                                        //softWrap: false,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 17,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .videoPreviewTextColor,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                //User and Subchannel Information
                                Container(
                                  color: Theme.of(context).canvasColor,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //User Person icon
                                      Icon(
                                        Icons.person_outline_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .navBarIconColor,
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      //Username
                                      Text(snapshot.data!['username']),
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
                                      //Views Icon
                                      Icon(
                                        Icons.visibility_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .navBarIconColor,
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      //Views
                                      Text("42044"),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                //Metrics
                                Container(
                                  color: Theme.of(context).canvasColor,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                        size: 17,
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      //Score
                                                      Text(snapshotRating.data
                                                          .toString()),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      //Dot in the middle
                                                      Container(
                                                        width: 5,
                                                        height: 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Theme.of(
                                                                  context)
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
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      //Comment Count
                                      Text(snapshot.data!['_count']['comments']
                                          .toString()),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
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
