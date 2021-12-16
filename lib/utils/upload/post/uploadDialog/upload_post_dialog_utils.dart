import 'package:flutter/material.dart';
import 'package:uidraft1/screens/uploadVideo/upload_video_screen.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/uploadVideo/popup/upload_video_dialog.dart';

void showPostUploadDialog(BuildContext context) {
  //Show Video Uplod Dialog
  showDialog(
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return const UploadVideoDialog();
    },
  ).then((value) {
    if (value != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadVideoScreen(
                  videoBytes: value,
                )),
      );
    } else {
      print("Exaclty zero video ausgewählt");
    }
    // //Collapse NavBar Menus
    if (NavBarLarge.globalKey.currentState == null) {
      print("current NavBarState null");
    } else {
      NavBarLarge.globalKey.currentState!.collapseMenus();
    }
  });
}
