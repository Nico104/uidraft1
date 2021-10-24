import 'dart:convert';
import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:uidraft1/widgets/profile/create/create_profile_preview_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CreateProfileLargeScreen extends StatelessWidget {
  const CreateProfileLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CreateProfileForm(),
    );
  }
}

class CreateProfileForm extends StatefulWidget {
  const CreateProfileForm({Key? key}) : super(key: key);

  final String defaultBio =
      'There are many variations of passages of Lorem Ipsum available,\nbut the majority have suffered alteration\n in some form, by injected humour,\n or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum\n generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words,\n combined with a handful of model sentence structures, to generate Lorem\n Ipsum which looks reasonable.\n The generated Lorem Ipsum is therefore always free from repetition,\n injected humour, or non-characteristic words etc.There are many variations of passages of Lorem Ipsum available';

  @override
  _CreateProfileFormState createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends State<CreateProfileForm> {
  final _profileBioTextController = TextEditingController();

  Uint8List? profilePicturePreview;

  FilePickerResult? result;

  String username = "Username";

  //Upload File
  late DropzoneViewController controller;

  Future<Map<String, dynamic>> fetchCurrentProfileData() async {
    var url = Uri.parse('http://localhost:3000/user/getMyProfile');
    String? token = await getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        return map;
      } else {
        throw Exception('Failed to load post');
      }
    } else if (response.statusCode == 401) {
      Beamer.of(context).beamToNamed('/login');
      throw Exception('Unauthorized');
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<void> applyCurrentProfileData() async {
    Map<String, dynamic> profileData = await fetchCurrentProfileData();
    print(profileData.toString());
    Uint8List tempPB = await http.readBytes(Uri.parse(
        'http://localhost:3000/' + profileData['profilePicturePath']));
    if (mounted) {
      setState(() {
        _profileBioTextController.text = profileData['profileBio'];
        profilePicturePreview = tempPB;
        username = profileData['username'];
      });
    }
  }

  // //Set profile Picture to default
  // Future<void> deleteProfilePicture() async {
  //   Uint8List tempPB = await http.readBytes(Uri.parse(
  //       'http://localhost:3000/uploads/default/defaultProfilePicture.png'));
  //   if (mounted) {
  //     setState(() {
  //       profilePicturePreview = tempPB;
  //     });
  //   }
  // }

  //Update Profile
  Future<void> _updateProfile(
    String profileBio,
    List<int>? profilePicture,
  ) async {
    var url = Uri.parse('http://localhost:3000/user/updateMyUserProfile');
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

    String? un = await getMyUsername();
    Beamer.of(context).beamToNamed('/profile/$un');
  }

  @override
  void dispose() {
    _profileBioTextController.dispose();
    // _debounce.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //Get current User Profile
    //Get current User Bio
    super.initState();
    applyCurrentProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 1, child: Container()),
        //DataForm
        Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 110, bottom: 50),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  // borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), topRight: Radius.circular(40))
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  //  boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.blue.withOpacity(0.4),
                  //       spreadRadius: 2,
                  //       blurRadius: 25,
                  //       offset: const Offset(0, 7), // changes position of shadow
                  //     ),
                  //   ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 50, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            //Dropzone
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.lightBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  border: Border.all(
                                      color: profilePicturePreview != null
                                          ? Colors.greenAccent
                                          : Colors.pink,
                                      width: profilePicturePreview != null
                                          ? 4
                                          : 2)),
                              // color: Colors.pink,
                              height: 150,
                              child: InkWell(
                                onTap: () async {
                                  result = await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false);

                                  setState(() {
                                    profilePicturePreview =
                                        result!.files.first.bytes;
                                  });

                                  print("testprint1");
                                },
                                child: Stack(
                                  children: [
                                    IgnorePointer(
                                      child: DropzoneView(
                                        mime: const ["image/png", "image/jpeg"],
                                        operation: DragOperation.copy,
                                        cursor: CursorType.grab,
                                        onCreated:
                                            (DropzoneViewController ctrl) =>
                                                controller = ctrl,
                                        onLoaded: () => print('Zone loaded'),
                                        onError: (String? ev) =>
                                            print('Error: $ev'),
                                        onHover: () => print('Zone hovered'),
                                        onDrop: (dynamic ev) async {
                                          setState(() {
                                            print("Dropped: $ev");
                                          });
                                          if (ev != null) {
                                            print("FileName: " +
                                                await controller
                                                    .getFilename(ev));
                                            profilePicturePreview =
                                                await controller
                                                    .getFileData(ev);
                                            setState(() {
                                              print("weiter");
                                            });
                                          }
                                        },
                                        onLeave: () => print('Zone left'),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        profilePicturePreview != null
                                            ? "Change Profile Picture "
                                            : "Choose Profile Picture",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 150,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.resolveWith(
                                      (states) {
                                    Color _borderColor;
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      _borderColor = Colors.white;
                                    } else if (states
                                        .contains(MaterialState.hovered)) {
                                      _borderColor = Theme.of(context)
                                          .colorScheme
                                          .brandColor;
                                    } else {
                                      _borderColor = Colors.black;
                                    }

                                    return BorderSide(
                                        color: _borderColor, width: 2);
                                  }),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                ),
                                onPressed: () => setState(() {
                                  profilePicturePreview = null;
                                }),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Delet Profile Picture",
                                    style: TextStyle(
                                        fontFamily: 'Sogeo UI',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            //Short Description
                            TextFormField(
                              controller: _profileBioTextController,
                              // enableSuggestions: false,
                              cursorColor: Colors.black,
                              autocorrect: false,
                              keyboardType: TextInputType.multiline,
                              maxLength: 256,
                              minLines: 1,
                              maxLines: 35,
                              decoration: InputDecoration(
                                labelText: "Bio...",
                                labelStyle: const TextStyle(
                                    fontFamily: "Segoe UI",
                                    color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.pink),
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Field cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(
                                  fontFamily: "Segoe UI", color: Colors.black),
                              onChanged: (value) {
                                EasyDebounce.debounce(
                                    'profileBioTextField-debouncer', // <-- An ID for this particular debouncer
                                    const Duration(
                                        milliseconds:
                                            300), // <-- The debounce duration
                                    () => setState(() {
                                          print("Bio changed");
                                        }) // <-- The target method
                                    );
                              },
                            ),

                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      //Submit Post Button
                      SizedBox(
                        width: 200,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.resolveWith((states) {
                              Color _borderColor;
                              if (states.contains(MaterialState.pressed)) {
                                _borderColor = Colors.white;
                              } else if (states
                                  .contains(MaterialState.hovered)) {
                                _borderColor =
                                    Theme.of(context).colorScheme.brandColor;
                              } else {
                                _borderColor = Colors.black;
                              }

                              return BorderSide(color: _borderColor, width: 3);
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          onPressed: () => _updateProfile(
                              _profileBioTextController.text,
                              profilePicturePreview),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Create Subchannel",
                              style: TextStyle(
                                  fontFamily: 'Sogeo UI',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        Flexible(flex: 1, child: Container()),
        //Preview
        Flexible(
            flex: 4,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    CreateProfilePreviewLargeScreen(
                      bio: _profileBioTextController.text.isNotEmpty
                          ? _profileBioTextController.text
                          : widget.defaultBio,
                      profilePicture: profilePicturePreview,
                      username: username,
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            )),
        const Flexible(flex: 1, child: SizedBox()),
      ],
    );
  }
}
