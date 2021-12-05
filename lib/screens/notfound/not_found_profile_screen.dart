import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/notfound/not_found_profile_page_large_widget.dart';

class NotFoundProfileScreen extends StatefulWidget {
  const NotFoundProfileScreen({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<NotFoundProfileScreen> {
  int activeFeed = 0;

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: ResponsiveWidget(
        smallScreen: NotFoundProfileLarge(),
        mediumScreen: NotFoundProfileLarge(),
        largeScreen: NotFoundProfileLarge(),
        veryLargeScreen: NotFoundProfileLarge(),
      ),
    );
  }

  void setActiveFeedTo(int i) {
    setState(() {
      activeFeed = i;
    });
  }
}
