//Comment Widget

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uidraft1/utils/comment/comment_post_util_methods.dart';
import 'package:uidraft1/widgets/comment/comment_model_widget.dart';

class VideoPlayerComments extends StatefulWidget {
  const VideoPlayerComments({
    Key? key,
    // required this.postId,
    required this.commentIds,
  }) : super(key: key);

  // final int postId;
  final List<int> commentIds;

  @override
  State<VideoPlayerComments> createState() => _VideoPlayerCommentsState();
}

class _VideoPlayerCommentsState extends State<VideoPlayerComments> {
  static const _pageSize = 10;

  final PagingController<int, CommentModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      print("Ah shit here we go fetch new Comments again");
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // final newItems = await RemoteApi.getCharacterList(pageKey, _pageSize);
      final newItems = getNewComments(pageKey, _pageSize, widget.commentIds);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, CommentModel>(
      primary: false,
      shrinkWrap: true,
      // physics: ScrollPhysics(),
      // physics: const ClampingScrollPhysics(),
      // physics: const NeverScrollableScrollPhysics(),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<CommentModel>(
        itemBuilder: (context, item, index) => item,
      ),
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
