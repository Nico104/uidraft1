import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:video_player/video_player.dart';

class UploadVideoDialog extends StatefulWidget {
  const UploadVideoDialog({Key? key}) : super(key: key);

  @override
  State<UploadVideoDialog> createState() => _UploadVideoDialogState();
}

class _UploadVideoDialogState extends State<UploadVideoDialog> {
  //Drozone
  FilePickerResult? result;
  late DropzoneViewController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink,
                  Colors.blue,
                ],
              )),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.lightBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.pink, width: 2)),
              // color: Colors.pink,
              // height: 150,
              child: InkWell(
                onTap: () async {
                  result = await FilePicker.platform
                      .pickFiles(type: FileType.video, allowMultiple: false);
                  if (result!.files.first.bytes != null) {
                    //!Test Check Video lenght
                    // VideoPlayerController controller = VideoPlayerController.
                    // File file = utf8.decode(result!.files.first.bytes);

                    Navigator.pop<Uint8List>(
                        context, result!.files.first.bytes!);
                  } else {
                    print("video null");
                  }
                },
                child: Stack(
                  children: [
                    IgnorePointer(
                      child: DropzoneView(
                        mime: const ["video/mp4"],
                        operation: DragOperation.copy,
                        cursor: CursorType.grab,
                        onCreated: (DropzoneViewController ctrl) =>
                            controller = ctrl,
                        onLoaded: () => print('Zone loaded'),
                        onError: (String? ev) => print('Error: $ev'),
                        onHover: () => print('Zone hovered'),
                        onDrop: (dynamic ev) async {
                          setState(() {
                            print("Dropped: $ev");
                          });
                          if (ev != null) {
                            print("FileName: " +
                                await controller.getFilename(ev));
                            Navigator.pop<Uint8List>(
                                context, await controller.getFileData(ev));
                            setState(() {
                              print("weiter");
                            });
                          }
                        },
                        onLeave: () => print('Zone left'),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Upload Video",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// shape:
//     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
// color: Colors.green,
