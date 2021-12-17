import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/blindgaenger/navbar/empty_navbar_widget.dart';
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

  void reloadFeed() {
    if (FeedGrid.feedGridKey.currentState != null) {
      FeedGrid.feedGridKey.currentState!.reload();
    }
  }

  Widget _navbar = const EmptyNavBarLarge();

  void initNavBar() async {
    if (NavBarLarge.globalKey.currentState == null) {
      setState(() {
        _navbar = NavBarLarge(
          setActiveFeed: setActiveFeedTo,
          activeFeed: activeFeed,
          onLogoClick: () => reloadFeed.call(),
        );
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 30), () {});
      initNavBar();
    }
  }

  @override
  void initState() {
    initNavBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            FeedGrid(),
            // NavBarLarge(
            //   setActiveFeed: setActiveFeedTo,
            //   activeFeed: activeFeed,
            //   onLogoClick: () => reloadFeed.call(),
            // ),
            // getNavbar(),
            _navbar,
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

  // bool isNavBarKeyFree() {
  //   bool _isFree = false;
  //   if (NavBarLarge.globalKey.currentState == null) {
  //     _isFree = true;
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       _isFree = isNavBarKeyFree();
  //     });
  //   }
  //   return _isFree;
  // }

  // Widget getNavbar() {
  //   if (NavBarLarge.globalKey.currentState == null) {
  //     return NavBarLarge(
  //       setActiveFeed: setActiveFeedTo,
  //       activeFeed: activeFeed,
  //       onLogoClick: () => reloadFeed.call(),
  //     );
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 50), () {
  //       setState(() {});
  //     });
  //     //TODO add empty NavBar to show in meantime and add everywhere navbar is loaded
  //     // return const SizedBox();
  //     return const EmptyNavBarLarge();
  //   }
  // }
}
