import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/comment/comment_post_util_methods.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/util_methods.dart';
import 'package:uidraft1/utils/wordsearch/word_search_util_methods.dart';
import 'package:uidraft1/widgets/slider/slidertest.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_videos_grid_large_widget_test.dart';
import 'package:uidraft1/widgets/videoplayer/large/videoplayers/video_player_normal_v2_widget.dart';
import 'package:uidraft1/widgets/videoplayer/video_player_comments/video_player_comments_large_widget_test.dart';
import 'package:uidraft1/widgets/videoplayer/video_player_comments/video_player_write_comment_widget.dart';
import 'package:uidraft1/widgets/videoplayer/wordsearch/word_search_large_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:html';
import 'package:readmore/readmore.dart';
// import 'dart:html' as html;
import 'package:http/http.dart' as http;

void goFullScreen() {
  document.documentElement!.requestFullscreen();
}

void exitFullScreen() {
  print("exit fullscreen");
  document.exitFullscreen();
}

//Latest Player
class VideoPlayerHome extends StatefulWidget {
  const VideoPlayerHome(
      {Key? key,
      required this.postData,
      required this.firtTimeExternAccess,
      required this.navbar})
      : super(key: key);

  final Map<String, dynamic> postData;
  final bool firtTimeExternAccess;
  final Widget navbar;

  final String text =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n Tempus iaculis urna id volutpat lacus laoreet non. Aenean vel elit scelerisque mauris.\n Pharetra massa massa ultricies mi. Ut sem viverra aliquet eget sit amet.";

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerHome> {
  //Play Video vars
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  //Pause video in the beginning
  late bool _firtTimeExternAccess;

  //Menu vars
  bool _isFullScreen = false;
  bool _showMenu = false;

  //Description
  bool isExpanded = false;

  //Change Quality
  Map<int, String> streamQualityURL = {};
  List<int> streamQualityKeysSorted = [];
  late int activeQualityStream;

  Duration pos = const Duration();

  //Serverconnection
  String baseURL = 'http://localhost:3000/';

  //Shortcuts
  var focusNode = FocusNode();

  //Comment
  final TextEditingController _postCommentTextController =
      TextEditingController();

  //Tags
  List<String> taglist = <String>[];

  //SliderTest
  double sliderval = 50;

  //PressF
  // bool _pressFVisible = false;
  double _width = 0;
  double _height = 0;
  int _duration = 200;

  //SkipButton
  int? skipToId;

  late ScrollController _scrollController;
  late ScrollController _scrollController2;

  bool _showScrollToTopComment = false;
  bool _showScrollToTopVideoRecommandations = false;

  // GlobalKey<_VideoPlayerCommentsTestState> videoPlacerCommentsKey =
  //   GlobalKey<_VideoPlayerCommentsTestState>();

  FocusNode writeCommentFocusNode = FocusNode();

  void loadNewStuff() {
    if (VideoPlayerCommentsTest.videoPlacerCommentsKey2.currentState == null) {
      print("current NavBarState null");
    } else {
      VideoPlayerCommentsTest.videoPlacerCommentsKey2.currentState!
          .appendCommentModels();
    }
  }

  void loadNewStuff2() {
    if (VideoPlayerVideosLargeScreenTest
            .videoPlayerRecommendedKey.currentState ==
        null) {
      print("current NavBarState null");
    } else {
      VideoPlayerVideosLargeScreenTest.videoPlayerRecommendedKey.currentState!
          .appendRecommendedVideos();
    }
  }

  void setSkipToId(int id) {
    skipToId = id;
  }

  void skipToNextVideo() {
    if (skipToId != null) {
      Beamer.of(context).beamToNamed('whatchintern/' + skipToId.toString());
    } else {
      print("skipId is null");
    }
  }

  void seekToSecond(double second, bool ease) {
    if (ease) {
      double bufferTimeSeconds = 0.2;
      if (second - bufferTimeSeconds < 0) {
        second = 0;
      } else {
        second -= bufferTimeSeconds;
      }
      _controller.seekTo(Duration(milliseconds: (second * 1000).floor()));
      if (mounted) {
        setState(() {
          _firtTimeExternAccess = false;
        });
      }
      easeAudioOnSeeking(bufferTimeSeconds * 1000);
    } else {
      _controller.seekTo(Duration(milliseconds: (second * 1000).floor()));
    }
  }

  void easeAudioOnSeeking(double durationMilliSec) async {
    double minVolume;
    if (_controller.value.volume < 0.2) {
      minVolume = 0;
    } else {
      minVolume = 0.2;
    }
    int intervals = 10;
    double wait = durationMilliSec / intervals;
    double steps = (_controller.value.volume - minVolume) / intervals;
    _controller.setVolume(minVolume);
    for (int i = 0; i < intervals; i++) {
      await Future.delayed(Duration(milliseconds: wait.round()), () {
        _controller.setVolume(_controller.value.volume + steps);
        print("Volume set to " + (_controller.value.volume + steps).toString());
      });
    }
  }

  void _onFullScreenChange(ev) {
    print("onFullScreenChange!: $ev");
    // setState(() {
    //   _isFullScreen = !_isFullScreen;
    // });
  }

  void resize() {
    print("resize!!!!!!!!!!!!!!!!!!!!!!!!");
  }

  @override
  void initState() {
    print("Is Full  Screen: " + document.fullscreenEnabled.toString());

    //Tagstart
    List<dynamic> values = widget.postData['tags'];
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          taglist.add(map['tagName']);
        }
      }
    }
    //tagend

    _firtTimeExternAccess = widget.firtTimeExternAccess;

    streamQualityURL[240] = baseURL + widget.postData['postVideoPath240'];
    if (widget.postData['postVideoPath480'].toString().isNotEmpty) {
      streamQualityURL[480] = baseURL + widget.postData['postVideoPath480'];
      print("PAth 480: " + streamQualityURL[480]!);
    }
    if (widget.postData['postVideoPath720'].toString().isNotEmpty) {
      streamQualityURL[720] = baseURL + widget.postData['postVideoPath720'];
      print("PAth 720: " + streamQualityURL[720]!);
    }
    if (widget.postData['postVideoPath1080'].toString().isNotEmpty) {
      streamQualityURL[1080] = baseURL + widget.postData['postVideoPath1080'];
      print("PAth 1080: " + streamQualityURL[1080]!);
    }

    streamQualityKeysSorted = streamQualityURL.keys.toList()
      ..sort((b, a) => a.compareTo(b));

    activeQualityStream = streamQualityKeysSorted.first;

    _controller =
        VideoPlayerController.network(streamQualityURL[activeQualityStream]!);

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            pos = _controller.value.position;
          });
        }
      });

      if (!_firtTimeExternAccess) {
        _controller.play();
      }
    });

    // Use the controller to loop the video.
    _controller.setLooping(true);

    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    _scrollController2 = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener2);

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!widget.firtTimeExternAccess) {
        window.history.replaceState(null, 'VideoPlayer',
            '#/whatch/' + widget.postData['postId'].toString());
      }
    });
  }

  //Needs Scaffold in Tree to work
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('copied to clipboard'),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    writeCommentFocusNode.dispose();
    print("DISPOSE");
    createWhatchtimeAnalyticPost(
        widget.postData['postId'], _controller.value.position.inSeconds);
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  int millisecondsBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.second,
        from.millisecond);
    to =
        DateTime(to.year, to.month, to.day, to.hour, to.second, to.millisecond);
    print("Difference: " + (to.difference(from).inSeconds).toString());
    return (to.difference(from).inSeconds).round();
  }

  //Quality Test
  Future<void> _initializePlay(String videoPath, Duration position) async {
    print("start initialisation");
    _controller = VideoPlayerController.network(videoPath);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.seekTo(pos);
      _controller.play();
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            pos = _controller.value.position;
          });
        }
      });
    });
    _controller.setLooping(true);
  }

  void handleQualityChange(int index) {
    if (mounted) {
      setState(() {
        _firtTimeExternAccess = false;
        activeQualityStream = streamQualityKeysSorted.elementAt(index);
        _initializePlay(
            streamQualityURL[activeQualityStream]!, _controller.value.position);
        _showMenu = false;
      });
    }
  }

  void handleFullscreen() {
    if (!_isFullScreen) {
      if (mounted) {
        setState(() {
          _isFullScreen = true;
        });
        goFullScreen();
        animatePressF();
      }
    } else {
      if (mounted) {
        setState(() {
          _width = 0;
          _height = 0;
          _duration = 1;
          _isFullScreen = false;
          exitFullScreen();
        });
      }
    }
  }

  void animatePressF() {
    setState(() {
      _width = 300;
      _height = 70;
      _duration = 100;
    });
    Future.delayed(const Duration(seconds: 4)).then((value) => {
          setState(() {
            _width = 0;
            _height = 0;
            _duration = 600;
          })
        });
  }

  void disableFirstTimeAccess() {
    if (mounted) {
      setState(() {
        _firtTimeExternAccess = false;
      });
    }
  }

  //Quality Test End

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          //SingleChildScrollView
          //scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: _isFullScreen ? 0 : 40),
              Expanded(
                // flex: 7,
                flex: 8,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // if (false) {
                            return !_isFullScreen
                                ?
                                //Normal Player
                                Column(
                                    // ListView(
                                    // scrollDirection: Axis.vertical,
                                    // shrinkWrap: true,
                                    children: [
                                      const SizedBox(
                                        height: 120,
                                      ),
                                      // VideoPlayer + Menu Normal
                                      // AspectRatio(
                                      //   aspectRatio: _controller.value.aspectRatio,
                                      //   child: VideoPlayerNormalLarge(
                                      //     firtTimeExternAccess:
                                      //         widget.firtTimeExternAccess,
                                      //     postData: widget.postData,
                                      //   ),
                                      // ),

                                      videoPlayerKeyboardListener(
                                        VideoPlayerNormalV2(
                                          activeQualityStream:
                                              activeQualityStream,
                                          controller: _controller,
                                          firstTimeExternAccess:
                                              _firtTimeExternAccess,
                                          streamQualityKeysSorted:
                                              streamQualityKeysSorted,
                                          focusNode: focusNode,
                                          handleFullscreenButton: () =>
                                              handleFullscreen.call(),
                                          handleQualityChange: (index) =>
                                              handleQualityChange.call(index),
                                          disbaleFirstTimeAccess: () =>
                                              disableFirstTimeAccess.call(),
                                          skipToNextVideo: () =>
                                              skipToNextVideo.call(),
                                        ),
                                      ),

                                      const SizedBox(height: 30),
                                      //Post Title and Metric, Comments, Description etc.
                                      FutureBuilder(
                                          future: isAuthenticated(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<int> snapshot) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    //Post Title
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        //Title
                                                        Text(
                                                            widget.postData[
                                                                'postTitle'],
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Segoe UI')),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        //Tags
                                                        Wrap(
                                                          runSpacing: 5,
                                                          spacing: 5,
                                                          children:
                                                              _getVideoTagWidgets(
                                                                  taglist),
                                                        ),
                                                      ],
                                                    ),
                                                    //Post Metrics and Ratings
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            //Post Ratings
                                                            snapshot.hasData
                                                                ? snapshot.data ==
                                                                        200
                                                                    ? FutureBuilder(
                                                                        future:
                                                                            Future.wait([
                                                                          getUserPostRating(
                                                                              widget.postData['postId']),
                                                                          getPostRatingScore(
                                                                            widget.postData['postId'],
                                                                          ),
                                                                          getUserPostReport(
                                                                              widget.postData['postId'])
                                                                        ]),
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<List<int>>
                                                                                snapshotRating) {
                                                                          if (snapshotRating
                                                                              .hasData) {
                                                                            return Row(
                                                                              children: [
                                                                                //Slider
                                                                                PostSliderV1(
                                                                                  value: snapshotRating.data![0].toDouble(),
                                                                                  postId: widget.postData['postId'],
                                                                                ),

                                                                                //LIKE
                                                                                // IconButton(
                                                                                //   icon: Icon(
                                                                                //     Icons.thumb_up,
                                                                                //     size: 16,
                                                                                //     color: snapshotRating.data![0] >= 1 ? Theme.of(context).colorScheme.brandColor : Colors.white60,
                                                                                //   ),
                                                                                //   onPressed: () {
                                                                                //     //TODO anpassen mit Slider Werte
                                                                                //     switch (snapshotRating.data![0]) {
                                                                                //       case 0:
                                                                                //         ratePost(widget.postData['postId'], 1).then((_) => setState(() {}));
                                                                                //         break;
                                                                                //       case 1:
                                                                                //         deletePostRating(widget.postData['postId']).then((_) => setState(() {}));
                                                                                //         break;
                                                                                //       case 2:
                                                                                //         updatePostRating(widget.postData['postId'], 1).then((_) => setState(() {}));
                                                                                //         break;
                                                                                //     }
                                                                                //   },
                                                                                // ),
                                                                                // const SizedBox(
                                                                                //   width: 8,
                                                                                // ),
                                                                                //RATING
                                                                                Text(snapshotRating.data![1].toString()),
                                                                                const SizedBox(
                                                                                  width: 8,
                                                                                ),
                                                                                // Text("dislike"),
                                                                                //DISLIKE
                                                                                // IconButton(
                                                                                //   icon: Icon(
                                                                                //     Icons.thumb_down,
                                                                                //     size: 16,
                                                                                //     color: snapshotRating.data![0] == 2 ? Theme.of(context).colorScheme.brandColor : Colors.white60,
                                                                                //   ),
                                                                                //   onPressed: () {
                                                                                //     switch (snapshotRating.data![0]) {
                                                                                //       case 0:
                                                                                //         ratePost(widget.postData['postId'], -1).then((_) => setState(() {}));
                                                                                //         break;
                                                                                //       case 1:
                                                                                //         updatePostRating(widget.postData['postId'], -1).then((_) => setState(() {}));
                                                                                //         break;
                                                                                //       case 2:
                                                                                //         deletePostRating(widget.postData['postId']).then((_) => setState(() {}));
                                                                                //         break;
                                                                                //     }
                                                                                //   },
                                                                                // ),
                                                                                const SizedBox(
                                                                                  width: 16,
                                                                                ),
                                                                                //Report Post
                                                                                IconButton(
                                                                                  icon: Icon(
                                                                                    Icons.flag,
                                                                                    size: 16,
                                                                                    color: snapshotRating.data![2] == 1 ? Theme.of(context).colorScheme.brandColor : Colors.white60,
                                                                                  ),
                                                                                  onPressed: () => (snapshotRating.data![2] == 1)
                                                                                      ? null
                                                                                      : {
                                                                                          reportPost(widget.postData['postId']).then((_) => setState(() {}))
                                                                                        },
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 40,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          } else {
                                                                            return const SizedBox();
                                                                          }
                                                                        })
                                                                    :
                                                                    //SliderTest

                                                                    PostSliderV1(
                                                                        postId:
                                                                            widget.postData['postId'])
                                                                : const SizedBox(),

                                                            // Row(
                                                            //     children: const [
                                                            //       Text(
                                                            //           "login to rate and comment post",
                                                            //           style: TextStyle(
                                                            //               color: Colors
                                                            //                   .white38)),
                                                            //       SizedBox(
                                                            //         width: 40,
                                                            //       )
                                                            //     ],
                                                            //   ),

                                                            //Post Metrics
                                                            const Icon(
                                                              Icons.visibility,
                                                              size: 24,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(widget
                                                                .postData[
                                                                    '_count'][
                                                                    'postWhatchtimeAnalytics']
                                                                .toString()),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        //Sharing share
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            //COPY
                                                            InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(ClipboardData(
                                                                        text: "http://localhost:55555/#/whatch/" +
                                                                            widget.postData['postId']
                                                                                .toString()))
                                                                    .then((_) =>
                                                                        _showToast(
                                                                            context));
                                                                //Create Sharing DB Eintrag
                                                                createSharingAnalyticPost(
                                                                    widget.postData[
                                                                        'postId'],
                                                                    SharingType
                                                                        .copy);
                                                              },
                                                              child: const Icon(
                                                                  Icons.copy,
                                                                  size: 16),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            //SHARE
                                                            InkWell(
                                                              onTap: () => Share.share(
                                                                      'check out my website https://example.com',
                                                                      subject:
                                                                          'Look what I made!')
                                                                  .then(
                                                                      (value) {
                                                                print(
                                                                    "create sharing");
                                                                //Create Sharing DB Eintrag
                                                                createSharingAnalyticPost(
                                                                    widget.postData[
                                                                        'postId'],
                                                                    SharingType
                                                                        .link);
                                                              }),
                                                              child: const Icon(
                                                                  Icons.share,
                                                                  size: 20),
                                                            ),
                                                            const SizedBox(
                                                                width: 10)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                //Video Data and Comments Normal
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    //Post SubchannelName
                                                    InkWell(
                                                      excludeFromSemantics:
                                                          true,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        Beamer.of(context).beamToNamed(
                                                            'subchannel/' +
                                                                widget.postData[
                                                                    'postSubchannelName']);
                                                        print(
                                                            "go to subchnanel");
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14.0),
                                                        child: Image.network(
                                                          baseURL +
                                                              widget.postData[
                                                                          'postSubchannel']
                                                                      [
                                                                      'subchannelPreview']
                                                                  [
                                                                  'subchannelSubchannelPicturePath'],
                                                          fit: BoxFit.cover,
                                                          alignment:
                                                              Alignment.center,
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("c/" +
                                                        widget.postData[
                                                            'postSubchannelName']),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),

                                                    //Post Username
                                                    InkWell(
                                                      excludeFromSemantics:
                                                          true,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        Beamer.of(context)
                                                            .beamToNamed('profile/' +
                                                                widget.postData[
                                                                    'username']);
                                                        print("go to profile");
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14.0),
                                                        child: Image.network(
                                                          baseURL +
                                                              widget.postData[
                                                                          'user']
                                                                      [
                                                                      'userProfile']
                                                                  [
                                                                  'profilePicturePath'],
                                                          fit: BoxFit.cover,
                                                          alignment:
                                                              Alignment.center,
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      widget
                                                          .postData['username'],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                //Post Published Date Time
                                                Text(widget.postData[
                                                            'postPublishedDateTime'] !=
                                                        null
                                                    ? "published " +
                                                        formatDate(widget
                                                                .postData[
                                                            'postPublishedDateTime'])
                                                    : "published 15. October 2021"),
                                                const SizedBox(
                                                  height: 50,
                                                ),
                                                //Post Description
                                                ReadMoreText(
                                                  widget.postData[
                                                      'postDescription'],
                                                  trimLines: 2,
                                                  colorClickableText:
                                                      Colors.pink,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText:
                                                      'Show more',
                                                  trimExpandedText: 'Show less',
                                                  // moreStyle: TextStyle(
                                                  //     fontSize: 14,
                                                  //     fontWeight: FontWeight.bold),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                //Comments
                                                const Text("Comments"),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                //Write Comment only if User logged in
                                                snapshot.data == 200
                                                    ? Column(
                                                        children: [
                                                          WriteComment(
                                                            focusNode:
                                                                writeCommentFocusNode,
                                                            controller:
                                                                _postCommentTextController,
                                                            onSend: () async {
                                                              writeCommentFocusNode
                                                                  .unfocus();
                                                              if (_postCommentTextController
                                                                  .text
                                                                  .trim()
                                                                  .isNotEmpty) {
                                                                //send Comment
                                                                await sendComment(
                                                                    widget.postData[
                                                                        'postId'],
                                                                    _postCommentTextController
                                                                        .text);
                                                              }
                                                              if (mounted) {
                                                                setState(() {
                                                                  _postCommentTextController
                                                                      .clear();
                                                                });
                                                              }
                                                            },
                                                            onTap: () {
                                                              focusNode
                                                                  .unfocus();
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 40,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                                //!Test Comment
                                                // Show Post Comments
                                                FutureBuilder(
                                                    future: fetchPostComments(
                                                        widget.postData[
                                                            'postId']),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<List<int>>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot
                                                            .data!.isNotEmpty) {
                                                          return VideoPlayerCommentsTest(
                                                              // key:
                                                              //     videoPlacerCommentsKey,
                                                              commentIds:
                                                                  snapshot
                                                                      .data!);
                                                        } else {
                                                          return const Text(
                                                              "no comments for video");
                                                        }
                                                      } else {
                                                        return const CircularProgressIndicator();
                                                      }
                                                    }),
                                              ],
                                            );
                                          }),

                                      const SizedBox(
                                        height: 140,
                                      ),
                                    ],
                                  )
                                :
                                //Fullcreen
                                SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: videoPlayerKeyboardListener(
                                      VideoPlayerNormalV2(
                                        activeQualityStream:
                                            activeQualityStream,
                                        controller: _controller,
                                        firstTimeExternAccess:
                                            _firtTimeExternAccess,
                                        streamQualityKeysSorted:
                                            streamQualityKeysSorted,
                                        focusNode: focusNode,
                                        handleFullscreenButton: () =>
                                            handleFullscreen.call(),
                                        handleQualityChange: (index) =>
                                            handleQualityChange.call(index),
                                        disbaleFirstTimeAccess: () =>
                                            disableFirstTimeAccess.call(),
                                        skipToNextVideo: () =>
                                            skipToNextVideo.call(),
                                      ),
                                    ),
                                  );
                          } else {
                            // If the VideoPlayerController is still initializing, show a
                            // loading spinner.
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 400),
                              child: CircularProgressIndicator(),
                            ));
                          }
                        },
                      ),
                    ),
                    //Scroll to top
                    _showScrollToTopComment
                        ? Positioned(
                            top: 120,
                            right: 25,
                            child: FloatingActionButton(
                                child: const Icon(Icons.arrow_upward),
                                onPressed: () {
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.minScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.fastOutSlowIn);
                                }),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              _isFullScreen ? const SizedBox() : const SizedBox(width: 30),
              //Video Recommendations
              _isFullScreen
                  ? const SizedBox()
                  : Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                        child: Column(
                          children: [
                            (widget.postData['postTranscript'] != null)
                                ? Column(
                                    children: [
                                      WordSearchLarge(
                                        pos: pos,
                                        postId: widget.postData['postId'],
                                        seekToSecond: (sec, ease) =>
                                            seekToSecond.call(sec, ease),
                                      ),
                                      const SizedBox(height: 28),
                                    ],
                                  )
                                // : const Text("There is no transcript bro"),
                                : const SizedBox(),
                            //Todo wieder eini tean fir video recommendations
                            // VideoPlayerVideosLargeScreen(
                            //     setSkipToId: (id) => setSkipToId.call(id)),

                            //! InfiniteScroll Test Videos Recommended
                            Expanded(
                              child: Listener(
                                onPointerSignal: (pointerSignal) {
                                  if (pointerSignal is PointerScrollEvent) {
                                    if (WordSearchLarge
                                            .globalKey.currentState !=
                                        null) {
                                      if (WordSearchLarge
                                              .globalKey.currentState!
                                              .getShowWords() !=
                                          WordMode.closed) {
                                        WordSearchLarge.globalKey.currentState!
                                            .animateToClosed();
                                      }
                                    }
                                  }
                                },
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment(0.0, -0.9),
                                      colors: <Color>[
                                        Colors.transparent,
                                        Colors.white
                                      ],
                                    ).createShader(bounds);
                                  },
                                  // blendMode: BlendMode.dstATop,
                                  child: Stack(
                                    children: [
                                      //Video Recommandations
                                      SingleChildScrollView(
                                        controller: _scrollController2,
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 25),
                                            FutureBuilder(
                                                future:
                                                    fetchRecommendedPostIds(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<int>>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    if (snapshot
                                                        .data!.isNotEmpty) {
                                                      return VideoPlayerVideosLargeScreenTest(
                                                        postIds: snapshot.data!,
                                                        setSkipToId: (id) =>
                                                            setSkipToId
                                                                .call(id),
                                                        isAuth: true,
                                                      );
                                                    } else {
                                                      return const Text(
                                                          "no posts for video");
                                                    }
                                                  } else {
                                                    return const CircularProgressIndicator();
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                      //Scroll to top Video Recommandations
                                      _showScrollToTopVideoRecommandations
                                          ? Positioned(
                                              top: 40,
                                              right: 15,
                                              child: FloatingActionButton(
                                                  child: const Icon(
                                                      Icons.arrow_upward),
                                                  onPressed: () {
                                                    _scrollController2.animateTo(
                                                        _scrollController2
                                                            .position
                                                            .minScrollExtent,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                        curve: Curves
                                                            .fastOutSlowIn);
                                                  }),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              _isFullScreen ? const SizedBox() : const SizedBox(width: 20),
            ],
          ),
        ),
        !_isFullScreen ? widget.navbar : const SizedBox(),
        //Press F
        Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: _duration),
            width: _width,
            height: _height,
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              color: Colors.grey.shade700.withOpacity(0.3),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        const Text(
                          "Press  ",
                          style: TextStyle(fontSize: 24),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.white),
                            color: Colors.black.withOpacity(0.8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              " F ",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Text(
                          "  to exit Fullscreen",
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget videoPlayerKeyboardListener(Widget child) {
    // return KeyboardListener(focusNode: focusNode, child: child);
    return KeyboardListener(
        autofocus: true,
        focusNode: focusNode,
        onKeyEvent: (event) {
          print("EVENT");
          if (event is KeyDownEvent) {
            print("Label" + event.logicalKey.keyLabel);
            // if(event.physicalKey)
            // print("Physical: " + event.physicalKey.toString());
            // print("Logical: " + event.logicalKey.toString());
            // print("Character: " + event.character.toString());

            // prevent from writing comment
            if (event.logicalKey.keyLabel == 'F') {
              print("F pressed");
              handleFullscreen();
            } else if (event.logicalKey.keyLabel == ' ') {
              print("Space pressed");
              if (_controller.value.isPlaying) {
                if (mounted) {
                  if (mounted) {
                    setState(() {
                      _controller.pause();
                      print("paused");

                      _showMenu = true;
                      print("_showMenu set to true");
                    });
                  }
                }

                EasyDebounce.debounce(
                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                    const Duration(seconds: 2), // <-- The debounce duration
                    () {
                  if (_showMenu) {
                    if (mounted) {
                      if (mounted) {
                        setState(() {
                          _showMenu = false;
                          print("_showMenu set to false");
                        });
                      }
                    }
                  }
                }); // <-- The target method

              } else {
                // If the video is paused, play it.
                if (mounted) {
                  setState(() {
                    _controller.play();
                    print("playing");

                    _showMenu = true;
                    print("_showMenu set to true");
                  });
                }

                EasyDebounce.debounce(
                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                    const Duration(seconds: 2), // <-- The debounce duration
                    () {
                  if (_showMenu) {
                    if (mounted) {
                      setState(() {
                        _showMenu = false;
                        print("_showMenu set to false");
                      });
                    }
                  }
                }); // <-- The target method

              }
            } else if (event.logicalKey.keyLabel == 'Escape') {
              print("Escape");
              // if (!document.documentElement!.webkitIsFullScreen &&
              //     !document.mozFullScreen &&
              //     !document.msFullscreenElement) {}
              // document.onFullscreenChange.
              // if (_isFullScreen) {
              //   setState(() {
              //     _isFullScreen = false;
              //   });
              //   exitFullScreen();
              // }
              handleFullscreen();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              if (mounted) {
                setState(() {
                  _controller.seekTo(
                      _controller.value.position - const Duration(seconds: 5));
                });
              }
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              if (mounted) {
                setState(() {
                  _controller.seekTo(
                      _controller.value.position + const Duration(seconds: 5));
                });
              }
            } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
              //Skipping Video
              print("skip");
              skipToNextVideo.call();
            }
          }
        },
        child: child);
  }

  _scrollListener() {
    // print("Offset: " + _scrollController.offset.toString());
    // print("MaxScrollExtent: " +
    //     _scrollController.position.maxScrollExtent.toString());
    // print("outOfRange: " + (!_scrollController.position.outOfRange).toString());

    if (_scrollController.offset > 1300 && !_showScrollToTopComment) {
      if (mounted) {
        setState(() {
          _showScrollToTopComment = true;
        });
      }
    } else if (_scrollController.offset < 1300 && _showScrollToTopComment) {
      if (mounted) {
        setState(() {
          _showScrollToTopComment = false;
        });
      }
    }

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // setState(() {
      //   print("comes to bottom $isLoading");
      //   isLoading = true;

      //   if (isLoading) {
      //     print("RUNNING LOAD MORE");

      //     pageCount = pageCount + 1;

      //     addItemIntoLisT(pageCount);
      //   }
      // });
      print("load new comments");
      loadNewStuff();
    }
  }

  _scrollListener2() {
    print("Offset: " + _scrollController2.offset.toString());
    print("MaxScrollExtent: " +
        _scrollController2.position.maxScrollExtent.toString());
    print(
        "outOfRange: " + (!_scrollController2.position.outOfRange).toString());

    if (_scrollController2.offset > 200 &&
        !_showScrollToTopVideoRecommandations) {
      if (mounted) {
        setState(() {
          _showScrollToTopVideoRecommandations = true;
        });
      }
    } else if (_scrollController2.offset < 200 &&
        _showScrollToTopVideoRecommandations) {
      if (mounted) {
        setState(() {
          _showScrollToTopVideoRecommandations = false;
        });
      }
    }

    if (_scrollController2.offset >=
            _scrollController2.position.maxScrollExtent &&
        !_scrollController2.position.outOfRange) {
      // setState(() {
      //   print("comes to bottom $isLoading");
      //   isLoading = true;

      //   if (isLoading) {
      //     print("RUNNING LOAD MORE");

      //     pageCount = pageCount + 1;

      //     addItemIntoLisT(pageCount);
      //   }
      // });
      print("load new comments");
      loadNewStuff2();
    }
  }
}

List<Widget> _getVideoTagWidgets(List<String> list) {
  List<Widget> widgetList = List.generate(list.length, (index) {
    return Chip(
      label: Text(
        capitalizeOnlyFirstLater(list.elementAt(index)),
        style: const TextStyle(fontFamily: "Segoe UI", fontSize: 14),
      ),
    );
  });

  return widgetList;
}

Future<List<int>> fetchRecommendedPostIds() async {
  try {
    final response =
        await http.get(Uri.parse('http://localhost:3000/post/getPostIds'));

    if (response.statusCode == 200) {
      List<int> postIds = <int>[];
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
      return postIds;
    } else {
      throw Exception('Failed to load post');
    }
  } catch (e) {
    throw Exception('Failed to load post');
  }
}
