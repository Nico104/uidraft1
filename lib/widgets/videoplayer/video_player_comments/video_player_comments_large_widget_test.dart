//Comment Widget

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uidraft1/utils/comment/comment_post_util_methods.dart';
import 'package:uidraft1/widgets/comment/comment_model_widget.dart';

class VideoPlayerCommentsTest extends StatefulWidget {
  VideoPlayerCommentsTest({
    Key? key,
    // required this.postId,
    required this.commentIds,
  }) : super(key: videoPlacerCommentsKey);

  // final int postId;
  final List<int> commentIds;

  static final GlobalKey<_VideoPlayerCommentsTestState> videoPlacerCommentsKey =
      GlobalKey<_VideoPlayerCommentsTestState>();

  @override
  State<VideoPlayerCommentsTest> createState() =>
      _VideoPlayerCommentsTestState();
}

class _VideoPlayerCommentsTestState extends State<VideoPlayerCommentsTest> {
  static const _pageSize = 10;
  int _pageKey = 0;

  List<CommentModel> commentModels = <CommentModel>[];

  @override
  void initState() {
    commentModels
        .addAll(getNewComments(_pageKey, _pageSize, widget.commentIds));
    super.initState();
  }

  void appendCommentModels() {
    print("Ah sheesh here we go appending comments again");
    commentModels
        .addAll(getNewComments(_pageKey, _pageSize, widget.commentIds));
    setState(() {
      _pageKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: commentModels,
    // );
    return ListView.builder(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      // physics: const ClampingScrollPhysics(),
      itemCount: commentModels.length,
      itemBuilder: (context, i) {
        return commentModels.elementAt(i);
      },
    );
  }
}

List<CommentModel> getNewComments(
    int pageKey, int _pageSize, List<int> commentIds) {
  final int currentIndex = pageKey * _pageSize;
  List<CommentModel> commentList = <CommentModel>[];
  for (int i = currentIndex; i < currentIndex + _pageSize; i++) {
    commentList.add(CommentModel(commentId: commentIds.elementAt(i)));
  }
  return commentList;
}
