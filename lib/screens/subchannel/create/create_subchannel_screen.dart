import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/subchannel/large/subchannel_large_widget.dart';

class SubchannelScreen extends StatefulWidget {
  const SubchannelScreen({Key? key}) : super(key: key);

  @override
  _SubchannelState createState() => _SubchannelState();
}

class _SubchannelState extends State<SubchannelScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: const [SubchannelLargeScreen(), NavBarLargeProfile()],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
