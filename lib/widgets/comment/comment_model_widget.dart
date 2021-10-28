import 'package:beamer/beamer.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/comment/comment_util_methods.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class CommentModel extends StatefulWidget {
  final int commentId;

  const CommentModel({Key? key, required this.commentId}) : super(key: key);

  @override
  State<CommentModel> createState() => _CommentModelState();
}

class _CommentModelState extends State<CommentModel> {
  bool _showReplyTextField = false;
  bool _showSubComments = true;

  // bool _isHover

  final TextEditingController _commentTextController = TextEditingController();

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
                  // excludeFromSemantics: true,
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
                      FutureBuilder(
                          future: isAuthenticated(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  snapshot.data == 200
                                      ? TextButton(
                                          onPressed: () => setState(() =>
                                              _showReplyTextField =
                                                  !_showReplyTextField),
                                          child: Text("Reply"))
                                      : const SizedBox(),
                                  // Text("like"),

                                  //Only load rating if auth
                                  snapshot.data == 200
                                      ? FutureBuilder(
                                          future: getUserCommentRating(
                                              widget.commentId),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<int>
                                                  snapshotRating) {
                                            return Row(
                                              children: [
                                                //LIKE
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.thumb_up,
                                                    size: 16,
                                                    color:
                                                        snapshotRating.data == 1
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .brandColor
                                                            : Colors.white60,
                                                  ),
                                                  onPressed: () {
                                                    switch (
                                                        snapshotRating.data) {
                                                      case 0:
                                                        rateComment(
                                                                widget
                                                                    .commentId,
                                                                'like')
                                                            .then((_) =>
                                                                setState(
                                                                    () {}));
                                                        break;
                                                      case 1:
                                                        deleteCommentRating(
                                                                widget
                                                                    .commentId)
                                                            .then((_) =>
                                                                setState(
                                                                    () {}));
                                                        break;
                                                      case 2:
                                                        updateCommentRating(
                                                                widget
                                                                    .commentId,
                                                                'like')
                                                            .then((_) =>
                                                                setState(
                                                                    () {}));
                                                        break;
                                                    }
                                                    // if (snapshotRating.data !=
                                                    //     1) {
                                                    //   likeComment(
                                                    //           widget.commentId)
                                                    //       .then((_) =>
                                                    //           setState(() {}));
                                                    // } else {
                                                    //   print("remove like");
                                                    // }
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                //RATING
                                                const Text("69"),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                // Text("dislike"),
                                                //DISLIKE
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.thumb_down,
                                                    size: 16,
                                                    color:
                                                        snapshotRating.data == 2
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .brandColor
                                                            : Colors.white60,
                                                  ),
                                                  onPressed: () {
                                                    switch (
                                                        snapshotRating.data) {
                                                      case 0:
                                                        rateComment(
                                                                widget
                                                                    .commentId,
                                                                'dislike')
                                                            .then((_) =>
                                                                setState(
                                                                    () {}));
                                                        break;
                                                      case 1:
                                                        updateCommentRating(
                                                                widget
                                                                    .commentId,
                                                                'dislike')
                                                            .then((_) =>
                                                                setState(
                                                                    () {}));
                                                        break;
                                                      case 2:
                                                        deleteCommentRating(
                                                                widget
                                                                    .commentId)
                                                            .then((_) =>
                                                                setState(
                                                                    () {}));
                                                        break;
                                                    }
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            );
                                          })
                                      : const Text(
                                          "login to rate and reply to comments",
                                          style:
                                              TextStyle(color: Colors.white12)),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                      //Reply TextField
                      _showReplyTextField
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 5, 0),
                              child: TextFormField(
                                controller: _commentTextController,
                                cursorColor: Colors.white,
                                autocorrect: false,
                                keyboardType: TextInputType.multiline,
                                maxLength: 256,
                                minLines: 1,
                                maxLines: 20,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      sendReplyComment(
                                          snapshot.data!['commentPostId'],
                                          snapshot.data!['commentId'],
                                          _commentTextController.text);
                                      print("pressed");
                                      setState(() {
                                        _commentTextController.text = "";
                                        _showReplyTextField = false;
                                      });
                                    },
                                  ),
                                  labelText: "Reply to comment",
                                  labelStyle: const TextStyle(
                                      fontFamily: "Segoe UI",
                                      color: Colors.white38,
                                      fontSize: 14),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white54),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide:
                                        const BorderSide(color: Colors.pink),
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Field cannot be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(
                                    fontFamily: "Segoe UI",
                                    color: Colors.white70,
                                    fontSize: 14),
                              ),
                            )
                          : const SizedBox(),
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
                                              child: CommentModel(
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
            // return Container(
            //   color: Colors.blue,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     // crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       //Profile Pictrue
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           InkWell(
            //             // excludeFromSemantics: true,
            //             hoverColor: Colors.transparent,
            //             focusColor: Colors.transparent,
            //             highlightColor: Colors.transparent,
            //             onTap: () {
            //               Beamer.of(context).beamToNamed(
            //                   'profile/' + snapshot.data!['commentUsername']);
            //               print("go to profile");
            //             },
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(14.0),
            //               child: Image.network(
            //                 baseURL +
            //                     snapshot.data!['commentUser']['userProfile']
            //                         ['profilePicturePath'],
            //                 fit: BoxFit.cover,
            //                 alignment: Alignment.center,
            //                 width: 40,
            //                 height: 40,
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 15,
            //           ),
            //           Container(
            //             color: Colors.red,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(snapshot.data!['commentText'] +
            //                     "sssssssssssssssssssssss\nssssssssssssssssssssssssssssssssssssssssss\nsssssssssssssssssssssssssssssssss"),
            //                 const SizedBox(
            //                   height: 5,
            //                 ),
            //                 Container(
            //                   color: Colors.greenAccent,
            //                   child: Row(
            //                     children: [
            //                       Text("Reply"),
            //                       SizedBox(
            //                         width: 10,
            //                       ),
            //                       Text("like"),
            //                       SizedBox(
            //                         width: 5,
            //                       ),
            //                       Text("score"),
            //                       SizedBox(
            //                         width: 5,
            //                       ),
            //                       Text("dislike")
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),

            //       Row(
            //         // mainAxisAlignment: MainAxisAlignment.end,
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           SizedBox(
            //             width: 15,
            //           ),
            //           Text("show answers"),
            //         ],
            //       ),
            //     ],
            //   ),
            // );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
