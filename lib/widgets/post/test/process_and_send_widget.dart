import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/upload/post/upload_post_util_methods.dart';

class ProcessAndSendScreen extends StatelessWidget {
  const ProcessAndSendScreen(
      {Key? key,
      required this.postTitle,
      required this.postDescription,
      required this.postSubchannelName,
      required this.thumbnail,
      required this.video,
      required this.tags})
      : super(key: key);

  final String postTitle;
  final String postDescription;
  final String postSubchannelName;
  final FilePickerResult? thumbnail;
  final Uint8List video;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 200,
        child: Card(
          child: ProcessAndSend(
            postDescription: postDescription,
            postSubchannelName: postSubchannelName,
            postTitle: postTitle,
            thumbnail: thumbnail,
            video: video,
            tags: tags,
          ),
        ),
      ),
    );
  }
}

class ProcessAndSend extends StatefulWidget {
  const ProcessAndSend(
      {Key? key,
      required this.postTitle,
      required this.postDescription,
      required this.postSubchannelName,
      required this.thumbnail,
      required this.video,
      required this.tags})
      : super(key: key);

  final String postTitle;
  final String postDescription;
  final String postSubchannelName;
  final FilePickerResult? thumbnail;
  final Uint8List video;
  final List<String> tags;

  @override
  _ProcessAndSendFormState createState() => _ProcessAndSendFormState();
}

class _ProcessAndSendFormState extends State<ProcessAndSend> {
  int alreadyProcessed = 0;
  int toProcess = 2;

  void callback() {
    if (mounted) {
      setState(() {
        alreadyProcessed += 1;
      });
    }
  }

  Future<void> uploadPost() {
    return Future.delayed(
        const Duration(seconds: 1),
        () => sendPost(
            widget.postTitle,
            widget.postDescription,
            widget.postSubchannelName,
            widget.thumbnail!.files.first.bytes!,
            widget.video,
            widget.tags,
            callback));
  }

  // List<int> _processThumbnail(FilePickerResult? result) {
  //   var fileBytes = result!.files.first.bytes;
  //   var fileName = result.files.first.name;

  //   image.Image? raw = image.decodeImage(List.from(fileBytes!));

  //   print("FileName: " + fileName);

  //   if (raw!.width != 1280 && raw.height != 720) {
  //     print("Image not 1280x720");
  //     image.Image? resized = image.copyResize(raw, width: 1280, height: 720);
  //     if (mounted) {
  //       setState(() {
  //         alreadyProcessed += 1;
  //       });
  //     }

  //     return image.encodePng(resized);
  //   }
  //   print("Image is 1280x720");
  //   if (mounted) {
  //     setState(() {
  //       alreadyProcessed += 1;
  //     });
  //   }

  //   return fileBytes;
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("lesgo");
      uploadPost();

      Beamer.of(context).beamToNamed('/feed');
    });
  }

  @override
  Widget build(BuildContext context) {
    print("yo1");
    return Center(
      child: !(alreadyProcessed == toProcess)
          ? Text(alreadyProcessed.toString() +
              " of " +
              toProcess.toString() +
              " processed, please wait, do not close the Application")
          : const Text("Post processed and uploading"),
    );
  }
}
