import 'package:beamer/beamer.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/comment/comment_util_methods.dart';
import 'package:flutter/material.dart';

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
                                  label: const Text("Replies"),
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
                      Row(
                        children: [
                          FutureBuilder(
                              future: isAuthenticated(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (snapshot.data == 200) {
                                  return TextButton(
                                      onPressed: () => setState(() =>
                                          _showReplyTextField =
                                              !_showReplyTextField),
                                      child: Text("Reply"));
                                } else {
                                  return const SizedBox();
                                }
                              }),
                          // Text("like"),
                          IconButton(
                            icon: const Icon(
                              Icons.thumb_up,
                              size: 16,
                              color: Colors.white60,
                            ),
                            onPressed: () {
                              print("pressed");
                              likeComment(widget.commentId);
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text("69"),
                          const SizedBox(
                            width: 8,
                          ),
                          // Text("dislike"),
                          IconButton(
                            icon: const Icon(
                              Icons.thumb_down,
                              size: 16,
                              color: Colors.white60,
                            ),
                            onPressed: () {
                              dislikeComment(widget.commentId);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
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
