import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/subchannel/create/create_subchannel_large_widget.dart';

class CreateSubchannelScreen extends StatefulWidget {
  const CreateSubchannelScreen({Key? key}) : super(key: key);

  @override
  _SubchannelState createState() => _SubchannelState();
}

class _SubchannelState extends State<CreateSubchannelScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: const [CreateSubchannelLargeScreen(), NavBarLargeProfile()],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
