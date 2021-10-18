// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:uidraft1/screens/uploadVideo/upload_video_screen.dart';
// import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
// import 'package:uidraft1/widgets/uploadVideo/large/upload_video_data_large_widget.dart';
// import 'package:flutter_dropzone/flutter_dropzone.dart';
// import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

// class UploadVideoFileLargeScreen extends StatelessWidget {
//   const UploadVideoFileLargeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 700,
//         child: Card(
//           elevation: 20,
//           color: Theme.of(context).colorScheme.searchBarColor,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//                 color: Theme.of(context).colorScheme.brandColor, width: 2),
//             borderRadius: BorderRadius.circular(24.0),
//           ),
//           child: const UploadVideoForm(),
//         ),
//       ),
//     );
//   }
// }

// class UploadVideoForm extends StatefulWidget {
//   const UploadVideoForm({Key? key}) : super(key: key);

//   @override
//   _UploadVideoFormState createState() => _UploadVideoFormState();
// }

// class _UploadVideoFormState extends State<UploadVideoForm> {
//   late DropzoneViewController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         DropzoneView(
//           mime: const ["video/mp4"],
//           operation: DragOperation.copy,
//           cursor: CursorType.grab,
//           onCreated: (DropzoneViewController ctrl) => controller = ctrl,
//           onLoaded: () => print('Zone loaded'),
//           onError: (String? ev) => print('Error: $ev'),
//           onHover: () => print('Zone hovered'),
//           onDrop: (dynamic ev) async {
//             print("Dropped: $ev");
//             print("FileName: " + await controller.getFilename(ev));
//             Uint8List fileData = await controller.getFileData(ev);

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => UploadVideoScreen(
//                         videoBytes: fileData,
//                       )),
//             );

//             print("weiter");
//           },
//           onLeave: () => print('Zone left'),
//         ),
//         Center(
//           child: OutlinedButton(
//             style: ButtonStyle(
//               side: MaterialStateProperty.resolveWith((states) {
//                 Color _borderColor;
//                 if (states.contains(MaterialState.disabled)) {
//                   _borderColor = Colors.greenAccent;
//                 } else if (states.contains(MaterialState.pressed)) {
//                   _borderColor = Colors.yellow;
//                 } else {
//                   _borderColor = Colors.pinkAccent;
//                 }

//                 return BorderSide(color: _borderColor, width: 3);
//               }),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0))),
//             ),
//             onPressed: () => _uploadVideo(),
//             child: const Text("Drop File or Choose Video"),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _uploadVideo() async {
//     final result = await FilePicker.platform
//         .pickFiles(type: FileType.video, allowMultiple: false);

//     var fileBytes = result!.files.first.bytes;
//     var fileName = result.files.first.name;

//     // upload file
//     // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

//     // print(String.fromCharCodes(fileBytes!));
//     print("FileName: " + fileName);
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => UploadVideoScreen(
//                 videoBytes: fileBytes!,
//               )),
//     );

//     print("weiter");
//   }
// }
