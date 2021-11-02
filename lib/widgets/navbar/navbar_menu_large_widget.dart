import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

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
                Beamer.of(context).beamToNamed('/uploadvideo');
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
