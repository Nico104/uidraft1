import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/widgets/feed/videoPreview/video_preview_widget.dart';

class FeedGridLargeScreen extends StatelessWidget {
  const FeedGridLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Align(
          alignment: Alignment.topCenter,
          // child: Padding(
          //   padding: EdgeInsets.fromLTRB(150, 10, 150, 0),
          //   child: FeedGrid(),
          // )),
          child: FeedGrid()),
    );
  }
}

class FeedGrid extends StatefulWidget {
  const FeedGrid({Key? key}) : super(key: key);

  @override
  _FeedGridState createState() => _FeedGridState();
}

class _FeedGridState extends State<FeedGrid> {
  bool _loading = true;

  List<int> postIds = <int>[];

  //https://picsum.photos/1280/720
  List<int> dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  //int pageCount = 0;
  late ScrollController _scrollController;

  //Get PostIds List
  Future<void> fetchPostIds() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/post/getPostIds'));

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
          }
        }
        print(postIds);
        setState(() {
          _loading = false;
        });
        //return postIds;
      } else {
        // If that call was not successful, throw an error.
        Beamer.of(context).beamToNamed("/error/feed");
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print("Error: " + e.toString());
      Beamer.of(context).beamToNamed("/error/feed");
    }
  }

  @override
  void initState() {
    super.initState();

    // try {
    fetchPostIds().then((value) {
      ////LOADING FIRST  DATA
      addItemIntoLisT(1);
    });
    // } catch (e) {
    //   print("Error: " + e.toString());
    //   Beamer.of(context).beamToNamed("/error/feed");
    // }

    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    //print(postIds);
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(
            color: Theme.of(context).canvasColor,
            child: const Center(child: CircularProgressIndicator()))
        : ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Padding(
                  padding: MediaQuery.of(context).size.width <= 1500
                      ? const EdgeInsets.fromLTRB(160, 40, 160, 0)
                      : const EdgeInsets.fromLTRB(310, 60, 310, 0),
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: (1280 / 1020),
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 3,
                    // Generate 100 widgets that display their index in the List.
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 40.0,
                    children: dataList.map((value) {
                      print("In Preview");
                      return VideoPreview(
                        postId: value,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
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
    print("test");
    for (int i = (pageCount * 10) - 10; i < pageCount * 10; i++) {
      if (postIds.length > i) {
        dataList.add(postIds[i]);
      }
      print(i);
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
