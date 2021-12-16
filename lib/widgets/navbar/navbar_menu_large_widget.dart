import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/screens/uploadVideo/upload_video_screen.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/upload/post/uploadDialog/upload_post_dialog_utils.dart';
import 'package:uidraft1/widgets/uploadVideo/popup/upload_video_dialog.dart';

import 'navbar_large_widget.dart';

class NavBarMenu extends StatelessWidget {
  const NavBarMenu({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        color: Theme.of(context).colorScheme.searchBarColor,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (username.isNotEmpty) {
                Beamer.of(context).beamToNamed('/profile/$username');
              } else {
                Beamer.of(context).beamToNamed('/login');
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("My Profile")),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.navBarIconColor,
            indent: 9,
            endIndent: 9,
          ),
          InkWell(
            onTap: () {
              if (username.isNotEmpty) {
                // Beamer.of(context).beamToNamed('/uploadvideo');
                //Collapse NavBar Menus
                // if (NavBarLarge.globalKey.currentState == null) {
                //   print("current NavBarState null");
                // } else {
                //   NavBarLarge.globalKey.currentState!.collapseMenus();
                // }
                // //Show Video Uplod Dialog
                // showDialog(
                //   useSafeArea: true,
                //   context: context,
                //   builder: (BuildContext context) {
                //     return const UploadVideoDialog();
                //   },
                // ).then((value) {
                //   if (value != null) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => UploadVideoScreen(
                //                 videoBytes: value,
                //               )),
                //     );
                //   } else {
                //     print("Exaclty zero video ausgewählt");
                //   }
                // });
                showPostUploadDialog(context);
              } else {
                Beamer.of(context).beamToNamed('/login');
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("Upload Video")),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.navBarIconColor,
            indent: 9,
            endIndent: 9,
          ),
          InkWell(
            onTap: () {
              if (username.isNotEmpty) {
                Beamer.of(context).beamToNamed('/createsubchannel');
              } else {
                Beamer.of(context).beamToNamed('/login');
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("Create Subchannel")),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.navBarIconColor,
            indent: 9,
            endIndent: 9,
          ),
          InkWell(
            onTap: () {
              if (username.isNotEmpty) {
                Beamer.of(context).beamToNamed('/studio');
              } else {
                Beamer.of(context).beamToNamed('/login');
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("Studio")),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.navBarIconColor,
            indent: 9,
            endIndent: 9,
          ),
          InkWell(
            onTap: () {
              logout().then((value) {
                Beamer.of(context).beamToNamed('/login');
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("Logout")),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
