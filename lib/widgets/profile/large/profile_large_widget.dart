import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'profile_video_preview_large_widget.dart';
import 'package:uidraft1/utils/videopreview/videopreview_utils_methods.dart'
    as vputils;
import 'dart:html' as html;

class ProfileLargeScreen extends StatelessWidget {
  const ProfileLargeScreen({Key? key, required this.profileData})
      : super(key: key);

  final Map<String, dynamic> profileData;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Profile(
          profileData: profileData,
        ));
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.profileData}) : super(key: key);

  final Map<String, dynamic> profileData;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Profil
  bool _isFollowing = false;

  String baseURL = 'http://localhost:3000/';

  //Grid Vars
  bool _loading = true;
  bool _error = false;

  List<int> postIds = <int>[];
  List<int> dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  late ScrollController _scrollController;

  //Get User PostIds List
  Future<void> fetchUserPostIds(String username) async {
    try {
      if (!_loading) {
        setState(() {
          _loading = true;
        });
      }
      final response = await http.get(Uri.parse(
          'http://localhost:3000/post/getUserByUsernamePostIds/$username'));
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

    fetchUserPostIds(widget.profileData['username']).then((value) {
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

  //Profile
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile Information
            Column(
              children: [
                //Profile Picture
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(37),
                          bottomRight: Radius.circular(37)),
                      child: Image.network(
                        baseURL + widget.profileData['profilePicturePath'],
                        fit: BoxFit.contain,
                        width: 600,
                        height: 600,
                      ),
                    ),
                    //Update Profile Function
                    FutureBuilder(
                        future: isThisMe(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          print("FutureBuilde Debug 1");
                          if (snapshot.hasData) {
                            print("FutureBuilde Debug 2");
                            if (snapshot.data!) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16, right: 8),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueAccent.shade100,
                                    shape: const CircleBorder(),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onPressed: () => Beamer.of(context)
                                      .beamToNamed("/updateprofile"),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            print("FutureBuilde Debug 3r");
                            return const SizedBox();
                          }
                        })
                  ],
                ),
                const SizedBox(
                  height: 37,
                ),
                //Profile Data
                SizedBox(
                  width: 600,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: FutureBuilder(
                        future: isThisMe(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshotMe) {
                          if (snapshotMe.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Username
                                    Text(
                                      widget.profileData['username'],
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 26,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .brandColor),
                                    ),
                                    //Follow Button
                                    !snapshotMe.data!
                                        ? SizedBox(
                                            width: 160,
                                            height: 35,
                                            child: (!_isFollowing)
                                                ? TextButton(
                                                    style: TextButton.styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .brandColor),
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Follow',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Segoe UI Black',
                                                          fontSize: 18,
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor),
                                                    ),
                                                  )
                                                : OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      side: BorderSide(
                                                          width: 2,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .brandColor),
                                                    ),
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Followed',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Segoe UI',
                                                          fontSize: 18,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .brandColor),
                                                    ),
                                                  ))
                                        : const SizedBox()
                                  ],
                                ),
                                //Message
                                const SizedBox(height: 10),
                                !snapshotMe.data!
                                    ? SizedBox(
                                        // width: 260,
                                        height: 35,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .brandColor),
                                          onPressed: () {},
                                          child: Text(
                                            'Message ' +
                                                widget.profileData['username'],
                                            style: TextStyle(
                                                fontFamily: 'Segoe UI Black',
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ))
                                    : const SizedBox(),

                                const SizedBox(height: 13),
                                //Userpoints
                                Text(
                                  widget.profileData['profilePoints']
                                          .toString() +
                                      ' points',
                                  style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .brandColor),
                                ),
                                const SizedBox(height: 34),
                                //User Bio
                                Text(
                                  widget.profileData['profileBio'],
                                  style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .userBioColor),
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  ),
                )
              ],
            ),
            //Video Grid
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 100, right: 100),
                    // child: ProfileUserVideosLargeScreen(),
                    child: _loading
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
                                      onPressed: () => fetchUserPostIds(
                                          widget.profileData['username']),
                                      child: const Text("Reload Videos"))
                                ],
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(160, 100, 160, 0),
                                child: FutureBuilder(
                                    future: isAuthenticated(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (snapshot.hasData) {
                                        return GridView.count(
                                          shrinkWrap: true,
                                          childAspectRatio: (1280 / 1174),
                                          // controller: _scrollController,
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
                                              onPointerDown: (ev) =>
                                                  vputils.onPointerDown(
                                                      context, ev, value),
                                            );
                                            // return (Text(value.toString()));
                                          }).toList(),
                                        );
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                              ))),
          ],
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

  ////ADDING DATA INTO ARRAYLIST
  ///
  Future<bool> isThisMe() async {
    if (await isAuthenticated() == 200) {
      if (await getMyUsername() == widget.profileData['username']) {
        print("This is me");
        return true;
      } else {
        print("This is not me");
        return false;
      }
    } else {
      print("You are not even signed in");
      return false;
    }
  }
}






























































// import 'package:beamer/beamer.dart';
// import 'package:flutter/material.dart';
// import 'package:uidraft1/utils/auth/authentication_global.dart';
// import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

// import 'profile_user_videos_grid_large_widget.dart';

// class ProfileLargeScreen extends StatelessWidget {
//   const ProfileLargeScreen({Key? key, required this.profileData})
//       : super(key: key);

//   final Map<String, dynamic> profileData;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//         alignment: Alignment.topCenter,
//         child: Profile(
//           profileData: profileData,
//         ));
//   }
// }

// class Profile extends StatefulWidget {
//   const Profile({Key? key, required this.profileData}) : super(key: key);

//   final Map<String, dynamic> profileData;

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   //Profil
//   bool _isFollowing = false;

//   String baseURL = 'http://localhost:3000/';

//   //Profile
//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//       behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//       child: SingleChildScrollView(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //Profile Information
//             Column(
//               children: [
//                 //Profile Picture
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(37),
//                           bottomRight: Radius.circular(37)),
//                       child: Image.network(
//                         baseURL + widget.profileData['profilePicturePath'],
//                         fit: BoxFit.contain,
//                         width: 600,
//                         height: 600,
//                       ),
//                     ),
//                     FutureBuilder(
//                         future: isAuthenticated(),
//                         builder:
//                             (BuildContext context, AsyncSnapshot snapshot) {
//                           if (snapshot.data == 200) {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.only(bottom: 16, right: 16),
//                               child: IconButton(
//                                   hoverColor: Colors.transparent,
//                                   onPressed: () {
//                                     Beamer.of(context)
//                                         .beamToNamed("/updateprofile");
//                                   },
//                                   icon: Icon(
//                                     Icons.edit,
//                                     size: 28,
//                                     color: Theme.of(context).canvasColor,
//                                   )),
//                             );
//                           } else {
//                             return const SizedBox();
//                           }
//                         })
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 37,
//                 ),
//                 //Profile Data
//                 SizedBox(
//                   width: 600,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 25),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             //Username
//                             Text(
//                               widget.profileData['username'],
//                               style: TextStyle(
//                                   fontFamily: 'Segoe UI',
//                                   fontSize: 26,
//                                   color:
//                                       Theme.of(context).colorScheme.brandColor),
//                             ),
//                             //Follow Button
//                             SizedBox(
//                                 width: 160,
//                                 height: 35,
//                                 child: (!_isFollowing)
//                                     ? TextButton(
//                                         style: TextButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(30.0),
//                                             ),
//                                             backgroundColor: Theme.of(context)
//                                                 .colorScheme
//                                                 .brandColor),
//                                         onPressed: () {},
//                                         child: Text(
//                                           'Follow',
//                                           style: TextStyle(
//                                               fontFamily: 'Segoe UI Black',
//                                               fontSize: 18,
//                                               color: Theme.of(context)
//                                                   .canvasColor),
//                                         ),
//                                       )
//                                     : OutlinedButton(
//                                         style: OutlinedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(30.0),
//                                           ),
//                                           side: BorderSide(
//                                               width: 2,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .brandColor),
//                                         ),
//                                         onPressed: () {},
//                                         child: Text(
//                                           'Followed',
//                                           style: TextStyle(
//                                               fontFamily: 'Segoe UI',
//                                               fontSize: 18,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .brandColor),
//                                         ),
//                                       )),
//                           ],
//                         ),
//                         const SizedBox(height: 13),
//                         //Userpoints
//                         Text(
//                           widget.profileData['profilePoints'].toString() +
//                               ' points',
//                           style: TextStyle(
//                               fontFamily: 'Segoe UI',
//                               fontSize: 16,
//                               color: Theme.of(context).colorScheme.brandColor),
//                         ),
//                         const SizedBox(height: 34),
//                         //User Bio
//                         Text(
//                           widget.profileData['profileBio'],
//                           style: TextStyle(
//                               fontFamily: 'Segoe UI',
//                               fontSize: 16,
//                               color:
//                                   Theme.of(context).colorScheme.userBioColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const Expanded(
//                 child: Padding(
//               padding: EdgeInsets.only(left: 100, right: 100),
//               child: ProfileUserVideosLargeScreen(),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }
