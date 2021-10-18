import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as image;
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';

class ProcessAndSendScreen extends StatelessWidget {
  const ProcessAndSendScreen(
      {Key? key,
      required this.postTitle,
      required this.postDescription,
      required this.postSubchannelName,
      required this.thumbnail,
      required this.video})
      : super(key: key);

  final String postTitle;
  final String postDescription;
  final String postSubchannelName;
  final FilePickerResult? thumbnail;
  // final List<int> video;
  final Uint8List video;

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
      required this.video})
      : super(key: key);

  final String postTitle;
  final String postDescription;
  final String postSubchannelName;
  final FilePickerResult? thumbnail;
  // final List<int> video;
  final Uint8List video;

  @override
  _ProcessAndSendFormState createState() => _ProcessAndSendFormState();
}

class _ProcessAndSendFormState extends State<ProcessAndSend> {
  int alreadyProcessed = 0;
  int toProcess = 2;

  Future<void> uploadPost() {
    return Future.delayed(
        const Duration(seconds: 1),
        () => _sendPost(
            widget.postTitle,
            "postDescription",
            "postSubchannelName",
            _processThumbnail(widget.thumbnail),
            widget.video));
  }

  Future<void> _sendPost(
    String postTitle,
    String postDescription,
    String postSubchannelName,
    List<int> thumbnail,
    List<int> video,
    //List<int> video,
  ) async {
    var url = Uri.parse('http://localhost:3000/post/uploadPostWithData');
    String? token = await getToken();

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['postDescription'] = postTitle;
    request.fields['postSubchannelName'] = 'izgut';
    request.fields['postTitle'] = postTitle;

    request.files.add(http.MultipartFile.fromBytes('picture', thumbnail,
        filename: "thumbnailname", contentType: MediaType('image', 'png')));
    request.files.add(http.MultipartFile.fromBytes('video', video,
        filename: "videoname", contentType: MediaType('video', 'mp4')));

    setState(() {
      alreadyProcessed += 1;
    });

    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Uploaded!');
    } else {
      print('Upload Error!');
    }

    Beamer.of(context).beamToNamed('/feed');
  }

  List<int> _processThumbnail(FilePickerResult? result) {
    var fileBytes = result!.files.first.bytes;
    var fileName = result.files.first.name;

    image.Image? raw = image.decodeImage(List.from(fileBytes!));

    print("FileName: " + fileName);

    if (raw!.width != 1280 && raw.height != 720) {
      print("Image not 1280x720");
      image.Image? resized = image.copyResize(raw, width: 1280, height: 720);
      setState(() {
        alreadyProcessed += 1;
      });
      return image.encodePng(resized);
    }
    print("Image is 1280x720");
    setState(() {
      alreadyProcessed += 1;
    });
    return fileBytes;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("lesgo");
      uploadPost();
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
