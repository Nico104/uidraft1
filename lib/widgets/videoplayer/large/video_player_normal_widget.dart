import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:video_player/video_player.dart';
import 'dart:html';

class VideoPlayerNormalLarge extends StatefulWidget {
  const VideoPlayerNormalLarge(
      {Key? key, required this.postData, required this.firtTimeExternAccess})
      : super(key: key);

  final Map<String, dynamic> postData;
  final bool firtTimeExternAccess;

  @override
  _VideoPlayerNormalLargeState createState() => _VideoPlayerNormalLargeState();
}

class _VideoPlayerNormalLargeState extends State<VideoPlayerNormalLarge> {
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
    return VideoPlayerKeyboardListener(
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //VideoPlayer Normal
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
                    _showQuality = false;
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
            },
            child: IgnorePointer(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: VideoPlayer(_controller)),
            ),
          ),
          _showMenu
              //VideoPlayerMenu Normal
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _showQuality
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .videoPlayerIconBackgroundColor
                                        .withOpacity(0.6)),
                                child: Column(
                                    //Generate Quality Menu
                                    children: List.generate(
                                        streamQualityKeysSorted.length,
                                        (index) {
                                  return Container(
                                    color: streamQualityKeysSorted
                                                .elementAt(index) ==
                                            activeQualityStream
                                        ? Theme.of(context)
                                            .colorScheme
                                            .brandColor
                                        : Colors.transparent,
                                    child: TextButton(
                                        onPressed: () {
                                          if (mounted) {
                                            setState(() {
                                              _firtTimeExternAccess = false;
                                              activeQualityStream =
                                                  streamQualityKeysSorted
                                                      .elementAt(index);
                                              _initializePlay(
                                                  streamQualityURL[
                                                      activeQualityStream]!,
                                                  _controller.value.position);
                                              _showMenu = false;
                                              _showQuality = false;
                                            });
                                          }
                                        },
                                        child: Text(streamQualityKeysSorted
                                                .elementAt(index)
                                                .toString() +
                                            'p')),
                                  );
                                })),
                              )
                            : const SizedBox(),
                        RotatedBox(
                          quarterTurns: 3,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor:
                                  Theme.of(context).colorScheme.highlightColor,
                              inactiveTrackColor: Theme.of(context)
                                  .colorScheme
                                  .videoPlayerIconBackgroundColor
                                  .withOpacity(0.6),
                              // trackShape: RectangularSliderTrackShape(),
                              trackHeight: 10,
                              thumbColor:
                                  Theme.of(context).colorScheme.highlightColor,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7,
                                  elevation: 0,
                                  pressedElevation: 0,
                                  disabledThumbRadius: 7),

                              overlayColor: Colors.transparent,
                              // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                            ),
                            child: Slider(
                              mouseCursor: SystemMouseCursors.resizeUpDown,

                              value: _controller.value.volume * 100,
                              min: 0,
                              max: 100,
                              //divisions: 20,
                              //label: (_controller!.value.volume * 100).round().toString(),
                              onChanged: (double value) {
                                if (mounted) {
                                  setState(() {
                                    _controller.setVolume(value / 100);
                                  });
                                }

                                if (!_showMenu) {
                                  if (mounted) {
                                    setState(() {
                                      _showMenu = true;
                                      print("_showMenu set to true");
                                    });
                                  }

                                  Future.delayed(const Duration(seconds: 5),
                                      () {
                                    if (_showMenu) {
                                      if (mounted) {
                                        setState(() {
                                          _showMenu = false;
                                          print("_showMenu set to false");
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        MaterialButton(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          minWidth: 0,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            _firtTimeExternAccess = false;
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
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .colorScheme
                                    .videoPlayerIconBackgroundColor
                                    .withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 32,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .highlightColor,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        MaterialButton(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          minWidth: 0,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
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
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .colorScheme
                                    .videoPlayerIconBackgroundColor
                                    .withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.skip_next,
                                  size: 24,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .highlightColor,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Video Position
                        Text(_controller.value.position.inSeconds.toString()),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 15,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              child: VideoProgressIndicator(
                                _controller,
                                colors: VideoProgressColors(
                                    playedColor: Theme.of(context)
                                        .colorScheme
                                        .highlightColor,
                                    bufferedColor: Theme.of(context)
                                        .colorScheme
                                        .videoPlayerIconBackgroundColor
                                        .withOpacity(0.6),
                                    backgroundColor: Colors.grey),
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
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          minWidth: 0,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _firtTimeExternAccess = false;
                                _showQuality = !_showQuality;
                                _showMenu = true;
                              });
                            }

                            EasyDebounce.debounce(
                                'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                const Duration(
                                    seconds: 5), // <-- The debounce duration
                                () {
                              if (_showMenu) {
                                if (mounted) {
                                  setState(() {
                                    _firtTimeExternAccess = false;
                                    _showMenu = false;
                                    _showQuality = false;
                                    print("_showMenu set to false");
                                  });
                                }
                              }
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .colorScheme
                                    .videoPlayerIconBackgroundColor
                                    .withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.settings,
                                  size: 28,
                                  color: Theme.of(context)
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
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          minWidth: 0,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            if (!_isFullScreen) {
                              if (mounted) {
                                setState(() {
                                  _isFullScreen = true;
                                  // goFullScreen();
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  _isFullScreen = false;
                                  // exitFullScreen();
                                });
                              }
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .colorScheme
                                    .videoPlayerIconBackgroundColor
                                    .withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.fullscreen,
                                  size: 32,
                                  color: Theme.of(context)
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
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      _firtTimeExternAccess = false;
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
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context)
                              .colorScheme
                              .videoPlayerIconBackgroundColor
                              .withOpacity(0.6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.play_arrow,
                            size: 128,
                            color: Theme.of(context).colorScheme.highlightColor,
                          ),
                        )),
                  ),
                )
              : const SizedBox(),
        ],
      ),
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
                // exitFullScreen();
                setState(() {
                  _isFullScreen = false;
                });
              } else {
                // goFullScreen();
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
                // exitFullScreen();
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
