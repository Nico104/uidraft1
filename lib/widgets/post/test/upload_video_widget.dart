import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/widgets/post/test/upload_video_data_widget.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';


class UploadVideoScreen extends StatelessWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Center(
        child: SizedBox(
          width: 600,
          height: 400,
          child: Card(
          elevation: 20,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15.0),
              ),
            child: const UploadVideoForm(),
          ),
        ),
      ),
    );
  }
}

class UploadVideoForm extends StatefulWidget {
  const UploadVideoForm({Key? key}) : super(key: key);

  @override
  _UploadVideoFormState createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
late DropzoneViewController controller;


  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     ButtonTheme(
    //       height: 100,
    //       minWidth: 200,
    //       child: OutlinedButton(
    //             style: ButtonStyle(
    //               side: MaterialStateProperty.resolveWith((states) {
    //                   Color _borderColor;
    //                   if (states.contains(MaterialState.disabled)) {
    //                     _borderColor = Colors.greenAccent;
    //                   } else if (states.contains(MaterialState.pressed)) {
    //                     _borderColor = Colors.yellow;
    //                   } else {
    //                     _borderColor = Colors.pinkAccent;
    //                   }
        
    //                   return BorderSide(color: _borderColor, width: 3);
    //                 }),
    //               shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
    //             ),
    //             // onPressed: () => Navigator.push(
    //             //         context,
    //             //         MaterialPageRoute(builder: (context) => const UploadVideoDataScreen()),
    //             //       ),
    //             onPressed: () => _uploadVideo(),
    //             child: const Text("Choose Video"), 
    //       ),
    //     ),
    //   ],
    // );
    return Stack(
  children: [
    DropzoneView(
      mime: const ["video/mp4"],
  operation: DragOperation.copy,
  cursor: CursorType.grab,
  onCreated: (DropzoneViewController ctrl) => controller = ctrl,
  onLoaded: () => print('Zone loaded'),
  onError: (String? ev) => print('Error: $ev'),
  onHover: () => print('Zone hovered'),
  onDrop: (dynamic ev) => print('Drop: $ev'),
  onLeave: () => print('Zone left'),
),
    // Center(child: Text('Drop files here')),
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
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                  ),
                  // onPressed: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => const UploadVideoDataScreen()),
                  //       ),
                  onPressed: () => _uploadVideo(),
                  child: const Text("Drop File or Choose Video"), 
            ),
    ),
  ],
);
  }
  
  Future<void> _uploadVideo() async {

    final result = await FilePicker.platform.pickFiles(type: FileType.video, allowMultiple: false);

    if (result!.files.first != null){
      var fileBytes = result.files.first.bytes;
      var fileName = result.files.first.name;

      // upload file
      // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

      print(String.fromCharCodes(fileBytes!));
      print("FileName: " + fileName);
      Navigator.push(context,MaterialPageRoute(builder: (context) => const UploadVideoDataScreen()),);
    }

    print("weiter");

  }



}
