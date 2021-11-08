import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/comment/comment_post_util_methods.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/util_methods.dart';
import 'package:uidraft1/widgets/comment/comment_model_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_videos_grid_large_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:html';
import 'package:readmore/readmore.dart';
// import 'dart:html' as html;

void goFullScreen() {
  document.documentElement!.requestFullscreen();
}

void exitFullScreen() {
  document.exitFullscreen();
}

//Latest Player
class VideoPlayerHome extends StatefulWidget {
  const VideoPlayerHome(
      {Key? key, required this.postData, required this.firtTimeExternAccess})
      : super(key: key);

  final Map<String, dynamic> postData;
  final bool firtTimeExternAccess;

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
  bool _showQuality = false;

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

  @override
  void initState() {
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
    }
    if (widget.postData['postVideoPath720'].toString().isNotEmpty) {
      streamQualityURL[720] = baseURL + widget.postData['postVideoPath720'];
    }
    if (widget.postData['postVideoPath1080'].toString().isNotEmpty) {
      streamQualityURL[1080] = baseURL + widget.postData['postVideoPath1080'];
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

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!widget.firtTimeExternAccess) {
        window.history.replaceState(null, 'VideoPlayer',
            '#/whatch/' + widget.postData['postId'].toString());
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    print("DISPOSE");
    createWhatchtimeAnalyticPost(
        widget.postData['postId'], _controller.value.position.inSeconds);
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
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

  //Quality Test End

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: _isFullScreen ? 0 : 40),
                Expanded(
                  flex: 7,
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // if (false) {
                        return !_isFullScreen
                            ?
                            //Normal Player
                            ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(
                                    height: 120,
                                  ),
                                  //VideoPlayer + Menu Normal
                                  VideoPlayerKeyboardListener(
                                    AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      // Use the VideoPlayer widget to display the video.
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          //VideoPlayer Normal
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              print("tap");
                                              _firtTimeExternAccess = false;
                                              if (_controller.value.isPlaying) {
                                                if (mounted) {
                                                  setState(() {
                                                    _controller.pause();
                                                    print("paused");

                                                    _showMenu = true;
                                                    print(
                                                        "_showMenu set to true");
                                                    _showQuality = false;
                                                  });
                                                }

                                                EasyDebounce.debounce(
                                                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                                    const Duration(
                                                        seconds:
                                                            2), // <-- The debounce duration
                                                    () {
                                                  if (_showMenu) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _showMenu = false;
                                                        _showQuality = false;
                                                        print(
                                                            "_showMenu set to false");
                                                      });
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
                                                    print(
                                                        "_showMenu set to true");
                                                    _showQuality = false;
                                                  });
                                                }

                                                EasyDebounce.debounce(
                                                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                                    const Duration(
                                                        seconds:
                                                            2), // <-- The debounce duration
                                                    () {
                                                  if (_showMenu) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _showMenu = false;
                                                        _showQuality = false;
                                                        print(
                                                            "_showMenu set to false");
                                                      });
                                                    }
                                                  }
                                                }); // <-- The target method

                                              }
                                            },
                                            child: IgnorePointer(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child:
                                                      VideoPlayer(_controller)),
                                            ),
                                          ),
                                          _showMenu
                                              //VideoPlayerMenu Normal
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        _showQuality
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .videoPlayerIconBackgroundColor
                                                                        .withOpacity(
                                                                            0.6)),
                                                                child: Column(
                                                                    //Generate Quality Menu
                                                                    children: List.generate(
                                                                        streamQualityKeysSorted
                                                                            .length,
                                                                        (index) {
                                                                  return Container(
                                                                    color: streamQualityKeysSorted.elementAt(index) ==
                                                                            activeQualityStream
                                                                        ? Theme.of(context)
                                                                            .colorScheme
                                                                            .brandColor
                                                                        : Colors
                                                                            .transparent,
                                                                    child: TextButton(
                                                                        onPressed: () {
                                                                          if (mounted) {
                                                                            setState(() {
                                                                              _firtTimeExternAccess = false;
                                                                              activeQualityStream = streamQualityKeysSorted.elementAt(index);
                                                                              _initializePlay(streamQualityURL[activeQualityStream]!, _controller.value.position);
                                                                              _showMenu = false;
                                                                              _showQuality = false;
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Text(streamQualityKeysSorted.elementAt(index).toString() + 'p')),
                                                                  );
                                                                })),
                                                              )
                                                            : const SizedBox(),
                                                        RotatedBox(
                                                          quarterTurns: 3,
                                                          child: SliderTheme(
                                                            data:
                                                                SliderTheme.of(
                                                                        context)
                                                                    .copyWith(
                                                              activeTrackColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .highlightColor,
                                                              inactiveTrackColor: Theme
                                                                      .of(
                                                                          context)
                                                                  .colorScheme
                                                                  .videoPlayerIconBackgroundColor
                                                                  .withOpacity(
                                                                      0.6),
                                                              // trackShape: RectangularSliderTrackShape(),
                                                              trackHeight: 10,
                                                              thumbColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .highlightColor,
                                                              thumbShape: const RoundSliderThumbShape(
                                                                  enabledThumbRadius:
                                                                      7,
                                                                  elevation: 0,
                                                                  pressedElevation:
                                                                      0,
                                                                  disabledThumbRadius:
                                                                      7),

                                                              overlayColor: Colors
                                                                  .transparent,
                                                              // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                                            ),
                                                            child: Slider(
                                                              mouseCursor:
                                                                  SystemMouseCursors
                                                                      .resizeUpDown,

                                                              value: _controller
                                                                      .value
                                                                      .volume *
                                                                  100,
                                                              min: 0,
                                                              max: 100,
                                                              //divisions: 20,
                                                              //label: (_controller!.value.volume * 100).round().toString(),
                                                              onChanged: (double
                                                                  value) {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    _controller.setVolume(
                                                                        value /
                                                                            100);
                                                                  });
                                                                }

                                                                if (!_showMenu) {
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      _showMenu =
                                                                          true;
                                                                      print(
                                                                          "_showMenu set to true");
                                                                    });
                                                                  }

                                                                  Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              5),
                                                                      () {
                                                                    if (_showMenu) {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          _showMenu =
                                                                              false;
                                                                          print(
                                                                              "_showMenu set to false");
                                                                        });
                                                                      }
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 24,
                                                        ),
                                                        MaterialButton(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          minWidth: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            _firtTimeExternAccess =
                                                                false;
                                                            if (_controller
                                                                .value
                                                                .isPlaying) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _controller
                                                                      .pause();
                                                                  print(
                                                                      "paused");
                                                                });
                                                              }
                                                            } else {
                                                              // If the video is paused, play it.
                                                              if (mounted) {
                                                                setState(() {
                                                                  _controller
                                                                      .play();
                                                                  print(
                                                                      "playing");
                                                                });
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .videoPlayerIconBackgroundColor
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Icon(
                                                                  _controller
                                                                          .value
                                                                          .isPlaying
                                                                      ? Icons
                                                                          .pause
                                                                      : Icons
                                                                          .play_arrow,
                                                                  size: 32,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .highlightColor,
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        MaterialButton(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          minWidth: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            if (_controller
                                                                .value
                                                                .isPlaying) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _controller
                                                                      .pause();
                                                                  print(
                                                                      "paused");
                                                                });
                                                              }
                                                            } else {
                                                              // If the video is paused, play it.
                                                              if (mounted) {
                                                                setState(() {
                                                                  _controller
                                                                      .play();
                                                                  print(
                                                                      "playing");
                                                                });
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .videoPlayerIconBackgroundColor
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .skip_next,
                                                                  size: 24,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .highlightColor,
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        //Video Position
                                                        Text(_controller.value
                                                            .position.inSeconds
                                                            .toString()),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Flexible(
                                                          child: SizedBox(
                                                            height: 15,
                                                            child: ClipRRect(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                          28),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          28),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          12)),
                                                              child:
                                                                  VideoProgressIndicator(
                                                                _controller,
                                                                colors: VideoProgressColors(
                                                                    playedColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .highlightColor,
                                                                    bufferedColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .videoPlayerIconBackgroundColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey),
                                                                allowScrubbing:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        //Show Qualities Button
                                                        MaterialButton(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          minWidth: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            if (mounted) {
                                                              setState(() {
                                                                _firtTimeExternAccess =
                                                                    false;
                                                                _showQuality =
                                                                    !_showQuality;
                                                                _showMenu =
                                                                    true;
                                                              });
                                                            }

                                                            EasyDebounce
                                                                .debounce(
                                                                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                                                    const Duration(
                                                                        seconds:
                                                                            5), // <-- The debounce duration
                                                                    () {
                                                              if (_showMenu) {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    _firtTimeExternAccess =
                                                                        false;
                                                                    _showMenu =
                                                                        false;
                                                                    _showQuality =
                                                                        false;
                                                                    print(
                                                                        "_showMenu set to false");
                                                                  });
                                                                }
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .videoPlayerIconBackgroundColor
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .settings,
                                                                  size: 28,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .highlightColor,
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        //Fullscreen Button Normal PLayer
                                                        MaterialButton(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          minWidth: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            if (!_isFullScreen) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _isFullScreen =
                                                                      true;
                                                                  goFullScreen();
                                                                });
                                                              }
                                                            } else {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _isFullScreen =
                                                                      false;
                                                                  exitFullScreen();
                                                                });
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .videoPlayerIconBackgroundColor
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .fullscreen,
                                                                  size: 32,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .highlightColor,
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 35,
                                                    )
                                                  ],
                                                )
                                              : const SizedBox(),
                                          //FirstTimeExternAccess
                                          _firtTimeExternAccess
                                              ? Center(
                                                  child: MaterialButton(
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    minWidth: 0,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    onPressed: () {
                                                      _firtTimeExternAccess =
                                                          false;
                                                      if (_controller
                                                          .value.isPlaying) {
                                                        if (mounted) {
                                                          setState(() {
                                                            _controller.pause();
                                                            print("paused");
                                                          });
                                                        }
                                                      } else {
                                                        // If the video is paused, play it.
                                                        if (mounted) {
                                                          setState(() {
                                                            _controller.play();
                                                            print("playing");
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .videoPlayerIconBackgroundColor
                                                              .withOpacity(0.6),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Icon(
                                                            Icons.play_arrow,
                                                            size: 128,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .highlightColor,
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
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
                                                      CrossAxisAlignment.center,
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
                                                Row(
                                                  children: [
                                                    //Post Ratings
                                                    snapshot.data == 200
                                                        ? FutureBuilder(
                                                            future:
                                                                Future.wait([
                                                              getUserPostRating(
                                                                  widget.postData[
                                                                      'postId']),
                                                              getPostRatingScore(
                                                                  widget.postData[
                                                                      'postId'])
                                                            ]),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        List<
                                                                            int>>
                                                                    snapshotRating) {
                                                              if (snapshotRating
                                                                  .hasData) {
                                                                return Row(
                                                                  children: [
                                                                    //LIKE
                                                                    IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .thumb_up,
                                                                        size:
                                                                            16,
                                                                        color: snapshotRating.data![0] ==
                                                                                1
                                                                            ? Theme.of(context).colorScheme.brandColor
                                                                            : Colors.white60,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        switch (
                                                                            snapshotRating.data![0]) {
                                                                          case 0:
                                                                            ratePost(widget.postData['postId'], 'like').then((_) =>
                                                                                setState(() {}));
                                                                            break;
                                                                          case 1:
                                                                            deletePostRating(widget.postData['postId']).then((_) =>
                                                                                setState(() {}));
                                                                            break;
                                                                          case 2:
                                                                            updatePostRating(widget.postData['postId'], 'like').then((_) =>
                                                                                setState(() {}));
                                                                            break;
                                                                        }
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    //RATING
                                                                    Text(snapshotRating
                                                                        .data![
                                                                            1]
                                                                        .toString()),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    // Text("dislike"),
                                                                    //DISLIKE
                                                                    IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .thumb_down,
                                                                        size:
                                                                            16,
                                                                        color: snapshotRating.data![0] ==
                                                                                2
                                                                            ? Theme.of(context).colorScheme.brandColor
                                                                            : Colors.white60,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        switch (
                                                                            snapshotRating.data![0]) {
                                                                          case 0:
                                                                            ratePost(widget.postData['postId'], 'dislike').then((_) =>
                                                                                setState(() {}));
                                                                            break;
                                                                          case 1:
                                                                            updatePostRating(widget.postData['postId'], 'dislike').then((_) =>
                                                                                setState(() {}));
                                                                            break;
                                                                          case 2:
                                                                            deletePostRating(widget.postData['postId']).then((_) =>
                                                                                setState(() {}));
                                                                            break;
                                                                        }
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
                                                        Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 250,
                                                                child: Slider(
                                                                  value:
                                                                      sliderval,
                                                                  min: 0,
                                                                  max: 100,
                                                                  divisions: 23,

                                                                  activeColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .brandColor,
                                                                  thumbColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .brandColor,
                                                                  // label: sliderval
                                                                  //     .round()
                                                                  //     .toString(),
                                                                  onChanged:
                                                                      (double
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      sliderval =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 40,
                                                              )
                                                            ],
                                                          ),

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
                                                        .postData['_count'][
                                                            'postWhatchtimeAnalytics']
                                                        .toString()),

                                                    //SHow rating hwen not logged in
                                                    // const SizedBox(
                                                    //   width: 12,
                                                    // ),
                                                    // const Icon(
                                                    //   Icons.trending_up,
                                                    //   size: 24,
                                                    // ),
                                                    // const SizedBox(
                                                    //   width: 5,
                                                    // ),
                                                    // Text(widget.postData[
                                                    //         'postRatingScore']
                                                    //     .toString()),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
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
                                                  excludeFromSemantics: true,
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
                                                    print("go to subchnanel");
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
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
                                                  excludeFromSemantics: true,
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
                                                        BorderRadius.circular(
                                                            14.0),
                                                    child: Image.network(
                                                      baseURL +
                                                          widget.postData[
                                                                      'user'][
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
                                                  widget.postData['username'],
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
                                                    formatDate(widget.postData[
                                                        'postPublishedDateTime'])
                                                : "published 15. October 2021"),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            //Post Description
                                            ReadMoreText(
                                              widget
                                                  .postData['postDescription'],
                                              trimLines: 2,
                                              colorClickableText: Colors.pink,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: 'Show more',
                                              trimExpandedText: 'Show less',
                                              // moreStyle: TextStyle(
                                              //     fontSize: 14,
                                              //     fontWeight: FontWeight.bold),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            // Column(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.start,
                                            //     children: <Widget>[
                                            //       ConstrainedBox(
                                            //           constraints: isExpanded
                                            //               ? const BoxConstraints()
                                            //               : const BoxConstraints(
                                            //                   maxHeight: 50.0),
                                            //           child: Text(
                                            //             widget.postData[
                                            //                 'postDescription'],
                                            //             softWrap: true,
                                            //             overflow:
                                            //                 TextOverflow.fade,

                                            //           )),
                                            //       isExpanded
                                            //           ? TextButton(
                                            //               child: const Text(
                                            //                   'show less'),
                                            //               onPressed: () =>
                                            //                   setState(() =>
                                            //                       isExpanded =
                                            //                           false))
                                            //           : TextButton(
                                            //               child: const Text(
                                            //                   'show more'),
                                            //               onPressed: () =>
                                            //                   setState(() =>
                                            //                       isExpanded =
                                            //                           true))
                                            //     ]),

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
                                                      TextFormField(
                                                        onTap: () {
                                                          focusNode.unfocus();
                                                        },
                                                        buildCounter: (_,
                                                                {required currentLength,
                                                                maxLength,
                                                                required isFocused}) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 16.0),
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(currentLength
                                                                      .toString() +
                                                                  "/" +
                                                                  maxLength
                                                                      .toString())),
                                                        ),
                                                        controller:
                                                            _postCommentTextController,
                                                        cursorColor:
                                                            Colors.white,
                                                        autocorrect: false,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLength: 256,
                                                        minLines: 1,
                                                        maxLines: 20,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Write a comment",
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  color: Colors
                                                                      .white54),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white70),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .pink),
                                                          ),
                                                        ),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return "Field cannot be empty";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "Segoe UI",
                                                            color:
                                                                Colors.white70),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: OutlinedButton(
                                                          style: ButtonStyle(
                                                            side: MaterialStateProperty
                                                                .resolveWith(
                                                                    (states) {
                                                              Color
                                                                  _borderColor;
                                                              if (states.contains(
                                                                  MaterialState
                                                                      .pressed)) {
                                                                _borderColor =
                                                                    Colors
                                                                        .white;
                                                              } else if (states
                                                                  .contains(
                                                                      MaterialState
                                                                          .hovered)) {
                                                                _borderColor = Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .brandColor;
                                                              } else {
                                                                _borderColor =
                                                                    Colors.grey;
                                                              }

                                                              return BorderSide(
                                                                  color:
                                                                      _borderColor,
                                                                  width: 1);
                                                            }),
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0))),
                                                          ),
                                                          onPressed: () async {
                                                            //send Comment
                                                            await sendComment(
                                                                widget.postData[
                                                                    'postId'],
                                                                _postCommentTextController
                                                                    .text);
                                                            setState(() {
                                                              _postCommentTextController
                                                                  .clear();
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Text(
                                                              "send",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Sogeo UI',
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white70),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            //Show Post Comments
                                            FutureBuilder(
                                                future: fetchPostComments(
                                                    widget.postData['postId']),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<int>>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    if (snapshot
                                                        .data!.isNotEmpty) {
                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: snapshot
                                                              .data!.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Column(
                                                              children: [
                                                                CommentModel(
                                                                    commentId: snapshot
                                                                        .data!
                                                                        .elementAt(
                                                                            index)),
                                                                const SizedBox(
                                                                  height: 15,
                                                                )
                                                              ],
                                                            );
                                                          });
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
                            //FullScreen
                            Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  VideoPlayerKeyboardListener(
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        print("tap");
                                        _firtTimeExternAccess = false;
                                        if (_controller.value.isPlaying) {
                                          if (mounted) {
                                            setState(() {
                                              _controller.pause();
                                              print("paused");

                                              _showMenu = true;
                                              print("_showMenu set to true");
                                              _showQuality = false;
                                            });
                                          }

                                          EasyDebounce.debounce(
                                              'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                              const Duration(
                                                  seconds:
                                                      2), // <-- The debounce duration
                                              () {
                                            if (_showMenu) {
                                              if (mounted) {
                                                setState(() {
                                                  _showMenu = false;
                                                  _showQuality = false;
                                                  print(
                                                      "_showMenu set to false");
                                                });
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
                                              _showQuality = false;
                                            });
                                          }

                                          EasyDebounce.debounce(
                                              'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                              const Duration(
                                                  seconds:
                                                      2), // <-- The debounce duration
                                              () {
                                            if (_showMenu) {
                                              if (mounted) {
                                                setState(() {
                                                  _showMenu = false;
                                                  _showQuality = false;
                                                  print(
                                                      "_showMenu set to false");
                                                });
                                              }
                                            }
                                          }); // <-- The target method

                                        }
                                      },
                                      child: IgnorePointer(
                                        child: AspectRatio(
                                          aspectRatio:
                                              _controller.value.aspectRatio,
                                          child: SizedBox.expand(
                                            child: FittedBox(
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                // width: _controller.value.size.width,
                                                // height: _controller.value.size.height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: VideoPlayer(_controller),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _showMenu
                                      //VideoPlayer Menu Fullscreen
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                _showQuality
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .videoPlayerIconBackgroundColor
                                                                .withOpacity(
                                                                    0.6)),
                                                        child: Column(
                                                            //Generate Quality Menu
                                                            children: List.generate(
                                                                streamQualityKeysSorted
                                                                    .length,
                                                                (index) {
                                                          return Container(
                                                            color: streamQualityKeysSorted
                                                                        .elementAt(
                                                                            index) ==
                                                                    activeQualityStream
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .brandColor
                                                                : Colors
                                                                    .transparent,
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  _firtTimeExternAccess =
                                                                      false;
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      activeQualityStream =
                                                                          streamQualityKeysSorted
                                                                              .elementAt(index);
                                                                      _initializePlay(
                                                                          streamQualityURL[
                                                                              activeQualityStream]!,
                                                                          _controller
                                                                              .value
                                                                              .position);
                                                                      _showMenu =
                                                                          false;
                                                                      _showQuality =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(streamQualityKeysSorted
                                                                        .elementAt(
                                                                            index)
                                                                        .toString() +
                                                                    'p')),
                                                          );
                                                        })),
                                                      )
                                                    : const SizedBox(),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      activeTrackColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .highlightColor,
                                                      inactiveTrackColor: Theme
                                                              .of(context)
                                                          .colorScheme
                                                          .videoPlayerIconBackgroundColor
                                                          .withOpacity(0.6),
                                                      // trackShape: RectangularSliderTrackShape(),
                                                      trackHeight: 10,
                                                      thumbColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .highlightColor,
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  7,
                                                              elevation: 0,
                                                              pressedElevation:
                                                                  0,
                                                              disabledThumbRadius:
                                                                  7),

                                                      overlayColor:
                                                          Colors.transparent,
                                                      // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                                    ),
                                                    child: Slider(
                                                      mouseCursor:
                                                          SystemMouseCursors
                                                              .resizeUpDown,

                                                      value: _controller
                                                              .value.volume *
                                                          100,
                                                      min: 0,
                                                      max: 100,
                                                      //divisions: 20,
                                                      //label: (_controller!.value.volume * 100).round().toString(),
                                                      onChanged:
                                                          (double value) {
                                                        if (mounted) {
                                                          setState(() {
                                                            _controller
                                                                .setVolume(
                                                                    value /
                                                                        100);
                                                          });
                                                        }

                                                        if (!_showMenu) {
                                                          if (mounted) {
                                                            setState(() {
                                                              _showMenu = true;
                                                              print(
                                                                  "_showMenu set to true");
                                                            });
                                                          }

                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 5),
                                                              () {
                                                            if (_showMenu) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _showMenu =
                                                                      false;
                                                                  print(
                                                                      "_showMenu set to false");
                                                                });
                                                              }
                                                            }
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 24,
                                                ),
                                                MaterialButton(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    _firtTimeExternAccess =
                                                        false;
                                                    if (_controller
                                                        .value.isPlaying) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _controller.pause();
                                                          print("paused");
                                                        });
                                                      }
                                                    } else {
                                                      // If the video is paused, play it.
                                                      if (mounted) {
                                                        setState(() {
                                                          _controller.play();
                                                          print("playing");
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .videoPlayerIconBackgroundColor
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Icon(
                                                          _controller.value
                                                                  .isPlaying
                                                              ? Icons.pause
                                                              : Icons
                                                                  .play_arrow,
                                                          size: 32,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .highlightColor,
                                                        ),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                MaterialButton(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    _firtTimeExternAccess =
                                                        false;
                                                    if (_controller
                                                        .value.isPlaying) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _controller.pause();
                                                          print("paused");
                                                        });
                                                      }
                                                    } else {
                                                      // If the video is paused, play it.
                                                      if (mounted) {
                                                        setState(() {
                                                          _controller.play();
                                                          print("playing");
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .videoPlayerIconBackgroundColor
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Icon(
                                                          Icons.skip_next,
                                                          size: 24,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .highlightColor,
                                                        ),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                //Video Position
                                                Text(_controller
                                                    .value.position.inSeconds
                                                    .toString()),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: SizedBox(
                                                    height: 15,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(28),
                                                              topRight: Radius
                                                                  .circular(28),
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                      child:
                                                          VideoProgressIndicator(
                                                        _controller,
                                                        colors: VideoProgressColors(
                                                            playedColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .highlightColor,
                                                            bufferedColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .videoPlayerIconBackgroundColor
                                                                .withOpacity(
                                                                    0.6),
                                                            backgroundColor:
                                                                Colors.grey),
                                                        allowScrubbing: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                //Show Qualities Button
                                                MaterialButton(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    _firtTimeExternAccess =
                                                        false;
                                                    if (mounted) {
                                                      setState(() {
                                                        _firtTimeExternAccess =
                                                            false;
                                                        _showQuality =
                                                            !_showQuality;
                                                        _showMenu = true;
                                                      });
                                                    }

                                                    EasyDebounce.debounce(
                                                        'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                                        const Duration(
                                                            seconds:
                                                                5), // <-- The debounce duration
                                                        () {
                                                      if (_showMenu) {
                                                        if (mounted) {
                                                          setState(() {
                                                            _firtTimeExternAccess =
                                                                false;
                                                            _showMenu = false;
                                                            _showQuality =
                                                                false;
                                                            print(
                                                                "_showMenu set to false");
                                                          });
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .videoPlayerIconBackgroundColor
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Icon(
                                                          Icons.settings,
                                                          size: 28,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .highlightColor,
                                                        ),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                //Fullscreen Button Fullscreen PLayer
                                                MaterialButton(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    if (!_isFullScreen) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _firtTimeExternAccess =
                                                              false;
                                                          _isFullScreen = true;
                                                          goFullScreen();
                                                        });
                                                      }
                                                    } else {
                                                      if (mounted) {
                                                        setState(() {
                                                          _firtTimeExternAccess =
                                                              false;
                                                          _isFullScreen = false;
                                                          exitFullScreen();
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .videoPlayerIconBackgroundColor
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Icon(
                                                          Icons.fullscreen,
                                                          size: 32,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .highlightColor,
                                                        ),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 35,
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
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
                _isFullScreen ? const SizedBox() : const SizedBox(width: 30),
                //Video Recommendations
                _isFullScreen
                    ? const SizedBox()
                    : const Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: VideoPlayerVideosLargeScreen(),
                        ),
                      ),
                _isFullScreen ? const SizedBox() : const SizedBox(width: 20),
              ],
            ),
          ),
        ),
        !_isFullScreen ? const NavBarLargeProfile() : const SizedBox(),
      ],
    );
  }

  Widget VideoPlayerKeyboardListener(Widget child) {
    // return KeyboardListener(focusNode: focusNode, child: child);
    return KeyboardListener(
        autofocus: true,
        focusNode: focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            // if(event.physicalKey)
            // print("Physical: " + event.physicalKey.toString());
            // print("Logical: " + event.logicalKey.toString());
            // print("Character: " + event.character.toString());

            // prevent from writing comment
            if (event.logicalKey.keyLabel == 'F') {
              print("F pressed");
              if (_isFullScreen) {
                exitFullScreen();
                setState(() {
                  _isFullScreen = false;
                });
              } else {
                goFullScreen();
                setState(() {
                  _isFullScreen = true;
                });
              }
            } else if (event.logicalKey.keyLabel == ' ') {
              print("Space pressed");
              if (_controller.value.isPlaying) {
                if (mounted) {
                  setState(() {
                    _controller.pause();
                    print("paused");

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
                        _showQuality = false;
                        print("_showMenu set to false");
                      });
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
                        _showQuality = false;
                        print("_showMenu set to false");
                      });
                    }
                  }
                }); // <-- The target method

              }
            } else if (event.logicalKey.keyLabel == 'Escape') {
              if (_isFullScreen) {
                setState(() {
                  _isFullScreen = false;
                });
                exitFullScreen();
              }
            }
          }
        },
        child: MouseRegion(
            cursor:
                _showMenu ? SystemMouseCursors.basic : SystemMouseCursors.none,
            //On Player Exit
            onExit: (PointerExitEvent event) {
              if (_showMenu) {
                EasyDebounce.debounce(
                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                    const Duration(seconds: 2), // <-- The debounce duration
                    () {
                  if (_showMenu) {
                    if (mounted) {
                      setState(() {
                        _showMenu = false;
                        _showQuality = false;
                        print("_showMenu set to false");
                      });
                    }
                  }
                });
              }
            },
            onEnter: (PointerEnterEvent event) {
              focusNode.requestFocus();
              if (!_showMenu) {
                if (mounted) {
                  setState(() {
                    _showMenu = true;
                    print("_showMenu set to true");
                  });
                }

                EasyDebounce.debounce(
                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                    const Duration(seconds: 5), // <-- The debounce duration
                    () {
                  if (_showMenu) {
                    if (mounted) {
                      setState(() {
                        _showMenu = false;
                        _showQuality = false;
                        print("_showMenu set to false");
                      });
                    }
                  }
                }); // <-- The target method
              }
            },
            onHover: (PointerHoverEvent event) {
              if (!_showMenu) {
                if (mounted) {
                  setState(() {
                    _showMenu = true;
                    print("_showMenu set to true");
                  });
                }

                EasyDebounce.debounce(
                    'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                    const Duration(seconds: 7), // <-- The debounce duration
                    () {
                  if (_showMenu) {
                    if (mounted) {
                      setState(() {
                        _showMenu = false;
                        _showQuality = false;
                        print("_showMenu set to false");
                      });
                    }
                  }
                }); // <-- The target method
              }
            },
            child: child));
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
