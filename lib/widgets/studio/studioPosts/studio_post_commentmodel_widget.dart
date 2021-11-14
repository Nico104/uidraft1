import 'package:beamer/beamer.dart';
import 'package:uidraft1/utils/comment/comment_util_methods.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

class StudioCommentModel extends StatefulWidget {
  final int commentId;

  const StudioCommentModel({Key? key, required this.commentId})
      : super(key: key);

  @override
  State<StudioCommentModel> createState() => _StudioCommentModelState();
}

class _StudioCommentModelState extends State<StudioCommentModel> {
  bool _showSubComments = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCommentData(widget.commentId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            //Calculate Subcomments
            List<int> subCommentIds = <int>[];
            List<dynamic> values = snapshot.data!['subcomments'];
            if (values.isNotEmpty) {
              for (int i = 0; i < values.length; i++) {
                if (values[i] != null) {
                  Map<String, dynamic> map = values[i];
                  subCommentIds.add(map['commentId']);
                }
              }
            }
            print("Subcomments: " + subCommentIds.toString());
            //Comment
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Beamer.of(context).beamToNamed(
                        'profile/' + snapshot.data!['commentUsername']);
                    print("go to profile");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image.network(
                      baseURL +
                          snapshot.data!['commentUser']['userProfile']
                              ['profilePicturePath'],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!['commentUsername'],
                        style: const TextStyle(color: Colors.white38),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(snapshot.data!['commentText']),
                          subCommentIds.isNotEmpty
                              ? TextButton.icon(
                                  onPressed: () => setState(() {
                                    _showSubComments = !_showSubComments;
                                  }),
                                  label: Text(subCommentIds.length == 1
                                      ? "1 Reply"
                                      : subCommentIds.length.toString() +
                                          " Replies"),
                                  icon: Icon(_showSubComments
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Show Subcomments/Comment Reply
                      subCommentIds.isNotEmpty
                          ? _showSubComments
                              ? FutureBuilder(
                                  future: getSubCommentIds(widget.commentId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<int>> snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 20, 5, 0),
                                              child: StudioCommentModel(
                                                  commentId: snapshot.data!
                                                      .elementAt(index)),
                                            );
                                          });
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )
                              : const SizedBox()
                          : const SizedBox(),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
