import 'package:provider/provider.dart';
import 'package:uidraft1/utils/comment/comment_util_methods.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/network/http_client.dart';

class SubModMemberCommentModel extends StatelessWidget {
  const SubModMemberCommentModel({Key? key, required this.commentId})
      : super(key: key);

  final int commentId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future: fetchCommentData(commentId, connection.returnConnection()),
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
              // print("Subcomments: " + subCommentIds.toString());
              //Comment
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image.network(
                      // baseURL +
                      spacesEndpoint +
                          snapshot.data!['commentUser']['userProfile']
                              ['profilePicturePath'],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
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
                        Text(snapshot.data!['commentText']),
                        const SizedBox(
                          height: 5,
                        ),
                        FutureBuilder(
                            future: Future.wait([
                              getUserCommentRating(
                                  commentId, connection.returnConnection()),
                              getCommentRatingScore(
                                  commentId, connection.returnConnection())
                            ]),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<int>> snapshotRating) {
                              if (snapshotRating.hasData) {
                                return Text(
                                    "Rating: " +
                                        snapshotRating.data![1].toString(),
                                    style:
                                        const TextStyle(color: Colors.white38));
                              } else {
                                return const Text(
                                  "has no rating",
                                  style: TextStyle(color: Colors.white38),
                                );
                              }
                            }),
                        const SizedBox(
                          height: 10,
                        ),
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
