import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/blindgaenger/navbar/empty_navbar_widget.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/search/search_grid_large_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.search}) : super(key: key);

  final String search;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  Widget _navbar = const EmptyNavBarLarge();

  void initNavBar() async {
    if (NavBarLarge.globalKey.currentState == null) {
      setState(() {
        _navbar = NavBarLarge(
          setActiveFeed: (_) {},
          activeFeed: 0,
          customFeed: false,
          searchInitialValue: widget.search,
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
      largeScreen: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SearchGridLargeScreen(search: widget.search),
            // NavBarLarge(
            //   setActiveFeed: (_) {},
            //   activeFeed: 0,
            //   customFeed: false,
            //   searchInitialValue: widget.search,
            // ),
            _navbar
          ],
        ),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }

  // void onSearch(String search) {
  //   print("searched: $search");
  //   setState(() {
  //     stateSearch = search;
  //   });
  // }
}
