import 'package:provider/provider.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/comment/comment_util_methods.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/network/http_client.dart';

import 'comment_parts/comment_profile_picture_widget.dart';
import 'comment_parts/comment_rating_widget.dart';
import 'comment_parts/comment_reply_textformfield_widget.dart';
import 'comment_parts/subcomments_widget.dart';

///Returns Comment Model
///takes [commentId] as the Comments ID, which will be showen
class CommentModel extends StatefulWidget {
  final int commentId;

  const CommentModel({Key? key, required this.commentId}) : super(key: key);

  @override
  State<CommentModel> createState() => _CommentModelState();
}

class _CommentModelState extends State<CommentModel> {
  bool _showReplyTextField = false;
  bool _showSubComments = true;

  final TextEditingController _commentTextController = TextEditingController();

  FocusNode fnReply = FocusNode();

  @override
  void dispose() {
    fnReply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future:
              fetchCommentData(widget.commentId, connection.returnConnection()),
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
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentProfilePicture(
                    commentUsername: snapshot.data!['commentUsername'],
                    profilePicturePath: snapshot.data!['commentUser']
                        ['userProfile']['profilePicturePath'],
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
                            future:
                                isAuthenticated(connection.returnConnection()),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  children: [
                                    snapshot.data == 200
                                        ? TextButton(
                                            onPressed: () {
                                              setState(() =>
                                                  _showReplyTextField =
                                                      !_showReplyTextField);
                                              if (_showReplyTextField) {
                                                fnReply.requestFocus();
                                              }
                                            },
                                            child: Text("Reply"))
                                        : const SizedBox(),
                                    // Text("like"),

                                    //Only load rating if auth
                                    snapshot.data == 200
                                        ? CommentRating(
                                            client:
                                                connection.returnConnection(),
                                            commentId: widget.commentId,
                                            setStateCallback: () =>
                                                setState(() {}),
                                          )
                                        : const Text(
                                            "login to rate and reply to comments",
                                            style: TextStyle(
                                                color: Colors.white12)),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                        //Reply TextField
                        _showReplyTextField
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 5, 0),
                                child: CommentReplyTextFormField(
                                  commentTextController: _commentTextController,
                                  fnReply: fnReply,
                                  commentId: snapshot.data!['commentId'],
                                  commentpostId:
                                      snapshot.data!['commentPostId'],
                                  client: connection.returnConnection(),
                                  afterReplySend: () {
                                    setState(() {
                                      _commentTextController.text = "";
                                      _showReplyTextField = false;
                                    });
                                  },
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        //Show Subcomments/Comment Reply
                        subCommentIds.isNotEmpty
                            ? _showSubComments
                                ? Subcomments(
                                    commentId: widget.commentId,
                                    client: connection.returnConnection(),
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
    });
  }
}
