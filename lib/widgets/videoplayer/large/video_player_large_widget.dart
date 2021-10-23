import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_videos_grid_large_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:html';
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
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  late bool _firtTimeExternAccess;

  bool _isFullScreen = false;
  bool _showMenu = false;
  bool _showQuality = false;

  bool isExpanded = false;

  Map<int, String> streamQualityURL = {};
  List<int> streamQualityKeysSorted = [];
  late int activeQualityStream;

  Duration pos = const Duration();

  String baseURL = 'http://localhost:3000/';

  @override
  void initState() {
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
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  //Quality Test

  Future<void> _initializePlay(String videoPath, Duration position) async {
    print("start initialisation");
    _controller = VideoPlayerController.network(videoPath);
    // _controller.addListener(() {
    //   setState(() {
    //     _playBackTime = _controller.value.position.inSeconds;
    //   });
    // });
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
                                  MouseRegion(
                                    cursor: _showMenu
                                        ? SystemMouseCursors.basic
                                        : SystemMouseCursors.none,
                                    //On Player Exit
                                    onExit: (PointerExitEvent event) {
                                      if (_showMenu) {
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
                                                print("_showMenu set to false");
                                              });
                                            }
                                          }
                                        });
                                      }
                                    },
                                    onEnter: (PointerEnterEvent event) {
                                      if (!_showMenu) {
                                        if (mounted) {
                                          setState(() {
                                            _showMenu = true;
                                            print("_showMenu set to true");
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
                                            const Duration(
                                                seconds:
                                                    5), // <-- The debounce duration
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
                                    child: AspectRatio(
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
                                                          focusColor: Colors
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
                                                          focusColor: Colors
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
                                                          focusColor: Colors
                                                              .transparent,
                                                          minWidth: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            if (mounted) {
                                                              setState(() {
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
                                                          width: 10,
                                                        ),
                                                        //Fullscreen Button Normal PLayer
                                                        MaterialButton(
                                                          focusColor: Colors
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
                                                    focusColor:
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
                                  //Post Title
                                  Text(widget.postData['postTitle']),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //Video Data and Comments Normal
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Post SubchannelName
                                      Text(widget
                                          .postData['postSubchannelName']),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      //Post Username
                                      Text(widget.postData['username']),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //Post Published Date Time
                                  Text(widget
                                          .postData['postPublishedDateTime'] ??
                                      "published 15. October 2021"),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  //Post Description
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ConstrainedBox(
                                            constraints: isExpanded
                                                ? const BoxConstraints()
                                                : const BoxConstraints(
                                                    maxHeight: 50.0),
                                            child: Text(
                                              widget
                                                  .postData['postDescription'],
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                            )),
                                        isExpanded
                                            ? TextButton(
                                                child: const Text('show less'),
                                                onPressed: () => setState(
                                                    () => isExpanded = false))
                                            : TextButton(
                                                child: const Text('show more'),
                                                onPressed: () => setState(
                                                    () => isExpanded = true))
                                      ]),

                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const Text("Comments"),
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
                                  MouseRegion(
                                    onHover: (PointerHoverEvent event) {
                                      if (!_showMenu) {
                                        if (mounted) {
                                          setState(() {
                                            _showMenu = true;
                                            print("_showMenu set to true");
                                          });
                                        }

                                        Future.delayed(
                                            const Duration(seconds: 10), () {
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
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        print("tap");
                                        if (_controller.value.isPlaying) {
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
                                              children: [
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: SliderTheme(
                                                    data: const SliderThemeData(
                                                      //thumbColor: Colors.green,
                                                      thumbShape:
                                                          RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  7),
                                                      //showValueIndicator: ShowValueIndicator.never,
                                                    ),
                                                    child: Slider(
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
                                                  focusColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
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
                                                  focusColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
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
                                                      child: VideoProgressIndicator(
                                                          _controller,
                                                          colors: VideoProgressColors(
                                                              playedColor: Theme
                                                                      .of(
                                                                          context)
                                                                  .colorScheme
                                                                  .highlightColor,
                                                              bufferedColor: Theme
                                                                      .of(
                                                                          context)
                                                                  .colorScheme
                                                                  .videoPlayerIconBackgroundColor
                                                                  .withOpacity(
                                                                      0.6),
                                                              backgroundColor:
                                                                  Colors.grey),
                                                          allowScrubbing: true),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MaterialButton(
                                                  focusColor:
                                                      Colors.transparent,
                                                  minWidth: 0,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    if (!_isFullScreen) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _isFullScreen = true;
                                                          goFullScreen();
                                                        });
                                                      }
                                                    } else {
                                                      if (mounted) {
                                                        setState(() {
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
}
