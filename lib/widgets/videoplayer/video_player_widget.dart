import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(ChapterVideoPlayer());

class ChapterVideoPlayer extends StatefulWidget {
  @override
  _ChapterVideoPlayerState createState() => _ChapterVideoPlayerState();
}

class _ChapterVideoPlayerState extends State<ChapterVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    print("ndn1");
    _controller = VideoPlayerController.network(
        // 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
        'http://techslides.com/demos/sample-videos/small.mp4')
      ..initialize().then((_) {
        print("initialized video");
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
      print("ndn");
      _controller!.play();
  }

  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(100),
          child: Center(
            child: _controller!.value.isInitialized
                ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller!),
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
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                    //showValueIndicator: ShowValueIndicator.never,
                                    ),
                                  child: Slider(
                                    value: _controller!.value.volume * 100,
                                    min: 0,
                                    max: 100,
                                    //divisions: 20,
                                    //label: (_controller!.value.volume * 100).round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _controller!.setVolume(value / 100);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          VideoProgressIndicator(_controller!, colors: const VideoProgressColors(playedColor: Colors.red, bufferedColor: Colors.purple, backgroundColor: Colors.green),
                          allowScrubbing: true),
                           FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _controller!.value.playbackSpeed == 1
                                    ? _controller!.setPlaybackSpeed(4)
                                    : _controller!.setPlaybackSpeed(1);
                              });
                            },
                            child: Icon(
                              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                //: Container(child: const Text("controller not initialized"),),
                : const CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
              
            });
          },
          child: Icon(
            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}