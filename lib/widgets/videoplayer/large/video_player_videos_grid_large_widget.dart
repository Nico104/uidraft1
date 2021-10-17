import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/widgets/videoplayer/large/video_player_video_preview_large_widget.dart';

class VideoPlayerVideosLargeScreen extends StatelessWidget {
  const VideoPlayerVideosLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: 400,
        alignment: Alignment.topCenter,
        child: const VideoPlayerVideos());
  }
}

class VideoPlayerVideos extends StatefulWidget {
  const VideoPlayerVideos({Key? key}) : super(key: key);

  @override
  _VideoPlayerVideosState createState() => _VideoPlayerVideosState();
}

class _VideoPlayerVideosState extends State<VideoPlayerVideos> {
  bool _loading = true;

  List<int> postIds = <int>[];
  List<int> dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  late ScrollController _scrollController;

  //Get PostIds List
  Future<void> fetchPostIds() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/post/getPostIds'));

      if (response.statusCode == 200) {
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

    fetchPostIds().then((value) {
      ////LOADING FIRST  DATA
      addItemIntoLisT(1);
    });

    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: GridView.count(
              shrinkWrap: true,
              childAspectRatio: (600 / 180),
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 1,
              // Generate 100 widgets that display their index in the List.
              mainAxisSpacing: 25.0,
              // crossAxisSpacing: 40.0,
              children: dataList.map((value) {
                print("In Preview");
                return VideoPlayerVideoPreview(
                  postId: value,
                );
                // return (Text(value.toString()));
              }).toList(),
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
