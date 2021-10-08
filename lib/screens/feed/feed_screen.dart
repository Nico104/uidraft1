import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/feed/feedGrid/feed_grid_large_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Scaffold(
        appBar: NavBarLarge(),
        body: FeedGridLargeScreen	(),
        // body: Text("FeedGridScreen"),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
