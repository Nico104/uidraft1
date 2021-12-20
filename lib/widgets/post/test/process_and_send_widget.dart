import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/screens/feed/feed_screen.dart';
import 'package:uidraft1/utils/upload/post/upload_post_util_methods.dart';
import 'package:uidraft1/utils/upload/provider/upload_status.dart';
import 'dart:html' as html;

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
    UploadStatus _uploadStatus =
        Provider.of<UploadStatus>(context, listen: false);

    return Future.delayed(
        const Duration(seconds: 1),
        () =>
            // sendPost(
            postUploadProgress(
              widget.postTitle,
              widget.postDescription,
              widget.postSubchannelName,
              widget.thumbnail!.files.first.bytes!,
              widget.video,
              widget.tags,
              progressprint,
              _uploadStatus,
            ));
  }

  void progressprint(int sent, int total) {
    print("$sent of $total");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("lesgo");
      uploadPost();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const FeedScreen(
                  bypassNavBarFreeing: true,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print("yo1");
    return Column(
      children: [
        Center(
          child: !(alreadyProcessed == toProcess)
              ? Text(alreadyProcessed.toString() +
                  " of " +
                  toProcess.toString() +
                  " processed, please wait, do not close the Application")
              : const Text("Post processed and uploading"),
        ),
        // OutlinedButton(
        //     onPressed: () {
        //       // html.window.location.reload();
        //       // Beamer.of(context).beamToNamed('/feed');
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => FeedScreen(
        //                   bypassNavBarFreeing: true,
        //                 )),
        //       );
        //     },
        //     child: Text("got it"))
      ],
    );
  }
}
