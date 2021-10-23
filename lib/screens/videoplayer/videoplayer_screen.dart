import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/videoplayer/large/video_player_large_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:html' as html;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {Key? key, required this.postId, required this.firtTimeExternAccess})
      : super(key: key);

  final int postId;
  final bool firtTimeExternAccess;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  //Get Post  Data by Id
  Future<Map<String, dynamic>> fetchPostData(int id) async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/post/getPost/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        return map;
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    // if (!widget.firtTimeExternAccess) {
    //   html.window.history.replaceState(
    //       null, 'VideoPlayer', '#/whatch/' + widget.postId.toString());
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPostData(widget.postId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ResponsiveWidget(
              smallScreen: const Text("smallScreen"),
              mediumScreen: const Text("mediumScreen"),
              largeScreen: Material(
                // child: Stack(
                //   alignment: Alignment.topCenter,
                //   // children: [ChapterVideoPlayer(), const NavBarLargeProfile()],
                //   children: const [VideoPlayerHome(), NavBarLargeProfile()],
                // ),
                child: VideoPlayerHome(
                  postData: snapshot.data!,
                  firtTimeExternAccess: widget.firtTimeExternAccess,
                ),
              ),
              veryLargeScreen: const Text("veryLargeScreen"),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
