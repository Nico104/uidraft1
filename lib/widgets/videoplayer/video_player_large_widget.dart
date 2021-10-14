import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:html';

void goFullScreen() {
  document.documentElement!.requestFullscreen();
}

void exitFullScreen() {
  document.exitFullscreen();
}

void main() => runApp(const VideoPlayerHome());

//Latest Player
class VideoPlayerHome extends StatelessWidget {
  const VideoPlayerHome({Key? key}) : super(key: key);
  // final bool externAccess = false;

  @override
  Widget build(BuildContext context) {
    return const VideoPlayerScreen();
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  final bool externAccess = false;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isFullScreen = false;
  bool _showMenu = false;
  bool _onHoverStop = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      // 'http://localhost:3000/post/video',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      if (!widget.externAccess) {
        _controller.play();
      }
      //_controller.play();
    });

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Row(
          children: [
            SizedBox(width: _isFullScreen ? 0 : 40),
            Flexible(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return !_isFullScreen
                        ?
                        //Normal Player
                        ListView(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              MouseRegion(
                                //On Player Exit
                                onExit: (PointerExitEvent event) {
                                  if (_showMenu) {
                                    setState(() {
                                      _showMenu = false;
                                      print("_showMenu set to false");
                                    });
                                  }
                                },
                                onEnter: (PointerEnterEvent event) {
                                  if (!_showMenu) {
                                    setState(() {
                                      _showMenu = true;
                                      print("_showMenu set to true");
                                    });
                                  }
                                  Future.delayed(const Duration(seconds: 10),
                                      () {
                                    if (_showMenu) {
                                      setState(() {
                                        _showMenu = false;
                                        print("_showMenu set to false");
                                      });
                                    }
                                  });
                                },
                                onHover: (PointerHoverEvent event) {
                                  if (!_showMenu) {
                                    setState(() {
                                      _onHoverStop = false;
                                      _showMenu = true;
                                      print("_showMenu set to true");
                                    });
                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      if (_showMenu) {
                                        setState(() {
                                          _showMenu = false;
                                          print("_showMenu set to false");
                                        });
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: 1415,
                                  height: 796,
                                  alignment: Alignment.center,
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    // Use the VideoPlayer widget to display the video.
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            print("tap");
                                            if (_controller.value.isPlaying) {
                                              setState(() {
                                                _controller.pause();
                                                print("paused");
                                              });
                                            } else {
                                              // If the video is paused, play it.
                                              setState(() {
                                                _controller.play();
                                                print("playing");
                                              });
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
                                            // (true)
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
                                                          data:
                                                              const SliderThemeData(
                                                            //thumbColor: Colors.green,
                                                            thumbShape:
                                                                RoundSliderThumbShape(
                                                                    enabledThumbRadius:
                                                                        7),
                                                            //showValueIndicator: ShowValueIndicator.never,
                                                          ),
                                                          child: Slider(
                                                            value: _controller
                                                                    .value
                                                                    .volume *
                                                                100,
                                                            min: 0,
                                                            max: 100,
                                                            //divisions: 20,
                                                            //label: (_controller!.value.volume * 100).round().toString(),
                                                            onChanged:
                                                                (double value) {
                                                              setState(() {
                                                                _controller
                                                                    .setVolume(
                                                                        value /
                                                                            100);
                                                              });
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
                                                        focusColor:
                                                            Colors.transparent,
                                                        minWidth: 0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        onPressed: () {
                                                          if (_controller.value
                                                              .isPlaying) {
                                                            setState(() {
                                                              _controller
                                                                  .pause();
                                                              print("paused");
                                                            });
                                                          } else {
                                                            // If the video is paused, play it.
                                                            setState(() {
                                                              _controller
                                                                  .play();
                                                              print("playing");
                                                            });
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
                                                                      .all(4.0),
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
                                                        focusColor:
                                                            Colors.transparent,
                                                        minWidth: 0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        onPressed: () {
                                                          if (_controller.value
                                                              .isPlaying) {
                                                            setState(() {
                                                              _controller
                                                                  .pause();
                                                              print("paused");
                                                            });
                                                          } else {
                                                            // If the video is paused, play it.
                                                            setState(() {
                                                              _controller
                                                                  .play();
                                                              print("playing");
                                                            });
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
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
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
                                                            child: VideoProgressIndicator(
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
                                                                    true),
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
                                                            const EdgeInsets
                                                                .all(0),
                                                        onPressed: () {
                                                          if (!_isFullScreen) {
                                                            setState(() {
                                                              _isFullScreen =
                                                                  true;
                                                              goFullScreen();
                                                            });
                                                          } else {
                                                            setState(() {
                                                              _isFullScreen =
                                                                  false;
                                                              exitFullScreen();
                                                            });
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
                                                                      .all(2.0),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              //Video Data and Comments
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
                                    setState(() {
                                      _onHoverStop = false;
                                      _showMenu = true;
                                      print("_showMenu set to true");
                                    });
                                    Future.delayed(const Duration(seconds: 10),
                                        () {
                                      if (_showMenu) {
                                        setState(() {
                                          _showMenu = false;
                                          print("_showMenu set to false");
                                        });
                                      }
                                    });
                                  }
                                },
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    print("tap");
                                    if (_controller.value.isPlaying) {
                                      setState(() {
                                        _controller.pause();
                                        print("paused");
                                      });
                                    } else {
                                      // If the video is paused, play it.
                                      setState(() {
                                        _controller.play();
                                        print("playing");
                                      });
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
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                  value:
                                                      _controller.value.volume *
                                                          100,
                                                  min: 0,
                                                  max: 100,
                                                  //divisions: 20,
                                                  //label: (_controller!.value.volume * 100).round().toString(),
                                                  onChanged: (double value) {
                                                    setState(() {
                                                      _controller.setVolume(
                                                          value / 100);
                                                    });
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
                                              focusColor: Colors.transparent,
                                              minWidth: 0,
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                if (_controller
                                                    .value.isPlaying) {
                                                  setState(() {
                                                    _controller.pause();
                                                    print("paused");
                                                  });
                                                } else {
                                                  // If the video is paused, play it.
                                                  setState(() {
                                                    _controller.play();
                                                    print("playing");
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .videoPlayerIconBackgroundColor
                                                        .withOpacity(0.6),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      _controller
                                                              .value.isPlaying
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
                                              focusColor: Colors.transparent,
                                              minWidth: 0,
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                if (_controller
                                                    .value.isPlaying) {
                                                  setState(() {
                                                    _controller.pause();
                                                    print("paused");
                                                  });
                                                } else {
                                                  // If the video is paused, play it.
                                                  setState(() {
                                                    _controller.play();
                                                    print("playing");
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .videoPlayerIconBackgroundColor
                                                        .withOpacity(0.6),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
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
                                            Flexible(
                                              child: SizedBox(
                                                height: 15,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  28),
                                                          topRight:
                                                              Radius.circular(
                                                                  28),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12)),
                                                  child: VideoProgressIndicator(
                                                      _controller,
                                                      colors: VideoProgressColors(
                                                          playedColor: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .highlightColor,
                                                          bufferedColor: Theme
                                                                  .of(context)
                                                              .colorScheme
                                                              .videoPlayerIconBackgroundColor
                                                              .withOpacity(0.6),
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
                                              focusColor: Colors.transparent,
                                              minWidth: 0,
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                if (!_isFullScreen) {
                                                  setState(() {
                                                    _isFullScreen = true;
                                                    goFullScreen();
                                                  });
                                                } else {
                                                  setState(() {
                                                    _isFullScreen = false;
                                                    exitFullScreen();
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .videoPlayerIconBackgroundColor
                                                        .withOpacity(0.6),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
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
                            ],
                          );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SizedBox(width: _isFullScreen ? 0 : 30),
            Container(
              color: Colors.purple,
              width: 500,
              height: 100,
            ),
            SizedBox(width: _isFullScreen ? 0 : 20),
          ],
        ),
        !_isFullScreen
            ? const NavBarLargeProfile()
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }
}
