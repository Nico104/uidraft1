import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class SubModUpdatePictureDialog extends StatefulWidget {
  const SubModUpdatePictureDialog({Key? key}) : super(key: key);

  @override
  State<SubModUpdatePictureDialog> createState() =>
      _SubModUpdatePictureDialogState();
}

class _SubModUpdatePictureDialogState extends State<SubModUpdatePictureDialog> {
  //Drozone
  FilePickerResult? result;
  late DropzoneViewController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.9, -0.4),
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink,
                  Colors.blue,
                ],
              )),
          width: 400,
          height: 650,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.lightBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.pink, width: 2)),
              // color: Colors.pink,
              // height: 150,
              child: InkWell(
                onTap: () async {
                  result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: false);

                  // setState(() {
                  //   subchannelPicturePreview = result!.files.first.bytes;
                  // });

                  print("testprint1");
                  //_processThumbnail(result);
                },
                child: Stack(
                  children: [
                    IgnorePointer(
                      child: DropzoneView(
                        mime: const ["image/png", "image/jpeg"],
                        operation: DragOperation.copy,
                        cursor: CursorType.grab,
                        onCreated: (DropzoneViewController ctrl) =>
                            controller = ctrl,
                        onLoaded: () => print('Zone loaded'),
                        onError: (String? ev) => print('Error: $ev'),
                        onHover: () => print('Zone hovered'),
                        onDrop: (dynamic ev) async {
                          setState(() {
                            print("Dropped: $ev");
                          });
                          if (ev != null) {
                            print("FileName: " +
                                await controller.getFilename(ev));
                            // subchannelPicturePreview =
                            //     await controller.getFileData(ev);
                            setState(() {
                              print("weiter");
                            });
                          }
                        },
                        onLeave: () => print('Zone left'),
                      ),
                    ),
                    const Center(
                      child: Text(
                        // subchannelPicturePreview != null
                        //     ? "Change Subchannel Picture "
                        //     : "Choose Subchannel Picture",
                        "Chnage subchannel pic/banner",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// shape:
//     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
// color: Colors.green,
