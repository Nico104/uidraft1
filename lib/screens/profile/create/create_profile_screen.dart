import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/profile/create/large/create_profile_large_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _SubchannelState createState() => _SubchannelState();
}

class _SubchannelState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: const [CreateProfileLargeScreen(), NavBarLargeProfile()],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
