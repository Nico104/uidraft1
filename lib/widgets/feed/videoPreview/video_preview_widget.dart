import 'dart:convert';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

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
            // return Card(
            //   clipBehavior: Clip.antiAliasWithSaveLayer,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   color: Theme.of(context).canvasColor,
            //   child: Column(
            //     children: [
            //       Image.network(
            //           "http://localhost:3000/${snapshot.data!['postTumbnailPath']}"),
            //       Text(snapshot.data!['postTitle']),
            //     ],
            //   ),
            // );
            return Column(
              children: [
                //Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    "http://localhost:3000/${snapshot.data!['postTumbnailPath']}",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                //Data Preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 3,
                    ),
                    //Profile Pictrue / Subchannel Profile Picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.network(
                        "https://picsum.photos/700",
                        fit: BoxFit.contain,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    //Metrics
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            //Title
                            Text(
                              snapshot.data!['postTitle'],
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPreviewTextColor,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   width: 6,
                            // ),
                            //User PB
                            Icon(
                              Icons.person_outline_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .videoPreviewTextColor,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            //Username
                            Text("username"),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            );
          } else {
            return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Theme.of(context).canvasColor,
                child: const Text("loading"));
          }
        });
  }
}
