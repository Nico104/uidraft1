import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'http://localhost:3000/post/video',
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
                        Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: MouseRegion(
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
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: VideoPlayer(_controller)),
                                      Column(
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
                                          VideoProgressIndicator(_controller,
                                              colors: const VideoProgressColors(
                                                  playedColor: Colors.red,
                                                  bufferedColor: Colors.purple,
                                                  backgroundColor:
                                                      Colors.green),
                                              allowScrubbing: true),
                                          FloatingActionButton(
                                            onPressed: () {
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
                                            child: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                          ),
                                          FloatingActionButton(
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
                                            child: Icon(
                                              _isFullScreen
                                                  ? Icons.fullscreen
                                                  : Icons.fullscreen_exit,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        :
                        //FullScreen
                        Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      // width: _controller.value.size.width,
                                      // height: _controller.value.size.height,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: SliderTheme(
                                          data: const SliderThemeData(
                                            //thumbColor: Colors.green,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 7),
                                            //showValueIndicator: ShowValueIndicator.never,
                                          ),
                                          child: Slider(
                                            value:
                                                _controller.value.volume * 100,
                                            min: 0,
                                            max: 100,
                                            //divisions: 20,
                                            //label: (_controller!.value.volume * 100).round().toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                _controller
                                                    .setVolume(value / 100);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  VideoProgressIndicator(_controller,
                                      colors: const VideoProgressColors(
                                          playedColor: Colors.red,
                                          bufferedColor: Colors.purple,
                                          backgroundColor: Colors.green),
                                      allowScrubbing: true),
                                  FloatingActionButton(
                                    onPressed: () {
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
                                    child: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                  FloatingActionButton(
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
                                    child: Icon(
                                      _isFullScreen
                                          ? Icons.fullscreen
                                          : Icons.fullscreen_exit,
                                    ),
                                  ),
                                ],
                              ),
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
