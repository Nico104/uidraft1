import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as fileUtil;
import 'package:path_provider/path_provider.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/models/file.dart' as model;
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart' as dartio;

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

//? GitHub Code
String baseUrl = 'https://192.168.0.15:45455';

bool trustSelfSigned = true;

HttpClient getHttpClient() {
  // HttpClient httpClient = HttpClient()
  HttpClient httpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);

  return httpClient;
}

Future<String> fileUploadMultipart(
    {File? file, OnUploadProgressCallback? onUploadProgress}) async {
  assert(file != null);

  final url = '$baseUrl/api/file';

  final httpClient = getHttpClient();
  // http.Client httpClient = http.Client();

  final request = await httpClient.postUrl(Uri.parse(url));
  // final request = await httpClient.post(Uri.parse(url));

  int byteCount = 0;

  var multipart = await http.MultipartFile.fromPath(
      fileUtil.basename(file!.path), file.path);

  // final fileStreamFile = file.openRead();

  // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
  //     filename: fileUtil.basename(file.path));

  var requestMultipart = http.MultipartRequest("", Uri.parse("uri"));

  requestMultipart.files.add(multipart);

  var msStream = requestMultipart.finalize();

  var totalByteLength = requestMultipart.contentLength;

  request.contentLength = totalByteLength;

  request.headers.set(HttpHeaders.contentTypeHeader,
      requestMultipart.headers[HttpHeaders.contentTypeHeader] ?? Object());

  Stream<List<int>> streamUpload = msStream.transform(
    StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);

        byteCount += data.length;

        if (onUploadProgress != null) {
          onUploadProgress(byteCount, totalByteLength);
          // CALL STATUS CALLBACK;
        }
      },
      handleError: (error, stack, sink) {
        throw error;
      },
      handleDone: (sink) {
        sink.close();
        // UPLOAD DONE;
      },
    ),
  );

  await request.addStream(streamUpload);

  final httpResponse = await request.close();
//
  var statusCode = httpResponse.statusCode;

  if (statusCode ~/ 100 != 2) {
    throw Exception(
        'Error uploading file, Status code: ${httpResponse.statusCode}');
  } else {
    return await readResponseAsString(httpResponse);
  }
}

Future<String> readResponseAsString(HttpClientResponse response) {
  var completer = Completer<String>();
  var contents = StringBuffer();
  var utf8;
  response.transform(utf8.decoder).listen((dynamic data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

//TEST Profile

//Update Profile
Future<String?> _updateProfile(
    String profileBio, List<int>? profilePicture, http.Client client) async {
  var url = Uri.parse(baseURL + 'user/updateMyUserProfile');
  String? token = await getToken();

  var request = http.MultipartRequest('PATCH', url);

  request.headers['Authorization'] = 'Bearer $token';
  request.fields['profileBio'] = profileBio;

  if (profilePicture != null) {
    print("profilePic not null");
    request.files.add(http.MultipartFile.fromBytes('picture', profilePicture,
        filename: "picture", contentType: MediaType('image', 'png')));
  } else {
    print("profilePic is null");
  }

  var response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    print('Updated!');
  } else {
    print('Update Error!');
  }

  String? un = await getMyUsername(client);
  return un;
}

Future<String> fileUploadMultipartProfilePicture(
    {List<int>? profilePicture,
    // File? file,
    OnUploadProgressCallback? onUploadProgress}) async {
  // assert(file != null);
  assert(profilePicture != null);

  final url = baseURL + 'user/updateMyUserProfile';

  final httpClient = getHttpClient();
  // final httpClient = HttpClient();
  // http.Client httpClient = http.Client();

  final request = await httpClient.patchUrl(Uri.parse(url));
  // final request = await httpClient.patch(Uri.parse(url));
  // final request = await httpClient.post(Uri.parse(url));

  int byteCount = 0;

  // var multipart = await http.MultipartFile.fromPath(
  //     fileUtil.basename(file!.path), file.path);

  var multipart = http.MultipartFile.fromBytes('picture', profilePicture!,
      filename: "picture", contentType: MediaType('image', 'png'));

  var requestMultipart = http.MultipartRequest("", Uri.parse("uri"));

  requestMultipart.files.add(multipart);

  var msStream = requestMultipart.finalize();

  var totalByteLength = requestMultipart.contentLength;

  request.contentLength = totalByteLength;

  request.headers.set(HttpHeaders.contentTypeHeader,
      requestMultipart.headers[HttpHeaders.contentTypeHeader] ?? Object());

  Stream<List<int>> streamUpload = msStream.transform(
    StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);

        byteCount += data.length;

        if (onUploadProgress != null) {
          onUploadProgress(byteCount, totalByteLength);
          // CALL STATUS CALLBACK;
        }
      },
      handleError: (error, stack, sink) {
        throw error;
      },
      handleDone: (sink) {
        sink.close();
        // UPLOAD DONE;
      },
    ),
  );

  await request.addStream(streamUpload);

  final httpResponse = await request.close();
//
  var statusCode = httpResponse.statusCode;

  if (statusCode ~/ 100 != 2) {
    throw Exception(
        'Error uploading file, Status code: ${httpResponse.statusCode}');
  } else {
    return await readResponseAsString(httpResponse);
  }
}

//? DIO Test -> Working Function
Future<void> fileUploadMultipartProfilePicture2(
    {List<int>? profilePicture,
    OnUploadProgressCallback? onUploadProgress}) async {
  String urlFileStore = baseURL + 'user/updateMyUserProfile';
  String token = await getToken() ?? "";

  dartio.BaseOptions options = dartio.BaseOptions(
      contentType: "multipart/form-data",
      headers: {'Authorization': 'Bearer $token'},
      connectTimeout: 200000,
      receiveTimeout: 200000,
      sendTimeout: 200000,
      followRedirects: true,
      validateStatus: (status) {
        print('uploadFile Status: $status');
        return status! <= 500;
      });

  dartio.Dio _dio = dartio.Dio(options);

  try {
    var formData = dartio.FormData.fromMap({
      'picture': dartio.MultipartFile.fromBytes(
        profilePicture!,
        filename: "picture",
        contentType: MediaType('image', 'png'),
      )
    });
    var response = await _dio.patch(
      urlFileStore,
      data: formData,
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );
    print(response);
  } on Exception catch (e) {
    print(e);
  }
}
