import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/widgets/feed/videoPreview/video_preview_large_widget.dart';

class FeedGridLargeScreen extends StatelessWidget {
  const FeedGridLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
        alignment: Alignment.topCenter,
        // child: Padding(
        //   padding: EdgeInsets.fromLTRB(150, 10, 150, 0),
        //   child: FeedGrid(),
        // )),
        child: FeedGrid());
  }
}

class FeedGrid extends StatefulWidget {
  const FeedGrid({Key? key}) : super(key: key);

  @override
  _FeedGridState createState() => _FeedGridState();
}

class _FeedGridState extends State<FeedGrid> {
  bool _loading = true;
  bool _error = false;

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
      if(!_loading){
        setState(() {
          _loading = true;
        });
      }


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
        // Beamer.of(context).beamToNamed("/error/feed");
        setState(() {
          _loading = false;
          _error = true;
        });
        throw Exception('Failed to load post');
      }
    } catch (e) {
      setState(() {
          _loading = false;
          _error = true;
        });
        // throw Exception("Error: " + e.toString());
        print("Error: " + e.toString());
      // Beamer.of(context).beamToNamed("/error/feed");
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
        ? const Center(child: CircularProgressIndicator())
        : _error ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("There was an error while loading your Feed"),
              OutlinedButton(onPressed: () => fetchPostIds(), child: const Text("Reload Feed"))
            ],
          ) :
        ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).size.width <= 1500
                    ? const EdgeInsets.fromLTRB(160, 100, 160, 0)
                    : const EdgeInsets.fromLTRB(310, 120, 310, 0),
                child: GridView.count(
                  shrinkWrap: true,
                  // childAspectRatio: MediaQuery.of(context).size.width >= 1700
                  //     ? (1280 / 1174)
                  //     : MediaQuery.of(context).size.width >= 1600
                  //         ? (1280 / 1240)
                  //         : MediaQuery.of(context).size.width >= 1300
                  //             ? (1280 / 1240)
                  //             : (1280 / 1240),
                  childAspectRatio: MediaQuery.of(context).size.width >= 1700
                      ? (1280 / 1174)
                      : (1280 / 1240),
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 3,
                  // Generate 100 widgets that display their index in the List.
                  mainAxisSpacing: 10.0,
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
