import 'package:flutter/material.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudioPostsScreen extends StatefulWidget {
  const StudioPostsScreen(
      {Key? key, required this.postId, required this.firtTimeExternAccess})
      : super(key: key);

  final int postId;
  final bool firtTimeExternAccess;

  @override
  _StudioPostsState createState() => _StudioPostsState();
}

class _StudioPostsState extends State<StudioPostsScreen> {
  late int chosenPostId;

  //Get Post  Data by Id
  Future<Map<String, dynamic>> fetchUserPosts(int id) async {
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
    incrementPostViewsByOne(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: fetchUserPosts(widget.postId),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ResponsiveWidget(
                smallScreen: const Text("smallScreen"),
                mediumScreen: const Text("mediumScreen"),
                largeScreen: Material(
                  child: Row(
                    children: [],
                  ),
                ),
                veryLargeScreen: const Text("veryLargeScreen"),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
