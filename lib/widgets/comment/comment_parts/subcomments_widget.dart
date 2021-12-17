import 'package:flutter/material.dart';
import 'package:uidraft1/utils/comment/comment_util_methods.dart';

import '../comment_model_widget.dart';

import 'package:http/http.dart' as http;

///Return the Comments Subcomments
///takes [commentID] for the current Comment
///takes [client] as a HTTP Client
class Subcomments extends StatelessWidget {
  const Subcomments({
    Key? key,
    required this.commentId,
    required this.client,
  }) : super(key: key);

  final int commentId;
  final http.Client client;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSubCommentIds(commentId, client),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 0),
                  child:
                      CommentModel(commentId: snapshot.data!.elementAt(index)),
                );
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
