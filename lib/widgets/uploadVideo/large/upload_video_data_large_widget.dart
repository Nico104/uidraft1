import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/util_methods.dart';
import 'package:uidraft1/widgets/post/test/process_and_send_widget.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:uidraft1/widgets/subchannel/choose/choose_subchannel_dialog_large.dart';
import 'package:uidraft1/widgets/tag/tag_grid_widget.dart';
import 'package:uidraft1/widgets/uploadVideo/upload_video_feed_preview.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:uidraft1/widgets/uploadVideo/upload_video_player_preview.dart';

class UploadVideoDataLargeScreen extends StatelessWidget {
  const UploadVideoDataLargeScreen({Key? key, required this.videoBytes})
      : super(key: key);

  final Uint8List videoBytes;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UploadVideoDataForm(videoBytes: videoBytes),
    );
  }
}

class UploadVideoDataForm extends StatefulWidget {
  const UploadVideoDataForm({Key? key, required this.videoBytes})
      : super(key: key);

  final Uint8List videoBytes;

  @override
  _UploadVideoDataFormState createState() => _UploadVideoDataFormState();
}

class _UploadVideoDataFormState extends State<UploadVideoDataForm> {
  final _postTitleTextController = TextEditingController();
  final _postDescriptionTextController = TextEditingController();

  Uint8List? thumbnailPreview;
  String? thumbnailName = "halloname";
  bool isLoading = false;

  double _formProgress = 0;
  final Map<String, bool> _formError = {
    "title": false,
    "thumbnail": false,
    "tag": false,
    "subchannel": false
  };

  FilePickerResult? result;

  int pageIndex = 1;
  // int pageIndex = 1;

  //TagList
  List<String> tagList = [];

  //Upload File
  late DropzoneViewController controller;

  //Subchannel
  late String subchannelName = '';
  late String subchannelPicturePath;

  late Uint8List videoBytes;

  @override
  void initState() {
    videoBytes = widget.videoBytes;
    super.initState();
  }

  @override
  void dispose() {
    _postTitleTextController.dispose();
    _postDescriptionTextController.dispose();
    // _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Post Creation

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 1, child: Container()),
        //DataForm
        Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 110, bottom: 50),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  // borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), topRight: Radius.circular(40))
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  //  boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.blue.withOpacity(0.4),
                  //       spreadRadius: 2,
                  //       blurRadius: 25,
                  //       offset: const Offset(0, 7), // changes position of shadow
                  //     ),
                  //   ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 50, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          // shrinkWrap: true,
                          children: [
                            //SubchannelName and Choose a Subchannel
                            InkWell(
                              onTap: () {
                                print("pressed Change Subchannel");
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const ChooseSubchannelLargeScreen(),
                                ).then((value) {
                                  print("Value: " + value.toString());
                                  List<String> temp = value;
                                  setState(() {
                                    subchannelName = temp.elementAt(0);
                                    subchannelPicturePath = temp.elementAt(1);
                                  });
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image.network(
                                          "https://picsum.photos/100",
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          width: 52,
                                          height: 52,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        subchannelName.isNotEmpty
                                            ? subchannelName
                                            : "Please choose a Subchannel",
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      )
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_right_outlined,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                            //ShowError
                            !_formError['subchannel']!
                                ? const SizedBox()
                                : const SizedBox(
                                    height: 10,
                                  ),
                            !_formError['subchannel']!
                                ? const SizedBox()
                                : const Text(
                                    "Must choose a Subchannel",
                                    style: TextStyle(color: Colors.red),
                                  ),
                            //ShowErrorFinished
                            const SizedBox(
                              height: 40,
                            ),
                            //Title
                            TextFormField(
                              controller: _postTitleTextController,
                              // enableSuggestions: false,
                              maxLength: 70,
                              cursorColor: Colors.black,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: "Title...",
                                labelStyle: const TextStyle(
                                    fontFamily: "Segoe UI",
                                    color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.pink),
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
                                  fontFamily: "Segoe UI", color: Colors.black),
                              onChanged: (text) {
                                EasyDebounce.debounce(
                                    'titleTextField-debouncer', // <-- An ID for this particular debouncer
                                    const Duration(
                                        milliseconds:
                                            300), // <-- The debounce duration
                                    () => setState(() {
                                          print("Title set to $text");
                                        }) // <-- The target method
                                    );
                              },
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
                                    style: TextStyle(color: Colors.red),
                                  ),
                            //ShowErrorFinished
                            const SizedBox(
                              height: 40,
                            ),
                            //Thumbnail Dropzone
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.lightBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  border: Border.all(
                                      color: thumbnailPreview != null
                                          ? Colors.greenAccent
                                          : Colors.pink,
                                      width: thumbnailPreview != null ? 4 : 2)),
                              // color: Colors.pink,
                              height: 150,
                              child: InkWell(
                                onTap: () async {
                                  result = await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false);
                                  if (result != null) {
                                    _formError['thumbnail'] = false;
                                  }
                                  setState(() {
                                    thumbnailPreview =
                                        result!.files.first.bytes;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    IgnorePointer(
                                      child: DropzoneView(
                                        mime: const ["image/png", "image/jpeg"],
                                        operation: DragOperation.copy,
                                        cursor: CursorType.grab,
                                        onCreated:
                                            (DropzoneViewController ctrl) =>
                                                controller = ctrl,
                                        onLoaded: () => print('Zone loaded'),
                                        onError: (String? ev) =>
                                            print('Error: $ev'),
                                        onHover: () => print('Zone hovered'),
                                        onDrop: (dynamic ev) async {
                                          setState(() {
                                            print("Dropped: $ev");
                                          });
                                          if (ev != null) {
                                            _formError['thumbnail'] = false;
                                            print("FileName: " +
                                                await controller
                                                    .getFilename(ev));
                                            thumbnailPreview = await controller
                                                .getFileData(ev);
                                            setState(() {
                                              print("weiter");
                                            });
                                          }
                                        },
                                        onLeave: () => print('Zone left'),
                                      ),
                                    ),
                                    Center(
                                      child: Text(thumbnailPreview != null
                                          ? "Drop or Click to change Thumbnail"
                                          : "Drop or Click to choose Thumbnail"),
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
                                    style: TextStyle(color: Colors.red),
                                  ),
                            //ShowErrorFinished
                            const SizedBox(
                              height: 40,
                            ),
                            //Tags
                            Wrap(
                              runSpacing: 5,
                              spacing: 5,
                              children: _getVideoTagWidgets(tagList),
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
                                    style: TextStyle(color: Colors.red),
                                  ),
                            //ShowErrorFinished
                            const SizedBox(
                              height: 40,
                            ),
                            //Description
                            TextFormField(
                              controller: _postDescriptionTextController,
                              // enableSuggestions: false,
                              cursorColor: Colors.black,
                              autocorrect: false,
                              keyboardType: TextInputType.multiline,
                              maxLength: 512,
                              minLines: 1,
                              maxLines: 20,
                              decoration: InputDecoration(
                                labelText: "Description...",
                                labelStyle: const TextStyle(
                                    fontFamily: "Segoe UI",
                                    color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.pink),
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
                                  fontFamily: "Segoe UI", color: Colors.black),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      //Submit Post Button
                      SizedBox(
                        width: 200,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.resolveWith((states) {
                              Color _borderColor;
                              if (states.contains(MaterialState.pressed)) {
                                _borderColor = Colors.white;
                              } else if (states
                                  .contains(MaterialState.hovered)) {
                                _borderColor =
                                    Theme.of(context).colorScheme.brandColor;
                              } else {
                                _borderColor = Colors.black;
                              }

                              return BorderSide(color: _borderColor, width: 3);
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          onPressed: () {
                            print("pressed Submit");
                            validateForm()
                                ? setState(() {
                                    print("submit");
                                    // pageIndex = 2;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProcessAndSendScreen(
                                                postTitle:
                                                    _postTitleTextController
                                                        .text,
                                                postDescription:
                                                    _postDescriptionTextController
                                                        .text,
                                                postSubchannelName:
                                                    subchannelName,
                                                thumbnail: result,
                                                video: videoBytes,
                                                tags: tagList,
                                              )),
                                    );
                                  })
                                : setState(() {
                                    print("form has error");
                                  });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Post Video",
                              style: TextStyle(
                                  fontFamily: 'Sogeo UI',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        //Preview
        Flexible(
            flex: 6,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height < 670 ? 150 : 50,
                    ),
                    const Text(
                      "Preview",
                      style: TextStyle(
                          fontFamily: 'Segoe UI Black',
                          fontSize: 24,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    //Feed Preview
                    SizedBox(
                      height: 150,
                      child: AspectRatio(
                        aspectRatio: 600 / 180,
                        child: UploadVideoPlayerVideoPreview(
                          postTitle: _postTitleTextController.text.isNotEmpty
                              ? _postTitleTextController.text
                              : "You good, username?",
                          postSubchannel: "c/isgut",
                          postUsername: "username",
                          thumbnailPreview: thumbnailPreview,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    //Player Preview
                    SizedBox(
                      width: 400,
                      child: UploadVideoFeedPreview(
                        postTitle: _postTitleTextController.text.isNotEmpty
                            ? _postTitleTextController.text
                            : "You good, username?",
                        postSubchannel: "c/isgut",
                        postUsername: "username",
                        thumbnailPreview: thumbnailPreview,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );

    // default:
    //Video File Upload
    // return DottedBorder(
    //   color: Theme.of(context).colorScheme.brandColor,
    //   strokeWidth: 3,
    //   dashPattern: const [15, 10],
    //   radius: const Radius.circular(120),
    //   borderType: BorderType.RRect,
    //   strokeCap: StrokeCap.round,
    //   child: SizedBox(
    //     height: 400,
    //     width: 900,
    //     child: InkWell(
    //       onTap: () => _saveVideoFile(),
    //       hoverColor: Colors.transparent,
    //       highlightColor: Colors.transparent,
    //       focusColor: Colors.transparent,
    //       splashColor: Colors.lightBlueAccent,
    //       child: Stack(
    //         children: [
    //           IgnorePointer(
    //             child: DropzoneView(
    //               mime: const ["video/mp4"],
    //               operation: DragOperation.copy,
    //               cursor: CursorType.grab,
    //               onCreated: (DropzoneViewController ctrl) =>
    //                   controller = ctrl,
    //               onLoaded: () => print('Zone loaded'),
    //               onError: (String? ev) => print('Error: $ev'),
    //               onHover: () => print('Zone hovered'),
    //               onDrop: (dynamic ev) async {
    //                 print("Dropped: $ev");
    //                 if (ev != null) {
    //                   print(
    //                       "FileName: " + await controller.getFilename(ev));
    //                   Uint8List fileData = await controller.getFileData(ev);
    //                   String filepath = await controller.getFilename(ev);
    //                   print("File PAth: " + filepath);
    //                   setState(() {
    //                     print("weiter");
    //                     videoBytes = fileData;
    //                     pageIndex = 1;
    //                   });
    //                 }
    //               },
    //               onLeave: () => print('Zone left'),
    //             ),
    //           ),
    //           const Center(
    //             child: Text("Drop File or Choose Video"),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  bool validateForm() {
    if (_postTitleTextController.text.isEmpty ||
        thumbnailPreview == null ||
        tagList.isEmpty ||
        subchannelName.isEmpty) {
      if (_postTitleTextController.text.isEmpty) {
        _formError['title'] = true;
      } else {
        _formError['title'] = false;
      }
      if (thumbnailPreview == null) {
        _formError['thumbnail'] = true;
      } else {
        _formError['thumbnail'] = false;
      }
      if (tagList.isEmpty) {
        _formError['tag'] = true;
      } else {
        _formError['tag'] = false;
      }
      if (subchannelName.isEmpty) {
        _formError['subchannel'] = true;
      } else {
        _formError['subchannel'] = false;
      }
      return false;
    } else {
      return true;
    }
  }

  // Future<void> _saveVideoFile() async {
  //   final result = await FilePicker.platform
  //       .pickFiles(type: FileType.video, allowMultiple: false);

  //   var fileBytes = result!.files.first.bytes;
  //   var fileName = result.files.first.name;
  //   print("FileName: " + fileName);
  //   setState(() {
  //     print("weiter");
  //     videoBytes = fileBytes;
  //     pageIndex = 1;
  //   });
  // }

  List<Widget> _getVideoTagWidgets(List<String> list) {
    List<Widget> widgetList = List.generate(tagList.length, (index) {
      return Chip(
        label: Text(
          capitalizeOnlyFirstLater(tagList.elementAt(index)),
          style: const TextStyle(fontFamily: "Segoe UI", fontSize: 16),
        ),
        onDeleted: () {
          setState(() {
            print("onDelete");
            tagList.removeAt(index);
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
              setState(() {
                tagList.add(value.toString());
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
}
