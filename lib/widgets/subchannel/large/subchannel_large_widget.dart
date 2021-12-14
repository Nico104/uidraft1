import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/subchannel/subchannel_util_methods.dart';
import 'package:uidraft1/utils/widgets/videopreview/video_preview_large_widget.dart';
import 'package:uidraft1/widgets/subchannel/large/subchannel_video_preview_large_widget.dart';

import 'subchannel_videos_grid_large_widget.dart';

import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/videopreview/videopreview_utils_methods.dart'
    as vputils;
import 'dart:html' as html;

class SubchannelLargeScreen extends StatelessWidget {
  const SubchannelLargeScreen({Key? key, required this.subchannelData})
      : super(key: key);

  final Map<String, dynamic> subchannelData;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Subchannel(
          subchannelData: subchannelData,
        ));
  }
}

class Subchannel extends StatefulWidget {
  const Subchannel({Key? key, required this.subchannelData}) : super(key: key);

  final Map<String, dynamic> subchannelData;

  @override
  _SubchannelState createState() => _SubchannelState();
}

class _SubchannelState extends State<Subchannel> {
  //About Text
  bool _showAboutText = false;

  //Profil
  bool _isFollowing = false;

  //Grid Vars
  bool _loading = true;

  List<int> postIds = <int>[];
  List<int> dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  late ScrollController _scrollController;

  //Get PostIds List
  Future<void> fetchSubchannelPostIds(String subchannelname) async {
    try {
      final response = await http.get(
          Uri.parse(baseURL + 'post/getSubchannelPostIds/$subchannelname'));

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

    fetchSubchannelPostIds(widget.subchannelData['subchannelName'])
        .then((value) {
      ////LOADING FIRST  DATA
      addItemIntoLisT(1);
    });

    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);

    html.document.onContextMenu.listen((event) => event.preventDefault());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  //Grid Vars

  //Subchannel
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Consumer<ConnectionService>(builder: (context, connection, _) {
        return Stack(
          children: [
            //Subchannel Banner
            Padding(
              // padding: const EdgeInsets.only(left: 15, right: 15),
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                // borderRadius: const BorderRadius.only(
                //     bottomLeft: Radius.circular(40),
                //     bottomRight: Radius.circular(40)),
                child: Image.network(
                  baseURL +
                      widget.subchannelData['subchannelPreview']
                          ['subchannelBannerPath'],
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 230,
                ),
              ),
            ),
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 180,
                  ),
                  //SubchannelPicture
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    child: Image.network(
                      baseURL +
                          widget.subchannelData['subchannelPreview']
                              ['subchannelSubchannelPicturePath'],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: 87,
                      height: 87,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "c/" + widget.subchannelData['subchannelName'],
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.navBarIconColor),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //Short Description
                  SizedBox(
                    width: 400,
                    child: Text(
                      widget.subchannelData['subchannelPreview']
                          ['subchannelShortDescriptiveText'],
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.navBarIconColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //Follower
                  Text(
                    "1432 Followers",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.navBarIconColor),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  StatefulBuilder(builder:
                      (BuildContext context, StateSetter setStateButtonBar) {
                    return FutureBuilder(
                        future: Future.wait([
                          isMember(widget.subchannelData['subchannelName']),
                          isMod(widget.subchannelData['subchannelName'])
                        ]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<bool>> snapshotIsMember) {
                          if (snapshotIsMember.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 35,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      side: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .brandColor),
                                    ),
                                    onPressed: () => setState(() {
                                      print("About pressed");
                                      _showAboutText = !_showAboutText;
                                    }),
                                    child: Text(
                                      'About',
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .brandColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                    width: 160,
                                    height: 35,
                                    child: (snapshotIsMember.data![1])
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .brandColor),
                                            ),
                                            onPressed: () {
                                              Beamer.of(context).beamToNamed(
                                                  '/submod/${widget.subchannelData['subchannelName']}');
                                            },
                                            child: Text(
                                              'ModMenu',
                                              style: TextStyle(
                                                  fontFamily: 'Segoe UI',
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .brandColor),
                                            ),
                                          )
                                        : (!snapshotIsMember.data![0])
                                            ? TextButton(
                                                style: TextButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .brandColor),
                                                onPressed: () =>
                                                    enterSubchannel(widget
                                                                .subchannelData[
                                                            'subchannelName'])
                                                        .then((value) =>
                                                            setStateButtonBar(
                                                                () {})),
                                                child: Text(
                                                  'Follow',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Segoe UI Black',
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .canvasColor),
                                                ),
                                              )
                                            : OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .brandColor),
                                                ),
                                                onPressed: () =>
                                                    leaveSubchannel(widget
                                                                .subchannelData[
                                                            'subchannelName'])
                                                        .then((value) =>
                                                            setStateButtonBar(
                                                                () {})),
                                                child: Text(
                                                  'Followed',
                                                  style: TextStyle(
                                                      fontFamily: 'Segoe UI',
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .brandColor),
                                                ),
                                              )),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        });
                  }),
                  const SizedBox(
                    height: 40,
                  ),
                  // SubchannelVideosGrid Or SubchannelAboutText,
                  _showAboutText
                      //About Text
                      ? Container(
                          width: 1000,
                          alignment: Alignment.topCenter,
                          child: Text(
                              widget.subchannelData['subchannelAboutText']),
                        )
                      //Videos Grid
                      : Container(
                          width: 1500,
                          alignment: Alignment.topCenter,
                          child: _loading
                              ? const Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      160, 100, 160, 0),
                                  child: FutureBuilder(
                                      future: isAuthenticated(
                                          connection.returnConnection()),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return GridView.count(
                                            // physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            childAspectRatio: (1280 / 1174),
                                            // controller: _scrollController,
                                            scrollDirection: Axis.vertical,
                                            // Create a grid with 2 columns. If you change the scrollDirection to
                                            // horizontal, this produces 2 rows.
                                            crossAxisCount: 3,
                                            // Generate 100 widgets that display their index in the List.
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 40.0,
                                            children: dataList.map((value) {
                                              print("In Preview");
                                              // return SubchannelVideoPreview(
                                              //   postId: value,
                                              //   isAuth: snapshot.data == 200,
                                              // );
                                              return VideoPreview(
                                                postId: value,
                                                isAuth: snapshot.data == 200,
                                                videoPreviewMode: vputils
                                                    .VideoPreviewMode
                                                    .subchannel,
                                              );
                                            }).toList(),
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      }),
                                ))
                ],
              ),
            ),
          ],
        );
      }),
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
}





















































// import 'package:flutter/material.dart';
// import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

// import 'subchannel_videos_grid_large_widget.dart';

// class SubchannelLargeScreen extends StatelessWidget {
//   const SubchannelLargeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Align(alignment: Alignment.topCenter, child: Subchannel());
//   }
// }

// class Subchannel extends StatefulWidget {
//   const Subchannel({Key? key}) : super(key: key);

//   @override
//   _SubchannelState createState() => _SubchannelState();
// }

// class _SubchannelState extends State<Subchannel> {
//   //Profil
//   bool _isFollowing = false;

//   //Subchannel
//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//       behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//       child: Stack(
//         children: [
//           //Subchannel Banner
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(40),
//                 bottomRight: Radius.circular(40)),
//             child: Image.network(
//               "https://picsum.photos/1920/230",
//               fit: BoxFit.fill,
//               width: MediaQuery.of(context).size.width,
//               height: 230,
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               //mainAxisAlignment: MainAxisAlignment.center,
//               //crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 180,
//                 ),
//                 ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(14)),
//                   child: Image.network(
//                     "https://picsum.photos/700",
//                     fit: BoxFit.contain,
//                     width: 87,
//                     height: 87,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Text(
//                   "c/CoolSamuraiStuff",
//                   style: TextStyle(
//                       fontFamily: 'Segoe UI',
//                       fontSize: 30,
//                       color: Theme.of(context).colorScheme.navBarIconColor),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     //Subchannelname
//                     Text(
//                       "1432 followers",
//                       style: TextStyle(
//                           fontFamily: 'Segoe UI',
//                           fontSize: 18,
//                           color: Theme.of(context).colorScheme.navBarIconColor),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     //Dot in the middle
//                     Container(
//                       width: 6,
//                       height: 6,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Theme.of(context).colorScheme.navBarIconColor,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     //Views
//                     Text(
//                       "420 online",
//                       style: TextStyle(
//                           fontFamily: 'Segoe UI',
//                           fontSize: 18,
//                           color: Theme.of(context).colorScheme.navBarIconColor),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 17,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 160,
//                       height: 35,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                           ),
//                           side: BorderSide(
//                               width: 2,
//                               color: Theme.of(context).colorScheme.brandColor),
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'About',
//                           style: TextStyle(
//                               fontFamily: 'Segoe UI',
//                               fontSize: 18,
//                               color: Theme.of(context).colorScheme.brandColor),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     SizedBox(
//                         width: 160,
//                         height: 35,
//                         child: (!_isFollowing)
//                             ? TextButton(
//                                 style: TextButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30.0),
//                                     ),
//                                     backgroundColor: Theme.of(context)
//                                         .colorScheme
//                                         .brandColor),
//                                 onPressed: () {},
//                                 child: Text(
//                                   'Follow',
//                                   style: TextStyle(
//                                       fontFamily: 'Segoe UI Black',
//                                       fontSize: 18,
//                                       color: Theme.of(context).canvasColor),
//                                 ),
//                               )
//                             : OutlinedButton(
//                                 style: OutlinedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                   ),
//                                   side: BorderSide(
//                                       width: 2,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .brandColor),
//                                 ),
//                                 onPressed: () {},
//                                 child: Text(
//                                   'Followed',
//                                   style: TextStyle(
//                                       fontFamily: 'Segoe UI',
//                                       fontSize: 18,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .brandColor),
//                                 ),
//                               )),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 SubchannelVideosGridLargeScreen(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
