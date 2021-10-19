import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/uploadVideo/large/upload_video_data_large_widget.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: const [UploadVideoDataLargeScreen(), NavBarLargeProfile()],
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   // alignment: Alignment.topCenter,
        //   children: const [NavBarLargeProfile(), Expanded(child: UploadVideoDataLargeScreen())],
        // ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
