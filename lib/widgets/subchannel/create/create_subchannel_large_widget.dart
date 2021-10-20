import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/util_methods.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:uidraft1/widgets/subchannel/create/create_subchannel_preview_widget.dart';
import 'package:uidraft1/widgets/tag/tag_grid_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';

class CreateSubchannelLargeScreen extends StatelessWidget {
  const CreateSubchannelLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CreateSubchannelForm(),
    );
  }
}

class CreateSubchannelForm extends StatefulWidget {
  const CreateSubchannelForm({Key? key}) : super(key: key);

  @override
  _CreateSubchannelFormState createState() => _CreateSubchannelFormState();
}

class _CreateSubchannelFormState extends State<CreateSubchannelForm> {
  final _subchannelNameTextController = TextEditingController();
  final _subchannelAboutTextController = TextEditingController();
  final _subchannelShortDescriptionTextController = TextEditingController();

  Uint8List? subchannelPicturePreview;
  Uint8List? bannerPreview;
  String? thumbnailName = "halloname";
  bool isLoading = false;

  double _formProgress = 0;

  FilePickerResult? result;

  // int pageIndex = 0;
  int pageIndex = 1;

  //TagList
  List<String> tagList = [];

  //Upload File
  late DropzoneViewController controller;
  Uint8List? videoBytes;

  @override
  void dispose() {
    _subchannelNameTextController.dispose();
    _subchannelShortDescriptionTextController.dispose();
    _subchannelAboutTextController.dispose();
    // _debounce.dispose();
    super.dispose();
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
                                //Subchannel Name
                                TextFormField(
                                  controller: _subchannelNameTextController,
                                  // enableSuggestions: false,
                                  maxLength: 21,
                                  cursorColor: Colors.black,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    labelText: "Subchannel Name...",
                                    labelStyle: const TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.pink),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Field cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                      fontFamily: "Segoe UI",
                                      color: Colors.black),
                                  onChanged: (text) {
                                    EasyDebounce.debounce(
                                        'titleTextField-debouncer', // <-- An ID for this particular debouncer
                                        const Duration(
                                            milliseconds:
                                                300), // <-- The debounce duration
                                        () => setState(() {
                                              print("Title set to $text");
                                            }) // <-- The target method
                                        );
                                  },
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                
                                //Dropzones
                                Row(
                                  // direction: Axis.horizontal,
                                  children: [
                                    //Subchannel Picture Dropzone
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // color: Colors.lightBlue,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            border: Border.all(
                                                color: subchannelPicturePreview != null
                                                    ? Colors.greenAccent
                                                    : Colors.pink,
                                                width: subchannelPicturePreview != null
                                                    ? 4
                                                    : 2)),
                                        // color: Colors.pink,
                                        height: 150,
                                        child: InkWell(
                                          onTap: () async {
                                            result = await FilePicker.platform
                                                .pickFiles(
                                                    type: FileType.image,
                                                    allowMultiple: false);
                                      
                                            setState(() {
                                              subchannelPicturePreview =
                                                  result!.files.first.bytes;
                                            });
                                      
                                            print("testprint1");
                                            //_processThumbnail(result);
                                          },
                                          child: Stack(
                                            children: [
                                              IgnorePointer(
                                                child: DropzoneView(
                                                  mime: const [
                                                    "image/png",
                                                    "image/jpeg"
                                                  ],
                                                  operation: DragOperation.copy,
                                                  cursor: CursorType.grab,
                                                  onCreated:
                                                      (DropzoneViewController ctrl) =>
                                                          controller = ctrl,
                                                  onLoaded: () =>
                                                      print('Zone loaded'),
                                                  onError: (String? ev) =>
                                                      print('Error: $ev'),
                                                  onHover: () =>
                                                      print('Zone hovered'),
                                                  onDrop: (dynamic ev) async {
                                                    setState(() {
                                                      print("Dropped: $ev");
                                                    });
                                                    if (ev != null) {
                                                      print("FileName: " +
                                                          await controller
                                                              .getFilename(ev));
                                                      subchannelPicturePreview =
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
                                                child: Text(subchannelPicturePreview != null
                                                    ? "Change Subchannel Picture"
                                                    : "Choose Subchannel Picture", textAlign: TextAlign.center,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                //Banner Dropzone
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // color: Colors.lightBlue,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color: bannerPreview != null
                                                ? Colors.greenAccent
                                                : Colors.pink,
                                            width: bannerPreview != null
                                                ? 4
                                                : 2)),
                                    // color: Colors.pink,
                                    height: 150,
                                    child: InkWell(
                                      onTap: () async {
                                        result = await FilePicker.platform
                                            .pickFiles(
                                                type: FileType.image,
                                                allowMultiple: false);
                                  
                                        setState(() {
                                          bannerPreview =
                                              result!.files.first.bytes;
                                        });
                                  
                                        print("testprint1");
                                        //_processThumbnail(result);
                                      },
                                      child: Stack(
                                        children: [
                                          IgnorePointer(
                                            child: DropzoneView(
                                              mime: const [
                                                "image/png",
                                                "image/jpeg"
                                              ],
                                              operation: DragOperation.copy,
                                              cursor: CursorType.grab,
                                              onCreated:
                                                  (DropzoneViewController ctrl) =>
                                                      controller = ctrl,
                                              onLoaded: () =>
                                                  print('Zone loaded'),
                                              onError: (String? ev) =>
                                                  print('Error: $ev'),
                                              onHover: () =>
                                                  print('Zone hovered'),
                                              onDrop: (dynamic ev) async {
                                                setState(() {
                                                  print("Dropped: $ev");
                                                });
                                                if (ev != null) {
                                                  print("FileName: " +
                                                      await controller
                                                          .getFilename(ev));
                                                  bannerPreview =
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
                                            child: Text(bannerPreview != null
                                                ? "Change Subchannel Picture"
                                                : "Choose Subchannel Picture", textAlign: TextAlign.center,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                  ],
                                ),
                                 
                                const SizedBox(
                                  height: 40,
                                ),
                                //Short Description
                                TextFormField(
                                  controller: _subchannelShortDescriptionTextController,
                                  // enableSuggestions: false,
                                  cursorColor: Colors.black,
                                  autocorrect: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLength: 70,
                                  minLines: 1,
                                  maxLines: 20,
                                  decoration: InputDecoration(
                                    labelText: "Short Description...",
                                    labelStyle: const TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.pink),
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
                                      fontFamily: "Segoe UI",
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                //Tags
                                Wrap(
                                  runSpacing: 5,
                                  spacing: 5,
                                  children: _getVideoTagWidgets(tagList),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                //About
                                TextFormField(
                                  controller: _subchannelAboutTextController,
                                  // enableSuggestions: false,
                                  cursorColor: Colors.black,
                                  autocorrect: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLength: 512,
                                  minLines: 1,
                                  maxLines: 20,
                                  decoration: InputDecoration(
                                    labelText: "About...",
                                    labelStyle: const TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.pink),
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
                                      fontFamily: "Segoe UI",
                                      color: Colors.black),
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
                                side:
                                    MaterialStateProperty.resolveWith((states) {
                                  Color _borderColor;
                                  if (states.contains(MaterialState.pressed)) {
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
                                      color: _borderColor, width: 3);
                                }),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              ),
                              onPressed: () => print("ss"),
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
                Flexible(flex: 1 ,child: Container()),
            //Preview
            Flexible(
                flex: 4,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [         
                        CreateSubchannelPreviewLargeScreen(),
                      ],
                    ),
                  ),
                )),
                const Flexible(flex: 1 ,child: SizedBox()),
          ],
        );
    }






List<Widget> _getVideoTagWidgets(List<String> list) {
    List<Widget> widgetList = List.generate(tagList.length, (index) {
      return Chip(
        label: Text(
          capitalizeOnlyFirstLater(tagList.elementAt(index)),
          style: const TextStyle(fontFamily: "Segoe UI", fontSize: 16),
        ),
        onDeleted: () {
          setState(() {
            print("onDelete");
            tagList.removeAt(index);
          });
        },
      );
    });

    if (list.length < 3) {
      widgetList.add(InkWell(
        onTap: () {
          print('openTagMenu');
          showDialog(
            context: context,
            builder: (context) => const TagGridLargeScreen(),
          ).then((value) {
            if (!tagList.contains(value.toString()) && value != null) {
              setState(() {
                tagList.add(value.toString());
              });
            } else {
              print("List alredy contains $value or is null");
            }
          });
        },
        child: const Chip(
          label: Text(
            "Add Tag +",
            style: TextStyle(fontFamily: "Segoe UI", fontSize: 16),
          ),
        ),
      ));
    }

    return widgetList;
  }


  }



  



