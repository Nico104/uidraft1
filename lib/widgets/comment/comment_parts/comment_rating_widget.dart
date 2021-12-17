import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/comment/comment_util_methods.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

///Return the Comment Rating and the Comment Rating Option
///takes [commentID] for the current Comment
///takes [client] as a HTTP Client
///takes [setStateCallback] to call the [CommentModel]s setState method
class CommentRating extends StatelessWidget {
  const CommentRating(
      {Key? key,
      required this.commentId,
      required this.client,
      required this.setStateCallback})
      : super(key: key);

  final int commentId;
  final http.Client client;

  final Function() setStateCallback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          getUserCommentRating(commentId, client),
          getCommentRatingScore(commentId, client)
        ]),
        builder:
            (BuildContext context, AsyncSnapshot<List<int>> snapshotRating) {
          if (snapshotRating.hasData) {
            return Row(
              children: [
                //LIKE
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    size: 16,
                    color: snapshotRating.data![0] == 1
                        ? Theme.of(context).colorScheme.brandColor
                        : Colors.white60,
                  ),
                  onPressed: () {
                    switch (snapshotRating.data![0]) {
                      case 0:
                        rateComment(commentId, 'like', client).then((_) {
                          setStateCallback.call();
                        });
                        break;
                      case 1:
                        deleteCommentRating(commentId, client).then((_) {
                          setStateCallback.call();
                        });
                        break;
                      case 2:
                        updateCommentRating(commentId, 'like', client)
                            .then((_) {
                          setStateCallback.call();
                        });
                        break;
                    }
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                //RATING
                Text(snapshotRating.data![1].toString()),
                const SizedBox(
                  width: 8,
                ),
                // Text("dislike"),
                //DISLIKE
                IconButton(
                  icon: Icon(
                    Icons.thumb_down,
                    size: 16,
                    color: snapshotRating.data![0] == 2
                        ? Theme.of(context).colorScheme.brandColor
                        : Colors.white60,
                  ),
                  onPressed: () {
                    switch (snapshotRating.data![0]) {
                      case 0:
                        rateComment(commentId, 'dislike', client).then((_) {
                          setStateCallback.call();
                        });
                        break;
                      case 1:
                        updateCommentRating(commentId, 'dislike', client)
                            .then((_) {
                          setStateCallback.call();
                        });
                        break;
                      case 2:
                        deleteCommentRating(commentId, client).then((_) {
                          setStateCallback.call();
                        });
                        break;
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
