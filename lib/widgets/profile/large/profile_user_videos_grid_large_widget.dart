import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/network/http_client.dart';

import 'profile_video_preview_large_widget.dart';
import 'dart:html' as html;

class ProfileUserVideosLargeScreen extends StatelessWidget {
  const ProfileUserVideosLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: 400,
        alignment: Alignment.topCenter,
        child: const ProfileUserVideos());
  }
}

class ProfileUserVideos extends StatefulWidget {
  const ProfileUserVideos({Key? key}) : super(key: key);

  @override
  _ProfileUserVideosState createState() => _ProfileUserVideosState();
}

class _ProfileUserVideosState extends State<ProfileUserVideos> {
  bool _loading = true;
  bool _error = false;

  List<int> postIds = <int>[];
  List<int> dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  late ScrollController _scrollController;

  //Get PostIds List
  Future<void> fetchPostIds() async {
    print("button tapped");
    try {
      if (!_loading) {
        setState(() {
          _loading = true;
        });
      }

      http.Client client =
          Provider.of<ConnectionService>(context, listen: false)
              .returnConnection();

      final response = await client.get(Uri.parse(baseURL + 'post/getPostIds'));

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

    fetchPostIds().then((value) {
      ////LOADING FIRST  DATA
      addItemIntoLisT(1);
    });

    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);

    //RightClicktest
    // Prevent default event handler
    html.document.onContextMenu.listen((event) => event.preventDefault());
    //RightClicktest
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return _loading
          ? Column(
              children: const [
                SizedBox(
                  height: 150,
                ),
                CircularProgressIndicator(),
              ],
            )
          : _error
              ? Column(
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    const Text(
                        "There was an error while loading this Users Video"),
                    OutlinedButton(
                        onPressed: () => fetchPostIds(),
                        child: const Text("Reload Videos"))
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(160, 100, 160, 0),
                  child: FutureBuilder(
                      future: isAuthenticated(connection.returnConnection()),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData) {
                          return GridView.count(
                            shrinkWrap: true,
                            childAspectRatio: (1280 / 1174),
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            crossAxisCount: 2,
                            // Generate 100 widgets that display their index in the List.
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 40.0,
                            children: dataList.map((value) {
                              print("In Preview");
                              return Listener(
                                child: ProfileVideoPreview(
                                  postId: value,
                                  isAuth: snapshot.data == 200,
                                ),
                                // onPointerDown: (ev) =>
                                //     vputils.onPointerDown(context, ev, value),
                              );
                              // return (Text(value.toString()));
                            }).toList(),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                );
    });
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
    int itemsLoading = 6;
    for (int i = (pageCount * itemsLoading) - itemsLoading;
        i < pageCount * itemsLoading;
        i++) {
      if (postIds.length > i) {
        dataList.add(postIds[i]);
      }
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
