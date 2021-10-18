import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:http/http.dart' as http;

class UploadVideoDataScreen extends StatelessWidget {
  const UploadVideoDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: UploadVideoDataForm(),
          ),
        ),
      ),
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
  bool isLoading = false;

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _postTitleTextController,
      _postDescriptionTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }


  Future<void> _showLoginScreen(
      String postTitle,
      String postDescription) async {
    // var url = Uri.parse('http://localhost:3000/user/signup');
    // var response = await http.post(url, body: {
    //   "username": "$username",
    //   "useremail": "$useremail",
    //   "userpassword": "$userpassword",
    //   "userSignUpDateTime":
    //       // "$DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now())}",
    //       "2012-04-23T18:25:43.511Z",
    //   "profilePicturePath": "$profilePicturePath",
    //   "profileDisplayName": "$profileDisplayName",
    //   "profileBio": "$profileBio",
    //   "profilePoints": "0",
    //   "userLanguage": "en"
    // });

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    // if (response.statusCode == 201) {
    //   print("yes");
    //   Navigator.of(context).pushNamed('/login');
    // } else {
    //   print("nope");
    //   Navigator.of(context).pushNamed('/login');
    // }
  }

  Future<void> _uploadThumbnail() async {

    setState(() {
          isLoading = true;
    });

    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);

    if (result!.files.first != null){

      var fileBytes = result.files.first.bytes;
      var fileName = result.files.first.name;

      image.Image? raw = image.decodeImage(List.from(fileBytes!));

      //print(String.fromCharCodes(fileBytes));
      print("FileName: " + fileName);

      if(raw!.width != 1280 && raw.height != 720){
        print("Image not 1280x720");
        image.Image? resized = image.copyResize(raw, width: 1280, height: 720);
        setState(() {
          thumbnailPreview = Uint8List.fromList(image.encodePng(resized));
          isLoading = false;
        });
      }else{
        print("Image is 1280x720");
        setState(() {
          thumbnailPreview = Uint8List.fromList(image.encodePng(raw));
          isLoading = false;
        });
      }

      // upload file
      // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

      //Navigator.push(context,MaterialPageRoute(builder: (context) => const UploadVideoDataScreen()),);
    }

    isLoading = false;
    print("weiter");
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress, // NEW
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AnimatedProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headline4),
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
              decoration: const InputDecoration(hintText: 'Post Description'),
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
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      ),
                      // onPressed: () => Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => const UploadVideoDataScreen()),
                      //       ),
                      onPressed: () => _uploadThumbnail(),
                      child: const Text("Choose Thumbnail"), 
                ),
            ),
          ),
          isLoading ? const CircularProgressIndicator() : (thumbnailPreview != null ? Image.memory(Uint8List.fromList(thumbnailPreview!)) : const Text("is empty")),
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
            onPressed: (_formProgress >= 0) 
                ? () => _showLoginScreen(
                    _postTitleTextController.text, _postTitleTextController.text)
                : null,
            child: isLoading ? const Text('Wait for Thumbnail to be processed') : const Text('Post Video'),
          ),
        ],
      ),
    );
  }
}
