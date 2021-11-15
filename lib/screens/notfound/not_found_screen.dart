import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/notfound/not_found_page_large_widget.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<NotFoundScreen> {
  int activeFeed = 0;

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: ResponsiveWidget(
        smallScreen: NotFoundLarge(),
        mediumScreen: NotFoundLarge(),
        largeScreen: NotFoundLarge(),
        veryLargeScreen: NotFoundLarge(),
      ),
    );
  }

  void setActiveFeedTo(int i) {
    setState(() {
      activeFeed = i;
    });
  }
}
