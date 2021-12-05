import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_large_widget.dart';
import 'package:uidraft1/utils/videopreview/videopreview_utils_methods.dart'
    as vputils;
import 'dart:html' as html;

// class FeedGridLargeScreen extends StatelessWidget {
//   const FeedGridLargeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Align(alignment: Alignment.topCenter, child: FeedGrid());
//   }
// }

class FeedGrid extends StatefulWidget {
  FeedGrid({Key? key}) : super(key: key ?? feedGridKey);

  static final GlobalKey<_FeedGridState> feedGridKey =
      GlobalKey<_FeedGridState>();

  @override
  _FeedGridState createState() => _FeedGridState();
}

class _FeedGridState extends State<FeedGrid> {
  bool _loading = true;
  bool _error = false;

  List<int> postIds = <int>[];

  List<int> dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  // int pageCount = 0;
  late ScrollController _scrollController;

  //Get PostIds List
  Future<void> fetchPostIds() async {
    try {
      if (!_loading) {
        setState(() {
          _loading = true;
        });
      }

      final response =
          await http.get(Uri.parse('http://localhost:3000/post/getPostIds'));
      //TODO fill for non logged in users
      // final response = await http.get(Uri.parse(
      //     'http://localhost:3000/brainberry/contentGrabbingTest/username'));

      if (response.statusCode == 200) {
        //List<int> _postIds = <int>[];
        // If the call to the server was successful, parse the JSON
        List<dynamic> values = <dynamic>[];
        values = json.decode(response.body);
        if (values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              postIds.add(map['postId']);
              print('Id-------${map['postId']}');
            }
            // postIds.add(values[i]);
          }
        }

        print(postIds);
        setState(() {
          _loading = false;
        });
        //return postIds;
      } else {
        // If that call was not successful, throw an error.
        // Beamer.of(context).beamToNamed("/error/feed");

        //mounted to not call SetState after dispose()
        if (mounted) {
          setState(() {
            _loading = false;
            _error = true;
          });
          throw Exception('Failed to load post');
        }
      }
    } catch (e) {
      //mounted to not call SetState after dispose()
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
        // throw Exception("Error: " + e.toString());
        print("Error: " + e.toString());
        // Beamer.of(context).beamToNamed("/error/feed");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // try {
    fetchPostIds().then((value) {
      addItemIntoLisT(1);
    });

    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    //print(postIds);

    //RightClicktest
    // Prevent default event handler
    html.document.onContextMenu.listen((event) => event.preventDefault());
    //RightClicktest
  }

  void reload() {
    _scrollController.removeListener(_scrollListener);
    _scrollController
        .animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn)
        .then((value) {
      setState(() {
        postIds.clear();
        dataList.clear();
        pageCount = 1;
      });

      fetchPostIds().then((value) {
        addItemIntoLisT(1);
      });
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _error
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("There was an error while loading your Feed"),
                  OutlinedButton(
                      onPressed: () =>
                          fetchPostIds().then((value) => setState(() {})),
                      child: const Text("Reload Feed"))
                ],
              )
            : ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  // physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 120,
                      ),
                      Row(
                        children: [
                          Flexible(flex: 1, child: Container()),
                          Flexible(
                            flex: 4,
                            child: FutureBuilder(
                                future: isAuthenticated(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    //return ListView.builder(
                                    //   shrinkWrap: true,
                                    //   // physics: const NeverScrollableScrollPhysics(),
                                    //   // physics: const ClampingScrollPhysics(),
                                    //   itemCount: commentModels.length,
                                    //   itemBuilder: (context, i) {
                                    //     return commentModels.elementAt(i);
                                    //   },
                                    // );
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: dataList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width >=
                                                    1700
                                                ? (1280 / 1174)
                                                : (1280 / 1240),
                                        mainAxisSpacing: 20.0,
                                        crossAxisSpacing: 60.0,
                                      ),
                                      itemBuilder: (_, index) {
                                        return VideoPreview(
                                          postId: dataList.elementAt(index),
                                          isAuth: snapshot.data == 200,
                                          videoPreviewMode:
                                              vputils.VideoPreviewMode.feed,
                                        );
                                      },
                                    );
                                    // return GridView.count(
                                    //   // physics: const AlwaysScrollableScrollPhysics(),
                                    //   shrinkWrap: true,
                                    //   childAspectRatio:
                                    //       MediaQuery.of(context).size.width >=
                                    //               1700
                                    //           ? (1280 / 1174)
                                    //           : (1280 / 1240),
                                    //   // controller: _scrollController,
                                    //   scrollDirection: Axis.vertical,
                                    //   crossAxisCount: 3,
                                    //   mainAxisSpacing: 10.0,
                                    //   crossAxisSpacing: 40.0,
                                    //   children: dataList.map((value) {
                                    //     return VideoPreview(
                                    //       postId: value,
                                    //       isAuth: snapshot.data == 200,
                                    //       videoPreviewMode:
                                    //           vputils.VideoPreviewMode.feed,
                                    //     );
                                    //   }).toList(),
                                    // );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ),
                          Flexible(flex: 1, child: Container()),
                        ],
                      ),
                      // ),
                    ],
                  ),
                ),
              );
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    print("Offset: " + _scrollController.offset.toString());
    print("MaxScrollExtent: " +
        _scrollController.position.maxScrollExtent.toString());
    print("outOfRange: " + (!_scrollController.position.outOfRange).toString());

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");

          pageCount = pageCount + 1;

          addItemIntoLisT(pageCount);
        }
      });
    }
  }

  ////ADDING DATA INTO ARRAYLIST
  void addItemIntoLisT(var pageCount) {
    print("addItemIntoLisT");
    int itemsLoading = 12;
    for (int i = (pageCount * itemsLoading) - itemsLoading;
        i < pageCount * itemsLoading;
        i++) {
      if (postIds.length > i) {
        dataList.add(postIds[i]);
      }
      // dataList.add(postIds[i]);
      // print(i);
      // try {
      //   dataList.add(postIds[i]);
      // } catch (error) {
      //   print('run out of Ids master');
      // }
      isLoading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
