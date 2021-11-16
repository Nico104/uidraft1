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
  int activeFeed = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const FeedGridLargeScreen(),
            NavBarLarge(
              // key: globalKey,
              setActiveFeed: setActiveFeedTo,
              activeFeed: activeFeed,
            ),
            activeFeed != 0
                ? Center(
                    child: Text(
                    activeFeed.toString(),
                    style: const TextStyle(fontSize: 44, color: Colors.purple),
                  ))
                : const SizedBox()
          ],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }

  void setActiveFeedTo(int i) {
    setState(() {
      activeFeed = i;
    });
  }
}
