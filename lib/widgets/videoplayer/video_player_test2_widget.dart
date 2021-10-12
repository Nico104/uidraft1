import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({Key? key}) : super(key: key);
  // final bool externAccess = false;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
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

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
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

    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   //await _controller.setVolume(0);
    //   // _controller.play().then((value) {
    //   //   _controller.setVolume(0.5);
    //   // });
    //   _controller.play();

    //   // if (_controller.value.isPlaying && _controller.value.volume == 0) {
    //   //   print("volume0");
    //   //   _controller.setVolume(1);
    //   //   print("volume1");
    //   // }
    // });

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
    return Scaffold(
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            // _controller.play();
            // if (_controller.value.isPlaying) {
            //   _controller.pause();
            //   // print("paused");
            // } else {
            //   // If the video is paused, play it.
            //   _controller.play();
            //   // print("played");
            // }
            // _controller.setVolume(0.5);
            return SizedBox(
              width: 360,
              height: 480,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
