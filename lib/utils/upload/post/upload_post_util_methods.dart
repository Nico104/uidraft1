import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

import '../upload_helper_util_methods.dart';

import 'package:dio/dio.dart' as dartio;

Future<void> sendPost(
    String postTitle,
    String postDescription,
    String postSubchannelName,
    Uint8List thumbnail,
    List<int> video,
    List<String> tags,
    Function() callback) async {
  // var url = Uri.parse(uploadServerBaseURL + 'post/uploadPostWithData');
  var url = Uri.parse(uploadServerBaseURL + 'post/uploadPostWithData');
  print("URL: " + url.toString());
  String? token = await getToken();

  var request = http.MultipartRequest('POST', url);

  request.headers['Authorization'] = 'Bearer $token';
  request.fields['postDescription'] = postDescription;
  request.fields['postSubchannelName'] = postSubchannelName;
  request.fields['postTitle'] = postTitle;
  request.fields['tag1'] = tags.isNotEmpty ? tags.elementAt(0) : "none";
  request.fields['tag2'] = tags.length > 1 ? tags.elementAt(1) : "none";
  request.fields['tag3'] = tags.length > 2 ? tags.elementAt(2) : "none";

  request.files.add(http.MultipartFile.fromBytes('picture', thumbnail,
      filename: "thumbnailname", contentType: MediaType('image', 'png')));
  request.files.add(http.MultipartFile.fromBytes('video', video,
      filename: "videoname", contentType: MediaType('video', 'mp4')));

  callback.call();

  await request.send().then((result) async {
    http.Response.fromStream(result).then((response) {
      if (response.statusCode == 201) {
        print("Uploaded! ");
        // print('response.body ' + response.body);

        int postId = jsonDecode(response.body)['postId'];

        //Add posttags
        for (var element in tags) {
          http.patch(Uri.parse(baseURL + 'post/addPostTag/$postId'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, String>{"tagname": element}));
        }
      }

      // return response.body;
    });
  }).catchError((err) {
    print('error : ' + err.toString());
  }).whenComplete(() {
    print("upload fertig1");
  });
}

Future<void> postUploadProgress(
    String postTitle,
    String postDescription,
    String postSubchannelName,
    Uint8List thumbnail,
    List<int> video,
    List<String> tags,
    OnUploadProgressCallback? onUploadProgress) async {
  String urlFileStore = uploadServerBaseURL + 'post/uploadPostWithData';
  String token = await getToken() ?? "";

  dartio.BaseOptions options = dartio.BaseOptions(
      contentType: "multipart/form-data",
      headers: {'Authorization': 'Bearer $token', 'Accept-Ranges': 'bytes'},
      connectTimeout: 200000,
      receiveTimeout: 200000,
      sendTimeout: 200000,
      followRedirects: true,
      validateStatus: (status) {
        print('uploadFile Status: $status');
        return status! <= 500;
      });

  dartio.Dio _dio = dartio.Dio(options);

//  request.files.add(http.MultipartFile.fromBytes('picture', thumbnail,
//       filename: "thumbnailname", contentType: MediaType('image', 'png')));
//   request.files.add(http.MultipartFile.fromBytes('video', video,
//       filename: "videoname", contentType: MediaType('video', 'mp4')));
// de(<String, String>{"tagname": element}));

//  request.fields['postDescription'] = postDescription;
//   request.fields['postSubchannelName'] = postSubchannelName;
//   request.fields['postTitle'] = postTitle;
//   request.fields['tag1'] = tags.isNotEmpty ? tags.elementAt(0) : "none";
//   request.fields['tag2'] = tags.length > 1 ? tags.elementAt(1) : "none";
//   request.fields['tag3'] = tags.length > 2 ? tags.elementAt(2) : "none";
  // File filevideo = File.
  // final buffer = .buffer;
  // Directory tempDir = await getTemporaryDirectory();
  // String tempPath = tempDir.path;

  // String directory = (await getApplicationDocumentsDirectory()).path;
  // var filePath = directory +
  //     // tempPath +
  //     '/file_01.tmp'; // file_01.tmp is dump file, can be anything
  // File filevideo = await File(filePath).writeAsBytes(video);

  try {
    var formData = dartio.FormData.fromMap({
      'picture': dartio.MultipartFile.fromBytes(
        thumbnail,
        filename: "thumbnailname",
        contentType: MediaType('image', 'png'),
      ),
      // 'video': dartio.MultipartFile.fromBytes(
      //   video,
      //   filename: "videoname",
      //   contentType: MediaType('video', 'mp4'),
      // ),
      'video':
          // dartio.MultipartFile(filevideo.openRead(), filevideo.lengthSync()),
          http.MultipartFile.fromBytes("temp", video),
      'postDescription': postDescription,
      'postSubchannelName': postSubchannelName,
      'postTitle': postTitle,
      'tag1': tags.isNotEmpty ? tags.elementAt(0) : "none",
      'tag2': tags.length > 1 ? tags.elementAt(1) : "none",
      'tag3': tags.length > 2 ? tags.elementAt(2) : "none"
    });
    var response = await _dio.post(
      urlFileStore,
      data: formData,
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );
    print(response);
    int postId = jsonDecode(response.data)['postId'];
    print("PostId: " + postId.toString());
    for (var element in tags) {
      http.patch(Uri.parse(baseURL + 'post/addPostTag/$postId'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{"tagname": element}));
    }
  } on Exception catch (e) {
    print(e);
  }
}
