import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/post/test/process_and_send_widget.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadVideoDataLargeScreen extends StatelessWidget {
  const UploadVideoDataLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: UploadVideoDataForm(),
    );
  }
}

class UploadVideoDataForm extends StatefulWidget {
  const UploadVideoDataForm({Key? key}) : super(key: key);

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

  FilePickerResult? result;

  int pageIndex = 0;

  //Upload File
  late DropzoneViewController controller;
  Uint8List? videoBytes;

  @override
  Widget build(BuildContext context) {
    switch (pageIndex) {
      case 1:
        //Post Creation
        return Container(
          width: 400,
          child: Form(
            // onChanged: _updateFormProgress, // NEW
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AnimatedProgressIndicator(value: _formProgress),
                Text('Video go', style: Theme.of(context).textTheme.headline4),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _postTitleTextController,
                    decoration: const InputDecoration(hintText: 'Post Title'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _postDescriptionTextController,
                    decoration:
                        const InputDecoration(hintText: 'Post Description'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    height: 100,
                    minWidth: 200,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith((states) {
                          Color _borderColor;
                          if (states.contains(MaterialState.disabled)) {
                            _borderColor = Colors.greenAccent;
                          } else if (states.contains(MaterialState.pressed)) {
                            _borderColor = Colors.yellow;
                          } else {
                            _borderColor = Colors.pinkAccent;
                          }

                          return BorderSide(color: _borderColor, width: 3);
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      onPressed: () async {
                        result = await FilePicker.platform.pickFiles(
                            type: FileType.image, allowMultiple: false);

                        setState(() {
                          thumbnailPreview = result!.files.first.bytes;
                        });

                        print("testprint1");
                        //_processThumbnail(result);
                      },
                      child: const Text("Choose Thumbnail"),
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : (thumbnailPreview != null
                        ? Image.memory(Uint8List.fromList(thumbnailPreview!))
                        : const Text("is empty")),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white;
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.blue;
                    }),
                  ),
                  onPressed: (_formProgress >= 0 &&
                          result != null &&
                          videoBytes != null)
                      ? () {
                          setState(() {
                            print("showProcess");
                            pageIndex = 2;
                          });
                        }
                      : null,
                  child: isLoading
                      ? const Text('Wait for Thumbnail to be processed')
                      : const Text('Post Video'),
                ),
                TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled)
                            ? null
                            : Colors.white;
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled)
                            ? null
                            : Colors.blue;
                      }),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel X')),
              ],
            ),
          ),
        );

      case 2:
        print("case 2");
        // print("convert video");
        // List<int> videoBytesList = List.from(videoBytes!);
        // print("finished converting");

        //Upload and Porcess Video
        return ProcessAndSendScreen(
          postTitle: _postTitleTextController.text,
          postDescription: _postDescriptionTextController.text,
          postSubchannelName: "izgut",
          thumbnail: result,
          video: videoBytes!,
        );
      // return SizedBox();
      default:
        //Video File Upload
        return DottedBorder(
          color: Theme.of(context).colorScheme.brandColor,
          strokeWidth: 3,
          dashPattern: const [15, 10],
          radius: const Radius.circular(120),
          borderType: BorderType.RRect,
          strokeCap: StrokeCap.round,
          child: SizedBox(
            height: 400,
            width: 900,
            child: Stack(
              children: [
                DropzoneView(
                  mime: const ["video/mp4"],
                  operation: DragOperation.copy,
                  cursor: CursorType.grab,
                  onCreated: (DropzoneViewController ctrl) => controller = ctrl,
                  onLoaded: () => print('Zone loaded'),
                  onError: (String? ev) => print('Error: $ev'),
                  onHover: () => print('Zone hovered'),
                  onDrop: (dynamic ev) async {
                    print("Dropped: $ev");
                    if (ev != null) {
                      print("FileName: " + await controller.getFilename(ev));
                      Uint8List fileData = await controller.getFileData(ev);
                      setState(() {
                        print("weiter");
                        videoBytes = fileData;
                        pageIndex = 1;
                      });
                    }
                  },
                  onLeave: () => print('Zone left'),
                ),
                Center(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.resolveWith((states) {
                        Color _borderColor;
                        if (states.contains(MaterialState.disabled)) {
                          _borderColor = Colors.greenAccent;
                        } else if (states.contains(MaterialState.pressed)) {
                          _borderColor = Colors.yellow;
                        } else {
                          _borderColor = Colors.pinkAccent;
                        }

                        return BorderSide(color: _borderColor, width: 3);
                      }),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                    ),
                    onPressed: () => _saveVideoFile(),
                    child: const Text("Drop File or Choose Video"),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Future<void> _saveVideoFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: false);

    var fileBytes = result!.files.first.bytes;
    var fileName = result.files.first.name;
    print("FileName: " + fileName);
    setState(() {
      print("weiter");
      videoBytes = fileBytes;
      pageIndex = 1;
    });
  }
}














// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:uidraft1/widgets/post/test/process_and_send_widget.dart';

// class UploadVideoDataLargeScreen extends StatelessWidget {
//   const UploadVideoDataLargeScreen({Key? key, required this.videoBytes})
//       : super(key: key);

//   final List<int> videoBytes;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Center(
//         child: SizedBox(
//           width: 400,
//           child: Card(
//             child: UploadVideoDataForm(
//               videoBytes: videoBytes,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class UploadVideoDataForm extends StatefulWidget {
//   const UploadVideoDataForm({Key? key, required this.videoBytes})
//       : super(key: key);

//   final List<int> videoBytes;

//   @override
//   _UploadVideoDataFormState createState() => _UploadVideoDataFormState();
// }

// class _UploadVideoDataFormState extends State<UploadVideoDataForm> {
//   final _postTitleTextController = TextEditingController();
//   final _postDescriptionTextController = TextEditingController();

//   Uint8List? thumbnailPreview;
//   String? thumbnailName = "halloname";
//   bool isLoading = false;

//   double _formProgress = 0;

//   FilePickerResult? result;

//   void _updateFormProgress() {
//     var progress = 0.0;
//     final controllers = [
//       _postTitleTextController,
//       _postDescriptionTextController,
//     ];

//     for (final controller in controllers) {
//       if (controller.value.text.isNotEmpty) {
//         progress += 1 / controllers.length;
//       }
//     }

//     setState(() {
//       _formProgress = progress;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       onChanged: _updateFormProgress, // NEW
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // AnimatedProgressIndicator(value: _formProgress),
//           Text('Sign up', style: Theme.of(context).textTheme.headline4),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               controller: _postTitleTextController,
//               decoration: const InputDecoration(hintText: 'Post Title'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               controller: _postDescriptionTextController,
//               decoration: const InputDecoration(hintText: 'Post Description'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ButtonTheme(
//               height: 100,
//               minWidth: 200,
//               child: OutlinedButton(
//                 style: ButtonStyle(
//                   side: MaterialStateProperty.resolveWith((states) {
//                     Color _borderColor;
//                     if (states.contains(MaterialState.disabled)) {
//                       _borderColor = Colors.greenAccent;
//                     } else if (states.contains(MaterialState.pressed)) {
//                       _borderColor = Colors.yellow;
//                     } else {
//                       _borderColor = Colors.pinkAccent;
//                     }

//                     return BorderSide(color: _borderColor, width: 3);
//                   }),
//                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0))),
//                 ),
//                 onPressed: () async {
//                   result = await FilePicker.platform
//                       .pickFiles(type: FileType.image, allowMultiple: false);

//                   setState(() {
//                     thumbnailPreview = result!.files.first.bytes;
//                   });

//                   print("testprint1");
//                   //_processThumbnail(result);
//                 },
//                 child: const Text("Choose Thumbnail"),
//               ),
//             ),
//           ),
//           isLoading
//               ? const CircularProgressIndicator()
//               : (thumbnailPreview != null
//                   ? Image.memory(Uint8List.fromList(thumbnailPreview!))
//                   : const Text("is empty")),
//           TextButton(
//             style: ButtonStyle(
//               foregroundColor: MaterialStateProperty.resolveWith(
//                   (Set<MaterialState> states) {
//                 return states.contains(MaterialState.disabled)
//                     ? null
//                     : Colors.white;
//               }),
//               backgroundColor: MaterialStateProperty.resolveWith(
//                   (Set<MaterialState> states) {
//                 return states.contains(MaterialState.disabled)
//                     ? null
//                     : Colors.blue;
//               }),
//             ),
//             onPressed: (_formProgress >= 0 && result != null)
//                 ? () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ProcessAndSendScreen(
//                                 postTitle: _postTitleTextController.text,
//                                 postDescription:
//                                     _postDescriptionTextController.text,
//                                 postSubchannelName: "izgut",
//                                 thumbnail: result,
//                                 video: widget.videoBytes,
//                               )),
//                     )
//                 : null,
//             child: isLoading
//                 ? const Text('Wait for Thumbnail to be processed')
//                 : const Text('Post Video'),
//           ),
//         ],
//       ),
//     );
//   }
// }
