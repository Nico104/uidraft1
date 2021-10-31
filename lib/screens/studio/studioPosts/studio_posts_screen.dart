import 'package:flutter/material.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/comment/comment_post_util_methods.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/utils/studio/studio_util_methods.dart';
import 'package:uidraft1/widgets/studio/studioPosts/studio_post_metrics.dart';
import 'package:uidraft1/widgets/studio/studioPosts/studio_post_preview_widget.dart';
import 'package:uidraft1/widgets/studio/studioPosts/studio_post_commentmodel_widget.dart';

class StudioPostsScreen extends StatefulWidget {
  const StudioPostsScreen({Key? key}) : super(key: key);
  @override
  _StudioPostsState createState() => _StudioPostsState();
}

class _StudioPostsState extends State<StudioPostsScreen> {
  int? chosenPostId;

  ScrollController _scrollControllerPosts = ScrollController();
  ScrollController _scrollControllerComments = ScrollController();

  @override
  void initState() {
    // incrementPostViewsByOne(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: fetchUserPosts(),
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            if (snapshot.hasData) {
              return ResponsiveWidget(
                smallScreen: const Text("smallScreen"),
                mediumScreen: const Text("mediumScreen"),
                largeScreen: Material(
                  child: snapshot.data!.isNotEmpty
                      ? Row(
                          children: [
                            Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[800],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: ListView.builder(
                                      controller: _scrollControllerPosts,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        print(index);
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: InkWell(
                                            onTap: () => setState(() {
                                              chosenPostId = snapshot.data!
                                                  .elementAt(index);
                                            }),
                                            child: StudioVideoPreview(
                                                postId: snapshot.data!
                                                    .elementAt(index)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )),
                            Flexible(
                                flex: 8,
                                child: chosenPostId != null
                                    ? Row(
                                        children: [
                                          Flexible(
                                              flex: 7,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  // color: Colors.green,
                                                  child: StudioPostMetrics(
                                                      postId: chosenPostId!),
                                                ),
                                              )),
                                          Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Container(
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueGrey[800],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: FutureBuilder(
                                                        future:
                                                            fetchPostComments(
                                                                chosenPostId!),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    List<int>>
                                                                snapshotComments) {
                                                          if (snapshotComments
                                                              .hasData) {
                                                            if (snapshotComments
                                                                .data!
                                                                .isNotEmpty) {
                                                              return ListView
                                                                  .builder(
                                                                      controller:
                                                                          _scrollControllerComments,
                                                                      // shrinkWrap:
                                                                      //     true,
                                                                      itemCount: snapshotComments
                                                                          .data!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Column(
                                                                          children: [
                                                                            StudioCommentModel(commentId: snapshotComments.data!.elementAt(index)),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                            } else {
                                                              return const Center(
                                                                child: Text(
                                                                    "no comments for video"),
                                                              );
                                                            }
                                                          } else {
                                                            return const CircularProgressIndicator();
                                                          }
                                                        }),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      )
                                    : Container()),
                          ],
                        )
                      : const Text(
                          "oh no, it seems like you haven't uploaded any videos"),
                ),
                veryLargeScreen: const Text("veryLargeScreen"),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
