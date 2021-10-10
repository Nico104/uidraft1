import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/profile/large/profile_large_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: const [ProfileLargeScreen(), NavBarLargeProfile()],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
