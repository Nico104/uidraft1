import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/studio/studio_util_methods.dart' as studioUtils;
import 'package:uidraft1/utils/util_methods.dart';
import 'package:uidraft1/widgets/tag/tag_grid_widget.dart';
import 'dart:html' as html;
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:http/http.dart' as http;

class StudioPostMetrics extends StatefulWidget {
  final int postId;

  const StudioPostMetrics({Key? key, required this.postId}) : super(key: key);

  @override
  State<StudioPostMetrics> createState() => _StudioPostMetricsState();
}

class _StudioPostMetricsState extends State<StudioPostMetrics> {
  // late Future<Map<String, dynamic>> future;

  final _postTitleTextController = TextEditingController();
  final _postDescriptionTextController = TextEditingController();

  Uint8List? thumbnailPreview;
  FilePickerResult? result;
  late DropzoneViewController controller;

  List<String> tagList = [];

  final Map<String, bool> _formError = {
    "title": false,
    "thumbnail": false,
    "tag": false,
    "subchannel": false
  };

  @override
  void dispose() {
    _postTitleTextController.dispose();
    _postDescriptionTextController.dispose();
    // _debounce.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // future = studioUtils.fetchPostStudioMetrics(widget.postId).then((value) {
    //   initTagList(value['tags']);
    //   _postTitleTextController.text = value['postTitle'];
    //   _postDescriptionTextController.text = value['postDescription'];
    //   return value;
    // });
    super.initState();
  }

  void initTagList(List<dynamic> tagsJson) {
    for (var element in tagsJson) {
      print("Tag: " + element['tagName']);
      tagList.add(element['tagName']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future: studioUtils
              .fetchPostStudioMetrics(
                  widget.postId, connection.returnConnection())
              .then((value) {
            initTagList(value['tags']);
            _postTitleTextController.text = value['postTitle'];
            _postDescriptionTextController.text = value['postDescription'];
            return value;
          }),
          // future: future,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              _postTitleTextController.text = snapshot.data!['postTitle'];
              _postDescriptionTextController.text =
                  snapshot.data!['postDescription'];
              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Edit
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[800],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Title and Description
                                  Flexible(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          //Update Überschrift
                                          const Text(
                                            "Update Video Stuff",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          //Title
                                          TextFormField(
                                            controller:
                                                _postTitleTextController,
                                            maxLength: 70,
                                            cursorColor: Colors.white,
                                            autocorrect: false,
                                            decoration: InputDecoration(
                                              labelText: "Title...",
                                              labelStyle: const TextStyle(
                                                  fontFamily: "Segoe UI",
                                                  color: Colors.white),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.pink),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Title cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                            style: const TextStyle(
                                                fontFamily: "Segoe UI",
                                                color: Colors.white),
                                          ),
                                          //ShowError
                                          !_formError['title']!
                                              ? const SizedBox()
                                              : const SizedBox(
                                                  height: 10,
                                                ),
                                          !_formError['title']!
                                              ? const SizedBox()
                                              : const Text(
                                                  "Title cannot be empty",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                          //ShowErrorFinished
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          //Description
                                          TextFormField(
                                            controller:
                                                _postDescriptionTextController,
                                            // enableSuggestions: false,
                                            cursorColor: Colors.white,
                                            autocorrect: false,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLength: 512,
                                            minLines: 1,
                                            maxLines: 15,
                                            decoration: InputDecoration(
                                              labelText: "Description...",
                                              labelStyle: const TextStyle(
                                                  fontFamily: "Segoe UI",
                                                  color: Colors.white),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.pink),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Field cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            style: const TextStyle(
                                                fontFamily: "Segoe UI",
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.transparent,
                                      )),
                                  //Thumbnail and Tags
                                  Flexible(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          //Thumbnail Dropzone
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            // height: 150,
                                            child: InkWell(
                                              onTap: () async {
                                                result = await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                        type: FileType.image,
                                                        allowMultiple: false);

                                                setState(() {
                                                  thumbnailPreview =
                                                      result!.files.first.bytes;
                                                });
                                              },
                                              child: Stack(
                                                children: [
                                                  IgnorePointer(
                                                    child: DropzoneView(
                                                      mime: const [
                                                        "image/png",
                                                        "image/jpeg"
                                                      ],
                                                      operation:
                                                          DragOperation.copy,
                                                      cursor: CursorType.grab,
                                                      onCreated:
                                                          (DropzoneViewController
                                                                  ctrl) =>
                                                              controller = ctrl,
                                                      onLoaded: () =>
                                                          print('Zone loaded'),
                                                      onError: (String? ev) =>
                                                          print('Error: $ev'),
                                                      onHover: () =>
                                                          print('Zone hovered'),
                                                      onDrop:
                                                          (dynamic ev) async {
                                                        setState(() {
                                                          print("Dropped: $ev");
                                                        });
                                                        if (ev != null) {
                                                          print("FileName: " +
                                                              await controller
                                                                  .getFilename(
                                                                      ev));
                                                          thumbnailPreview =
                                                              await controller
                                                                  .getFileData(
                                                                      ev);
                                                          setState(() {
                                                            print("weiter");
                                                          });
                                                        }
                                                      },
                                                      onLeave: () =>
                                                          print('Zone left'),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child: AspectRatio(
                                                          aspectRatio: 16 / 9,
                                                          child:
                                                              thumbnailPreview !=
                                                                      null
                                                                  ? Image
                                                                      .memory(
                                                                      thumbnailPreview!,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      baseURL +
                                                                          snapshot
                                                                              .data!['postTumbnailPath'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //ShowError
                                          !_formError['thumbnail']!
                                              ? const SizedBox()
                                              : const SizedBox(
                                                  height: 10,
                                                ),
                                          !_formError['thumbnail']!
                                              ? const SizedBox()
                                              : const Text(
                                                  "Thumbnail cannot be empty",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                          //ShowErrorFinished
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          //Tags
                                          Wrap(
                                            runSpacing: 5,
                                            spacing: 5,
                                            children: _getVideoTagWidgets(
                                                tagList,
                                                connection.returnConnection()),
                                          ),
                                          //ShowError
                                          !_formError['tag']!
                                              ? const SizedBox()
                                              : const SizedBox(
                                                  height: 10,
                                                ),
                                          !_formError['tag']!
                                              ? const SizedBox()
                                              : const Text(
                                                  "Tags cannot be empty",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                          //ShowErrorFinished
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.resolveWith(
                                          (states) {
                                        Color _borderColor;
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          _borderColor = Colors.white;
                                        } else if (states
                                            .contains(MaterialState.hovered)) {
                                          _borderColor = Theme.of(context)
                                              .colorScheme
                                              .brandColor;
                                        } else {
                                          _borderColor = Colors.black;
                                        }

                                        return BorderSide(
                                            color: _borderColor, width: 3);
                                      }),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0))),
                                    ),
                                    onPressed: () {
                                      // print("delete");
                                      // studioUtils.deletePost(widget.postId).then(
                                      //     (value) =>
                                      //         html.window.location.reload());
                                      showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const DeleteConfirmDialog())
                                          .then((value) => {
                                                if (value == "delete")
                                                  {
                                                    studioUtils
                                                        .deletePost(
                                                            widget.postId,
                                                            connection
                                                                .returnConnection())
                                                        .then((value) => html
                                                            .window.location
                                                            .reload())
                                                  }
                                              });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Delete Post",
                                        style: TextStyle(
                                            fontFamily: 'Sogeo UI',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  //Archive/Unarchive
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        style: ButtonStyle(
                                          side:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            Color _borderColor;
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              _borderColor = Colors.white;
                                            } else if (states.contains(
                                                MaterialState.hovered)) {
                                              _borderColor = Theme.of(context)
                                                  .colorScheme
                                                  .brandColor;
                                            } else {
                                              _borderColor = Colors.black;
                                            }

                                            return BorderSide(
                                                color: _borderColor, width: 3);
                                          }),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0))),
                                        ),
                                        onPressed: () {
                                          print(snapshot.data!['isPublished']);
                                          studioUtils
                                              .updatePostPublicity(
                                                  widget.postId,
                                                  snapshot.data!['isPublished'],
                                                  connection.returnConnection())
                                              .then((value) => setState(() {}));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data!['isPublished']
                                                ? "Archive"
                                                : "Unarchhive",
                                            style: const TextStyle(
                                                fontFamily: 'Sogeo UI',
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 28,
                                      ),
                                      //Save Changes
                                      OutlinedButton(
                                        style: ButtonStyle(
                                          side:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            Color _borderColor;
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              _borderColor = Colors.white;
                                            } else if (states.contains(
                                                MaterialState.hovered)) {
                                              _borderColor = Theme.of(context)
                                                  .colorScheme
                                                  .brandColor;
                                            } else {
                                              _borderColor = Colors.black;
                                            }

                                            return BorderSide(
                                                color: _borderColor, width: 3);
                                          }),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0))),
                                        ),
                                        onPressed: () {
                                          print("pressed Submit");
                                          validateForm()
                                              ? setState(() {
                                                  // print("submit");
                                                  studioUtils.updatePostData(
                                                      widget.postId,
                                                      _postTitleTextController
                                                          .text,
                                                      _postDescriptionTextController
                                                          .text,
                                                      connection
                                                          .returnConnection());
                                                })
                                              : setState(() {
                                                  print("form has error");
                                                });
                                          print("Thumnbnail Preview: " +
                                              (thumbnailPreview != null)
                                                  .toString());
                                          if (thumbnailPreview != null) {
                                            studioUtils.updatePostThumbnail(
                                                widget.postId,
                                                thumbnailPreview!);
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Save Changes",
                                            style: TextStyle(
                                                fontFamily: 'Sogeo UI',
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      //Divider
                      const SizedBox(
                        height: 16,
                      ),
                      //Metrics
                      Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              //Post Views
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!['_count']
                                                ['postWhatchtimeAnalytics']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Views",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Post Rating
                              FutureBuilder(
                                  future: Future.wait([
                                    getPostRatingData(widget.postId, 'like',
                                        connection.returnConnection()),
                                    getPostRatingData(widget.postId, 'dislike',
                                        connection.returnConnection())
                                  ]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<int>> snapshotRating) {
                                    if (snapshotRating.hasData) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[800],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.thumb_up,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    snapshotRating.data![0]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  const Icon(
                                                    Icons.thumb_down,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    snapshotRating.data![1]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Rating",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Segoe UI',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .navBarIconColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                              //post Tags
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!['_count']
                                                ['postWhatchtimeAnalytics']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Tags",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //post CommentCount
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!['_count']['comments']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Comments",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Post Avergae Whatchtime - Absolut Whatchtime
                              FutureBuilder(
                                  future: studioUtils.getPostAbsoluteWhatchtime(
                                      widget.postId,
                                      connection.returnConnection()),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshotWhatchtime) {
                                    if (snapshotWhatchtime.hasData) {
                                      double avgWt = snapshotWhatchtime.data! /
                                          snapshot.data!['_count']
                                              ['postWhatchtimeAnalytics'];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[800],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              //Averege Whatchtime
                                              Row(
                                                children: [
                                                  const Text(
                                                      "Averege Whatchtime: "),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    avgWt.toStringAsFixed(2),
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              //Absolute Whatchtime
                                              Row(
                                                children: [
                                                  const Text(
                                                      "Absolute Whatchtime: "),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    snapshotWhatchtime.data
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Whatchtime",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Segoe UI',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .navBarIconColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                              //NSFW Tag
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!['nsfwTag'],
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "NSFW Tag",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Title Lenght
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Title is " +
                                            snapshot.data!['postTitle']
                                                .toString()
                                                .length
                                                .toString() +
                                            " characters long",
                                        style: const TextStyle(fontSize: 26),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Title Lenght",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Description Lenght
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Description is " +
                                            snapshot.data!['postDescription']
                                                .toString()
                                                .length
                                                .toString() +
                                            " characters long",
                                        style: const TextStyle(fontSize: 26),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Description Lenght",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Post Subchannel - name, pic, membercount, tags
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(14)),
                                        child: Image.network(
                                          baseURL +
                                              snapshot.data!['postSubchannel']
                                                      ['subchannelPreview'][
                                                  'subchannelSubchannelPicturePath'],
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          width: 57,
                                          height: 57,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "c/" +
                                                snapshot.data!['postSubchannel']
                                                        ['subchannelName']
                                                    .toString(),
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "- " +
                                                snapshot.data!['postSubchannel']
                                                        ['_count']
                                                        ['subchannelMembers']
                                                    .toString() +
                                                " Members",
                                            style:
                                                const TextStyle(fontSize: 23),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      //Tags
                                      Text(
                                        "Subchannel",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Segoe UI',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          });
    });
  }

  //Get Video Tag Widgets
  List<Widget> _getVideoTagWidgets(List<String> list, http.Client client) {
    List<Widget> widgetList = List.generate(tagList.length, (index) {
      return Chip(
        label: Text(
          capitalizeOnlyFirstLater(tagList.elementAt(index)),
          style: const TextStyle(fontFamily: "Segoe UI", fontSize: 16),
        ),
        onDeleted: () {
          studioUtils
              .removePostTag(widget.postId, tagList.elementAt(index), client)
              .then((_) {
            setState(() {
              print("onDelete");
              tagList.removeAt(index);
            });
          });
        },
      );
    });

    if (list.length < 3) {
      widgetList.add(InkWell(
        onTap: () {
          print('openTagMenu');
          showDialog(
            context: context,
            builder: (context) => const TagGridLargeScreen(),
          ).then((value) {
            if (!tagList.contains(value.toString()) && value != null) {
              studioUtils
                  .addPostTag(widget.postId, value.toString(), client)
                  .then((_) {
                setState(() {
                  tagList.add(value.toString());
                });
              });
            } else {
              print("List alredy contains $value or is null");
            }
          });
        },
        child: const Chip(
          label: Text(
            "Add Tag +",
            style: TextStyle(fontFamily: "Segoe UI", fontSize: 16),
          ),
        ),
      ));
    }

    return widgetList;
  }

  //Validate Changes Form
  bool validateForm() {
    if (_postTitleTextController.text.isEmpty || tagList.isEmpty) {
      if (_postTitleTextController.text.isEmpty) {
        _formError['title'] = true;
        print("title");
      } else {}
      // if (thumbnailPreview == null) {
      //   _formError['thumbnail'] = true;
      // } else {
      //   _formError['thumbnail'] = false;
      // }
      if (tagList.isEmpty) {
        _formError['tag'] = true;
        print("tag");
      } else {
        _formError['tag'] = false;
      }
      return false;
    } else {
      return true;
    }
  }
}

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text("Delete"),
      content:
          const Text("your Post will be gone for a loooooong fucking time"),
      actions: [
        //Delete
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.resolveWith((states) {
              Color _borderColor;
              if (states.contains(MaterialState.pressed)) {
                _borderColor = Colors.white;
              } else if (states.contains(MaterialState.hovered)) {
                _borderColor = Theme.of(context).colorScheme.brandColor;
              } else {
                _borderColor = Colors.black;
              }

              return BorderSide(color: _borderColor, width: 3);
            }),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
          ),
          onPressed: () {
            Navigator.pop(context, "delete");
          },
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Toss it into the fire",
              style: TextStyle(fontFamily: 'Sogeo UI', fontSize: 12),
            ),
          ),
        ),
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.resolveWith((states) {
              Color _borderColor;
              if (states.contains(MaterialState.pressed)) {
                _borderColor = Colors.white;
              } else if (states.contains(MaterialState.hovered)) {
                _borderColor = Theme.of(context).colorScheme.brandColor;
              } else {
                _borderColor = Colors.black;
              }

              return BorderSide(color: _borderColor, width: 3);
            }),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Nah keep it",
              style: TextStyle(fontFamily: 'Sogeo UI', fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
