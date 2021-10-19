import 'dart:convert';
import 'dart:typed_data';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadVideoFeedPreview extends StatelessWidget {
  final String postTitle;
  final String postSubchannel;
  final String postUsername;
  final Uint8List? thumbnailPreview;

  const UploadVideoFeedPreview(
      {Key? key,
      required this.postTitle,
      required this.postSubchannel,
      required this.postUsername,
      required this.thumbnailPreview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: thumbnailPreview != null
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.memory(
                    thumbnailPreview!,
                    fit: BoxFit.fill,
                  ),
                )
              : Image.network(
                  "http://localhost:3000/uploads/default/defaultUploadVideoThumbnailPreview.png",
                  fit: BoxFit.contain,
                ),
        ),
        const SizedBox(
          height: 18,
        ),
        //Data Preview
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: Row(
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
                      //UserProfilePicture
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          //Title
                          Container(
                            width: 320,
                            child: Text(
                              postTitle,
                              //overflow: TextOverflow.fade,
                              //softWrap: false,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPreviewTextColor,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      //User and Subchannel Information
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //User Person icon
                          Icon(
                            Icons.person_outline_outlined,
                            color:
                                Theme.of(context).colorScheme.navBarIconColor,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          //Username
                          Text(postUsername),
                          const SizedBox(
                            width: 10,
                          ),
                          //Dot in the middle
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).colorScheme.navBarIconColor,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Subchannel icon
                          Icon(
                            Icons.smart_display_outlined,
                            color:
                                Theme.of(context).colorScheme.navBarIconColor,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          //Subchannelname
                          Text(postSubchannel),
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      //Metrics
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Score - trending icon
                          Icon(
                            Icons.trending_up_outlined,
                            color:
                                Theme.of(context).colorScheme.navBarIconColor,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          //Score
                          Text("699"),
                          const SizedBox(
                            width: 10,
                          ),
                          //Dot in the middle
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).colorScheme.navBarIconColor,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Comments Icon
                          Icon(
                            Icons.mode_comment_outlined,
                            color:
                                Theme.of(context).colorScheme.navBarIconColor,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          //Comment Count
                          Text("304"),
                          const SizedBox(
                            width: 10,
                          ),
                          //Dot in the middle
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).colorScheme.navBarIconColor,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Views Icon
                          Icon(
                            Icons.visibility_outlined,
                            color:
                                Theme.of(context).colorScheme.navBarIconColor,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          //Views
                          Text("42044"),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}

// class _VideoPreviewState extends State<VideoPreview> {
//   //Get PostPreview Data by Id
//   Future<Map<String, dynamic>> fetchPostPreviewData(int id) async {
//     print("In Preview 2");
//     final response = await http
//         .get(Uri.parse('http://localhost:3000/post/getPostPreviewData/$id'));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = json.decode(response.body);
//       if (map.isNotEmpty) {
//         return map;
//       } else {
//         throw Exception('Failed to load post');
//       }
//     } else {
//       // If that call was not successful, throw an error.
//       throw Exception('Failed to load post');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: fetchPostPreviewData(widget.postId),
//         builder: (BuildContext context,
//             AsyncSnapshot<Map<String, dynamic>> snapshot) {
//           if (snapshot.hasData) {
//             // return Card(
//             //   clipBehavior: Clip.antiAliasWithSaveLayer,
//             //   shape: RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.circular(8.0),
//             //   ),
//             //   color: Theme.of(context).canvasColor,
//             //   child: Column(
//             //     children: [
//             //       Image.network(
//             //           "http://localhost:3000/${snapshot.data!['postTumbnailPath']}"),
//             //       Text(snapshot.data!['postTitle']),
//             //     ],
//             //   ),
//             // );
//             return Column(
//               children: [
//                 //Thumbnail
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12.0),
//                   child: Image.network(
//                     "http://localhost:3000/${snapshot.data!['postTumbnailPath']}",
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 18,
//                 ),
//                 //Data Preview
//                 LayoutBuilder(builder:
//                     (BuildContext context, BoxConstraints constraints) {
//                   return SizedBox(
//                     width: constraints.maxWidth,
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       alignment: Alignment.topLeft,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             width: 3,
//                           ),
//                           //Profile Pictrue / Subchannel Profile Picture
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(14.0),
//                             child: Image.network(
//                               "https://picsum.photos/700",
//                               fit: BoxFit.contain,
//                               width: 40,
//                               height: 40,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           //Metrics
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(
//                                     width: 2,
//                                   ),
//                                   //Title
//                                   Container(
//                                     width: 320,
//                                     child: Text(
//                                       widget.postId.isOdd
//                                           ? 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which dont look even slightly believable.' +
//                                               snapshot.data!['postTitle']
//                                           : snapshot.data!['postTitle'],
//                                       //overflow: TextOverflow.fade,
//                                       //softWrap: false,
//                                       maxLines: 2,
//                                       style: TextStyle(
//                                           fontFamily: 'Segoe UI',
//                                           fontSize: 17,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .videoPreviewTextColor,
//                                           letterSpacing: 1),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 7,
//                               ),
//                               //User and Subchannel Information
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   //User Person icon
//                                   Icon(
//                                     Icons.person_outline_outlined,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .navBarIconColor,
//                                     size: 17,
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   //Username
//                                   Text("username"),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   //Dot in the middle
//                                   Container(
//                                     width: 5,
//                                     height: 5,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .navBarIconColor,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   //Subchannel icon
//                                   Icon(
//                                     Icons.smart_display_outlined,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .navBarIconColor,
//                                     size: 17,
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   //Subchannelname
//                                   Text("c/CoolSamuraiStuff"),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 7,
//                               ),
//                               //Metrics
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   //Score - trending icon
//                                   Icon(
//                                     Icons.trending_up_outlined,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .navBarIconColor,
//                                     size: 17,
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   //Score
//                                   Text("699"),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   //Dot in the middle
//                                   Container(
//                                     width: 5,
//                                     height: 5,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .navBarIconColor,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   //Comments Icon
//                                   Icon(
//                                     Icons.mode_comment_outlined,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .navBarIconColor,
//                                     size: 17,
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   //Comment Count
//                                   Text("304"),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   //Dot in the middle
//                                   Container(
//                                     width: 5,
//                                     height: 5,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .navBarIconColor,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   //Views Icon
//                                   Icon(
//                                     Icons.visibility_outlined,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .navBarIconColor,
//                                     size: 17,
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   //Views
//                                   Text("42044"),
//                                 ],
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 })
//               ],
//             );
//           } else {
//             return Card(
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 color: Theme.of(context).canvasColor,
//                 child: const Text("loading"));
//           }
//         });
//   }
// }