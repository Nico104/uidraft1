import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart'
    as postUtils;
import 'package:uidraft1/utils/studio/studio_util_methods.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/utils/util_methods.dart';
import 'package:uidraft1/widgets/message/write_message_large_dialog.dart';
import 'package:uidraft1/widgets/submod/submod_posts/submod_post_buttons_widget.dart';

class SubModPostListItem extends StatefulWidget {
  const SubModPostListItem(
      {Key? key, required this.postId, required this.notifyParent})
      : super(key: key);

  final int postId;
  final Function() notifyParent;

  @override
  _SubModPostListItemState createState() => _SubModPostListItemState();
}

class _SubModPostListItemState extends State<SubModPostListItem> {
  bool _onHover = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSubModPostMetrics(widget.postId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {},
              onHover: (val) {
                print(val);
                if (val) {
                  if (mounted) {
                    setState(() {
                      _onHover = true;
                    });
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      _onHover = false;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 6,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                          child: Image.network(
                            // baseURL + userNames.elementAt(index).elementAt(1),
                            postUtils.baseURL +
                                snapshot.data!['postTumbnailPath'],
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            // width: 40,
                            // height: 40,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // userNames.elementAt(index).first,
                            snapshot.data!['postTitle'],
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tags",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white60),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // userNames.elementAt(index).first,
                            snapshot.data!['postDescription'],
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // userNames.elementAt(index).first,
                            "Reports: " +
                                snapshot.data!['_count']['reports'].toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder(
                              future: postUtils.getPostRatingScore(
                                widget.postId,
                              ),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshotRating) {
                                if (snapshotRating.hasData) {
                                  return Column(
                                    children: [
                                      Text(
                                        // userNames.elementAt(index).first,
                                        "Rating: " +
                                            snapshotRating.data.toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                          Text(
                            // userNames.elementAt(index).first,
                            "Views: " +
                                snapshot.data!['_count']
                                        ['postWhatchtimeAnalytics']
                                    .toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // userNames.elementAt(index).first,
                            "UploadDateTime: " +
                                formatDate(snapshot.data!['postAnalytics']
                                        ['postUploadedDateTime']
                                    .toString()),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          // SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: _onHover
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Delete
                                SubModPostButton(
                                  color:
                                      Theme.of(context).colorScheme.brandColor,
                                  iconData: Icons.delete,
                                  toolTipMsg: "Delte Post",
                                  handeleTap: () => deletePost(widget.postId)
                                      .then((value) =>
                                          widget.notifyParent.call()),
                                  // handeleTap: () {},
                                ),
                                const SizedBox(height: 5),
                                SubModPostButton(
                                  color: Colors.white70,
                                  iconData: Icons.list,
                                  toolTipMsg: "Whitelist Post",
                                  handeleTap: () => whiteListPost(widget.postId)
                                      .then((value) =>
                                          widget.notifyParent.call()),
                                  // handeleTap: () {},
                                ),
                                const SizedBox(height: 5),
                                SubModPostButton(
                                  color: Colors.blue,
                                  iconData: Icons.flag,
                                  toolTipMsg: "Remove Post Reports",
                                  handeleTap: () =>
                                      removePostReports(widget.postId).then(
                                          (value) =>
                                              widget.notifyParent.call()),
                                  // handeleTap: () {},
                                ),
                                const SizedBox(height: 5),
                                SubModPostButton(
                                  color: Colors.orange,
                                  iconData: Icons.chat_bubble,
                                  toolTipMsg: "Message User",
                                  handeleTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            WriteMessageDialogLargeScreen(
                                                toUsername: snapshot
                                                    .data!['username']));
                                  },
                                  // handeleTap: () {},
                                ),
                                // const SizedBox(height: 5),
                                // SubModPostButton(
                                //   color: Colors.green,
                                //   iconData: Icons.check,
                                //   toolTipMsg: "This is a tooltip",
                                //   handeleTap: () {},
                                // ),
                              ],
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
