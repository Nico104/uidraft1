import 'package:flutter/material.dart';
import 'package:uidraft1/screens/notfound/not_found_profile_screen.dart';
import 'package:uidraft1/utils/profile/profile_utils_methods.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/profile/large/profile_large_widget.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: fetchProfileData(widget.username),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ResponsiveWidget(
                smallScreen: Text("smallScreen"),
                mediumScreen: Text("mediumScreen"),
                largeScreen: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ProfileLargeScreen(
                      profileData: snapshot.data!,
                    ),
                    // const NavBarLargeProfile()
                    NavBarLarge(
                      setActiveFeed: (_) {},
                      activeFeed: 0,
                      customFeed: false,
                    ),
                  ],
                ),
                veryLargeScreen: Text("veryLargeScreen"),
              );
            } else if (snapshot.hasError) {
              return const NotFoundProfileScreen();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
