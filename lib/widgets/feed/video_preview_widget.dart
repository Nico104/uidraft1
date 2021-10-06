import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoPreview extends StatefulWidget {
  final int postId;

  const VideoPreview({Key? key, required this.postId}) : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  //Get PostPreview Data by Id
  Future<Map<String, dynamic>> fetchPostPreviewData(int id) async {
    print("In Preview 2");
    final response = await http
        .get(Uri.parse('http://localhost:3000/post/getPostPreviewData/$id'));

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPostPreviewData(widget.postId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.pinkAccent,
              child: Column(
                children: [
                  Image.network(
                      "http://localhost:3000/${snapshot.data!['postTumbnailPath']}"),
                  Text(snapshot.data!['postTitle']),
                ],
              ),
            );
          } else {
            return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.pinkAccent,
                child: const Text("loading"));
          }
        });
  }
}
