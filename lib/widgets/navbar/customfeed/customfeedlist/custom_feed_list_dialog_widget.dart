import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/customfeed/custom_feed_util_methods.dart'
    as cf_utils;
import 'package:uidraft1/utils/customfeed/custom_feed_util_methods.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/widgets/navbar/customfeed/customfeeditem/custom_feed_edit_widget.dart';
import 'package:uidraft1/widgets/navbar/customfeed/customfeeditem/custom_feed_item_widget.dart';
import 'package:http/http.dart' as http;

// import 'package:animations/animations.dart';

class CustomFeedList extends StatefulWidget {
  const CustomFeedList({
    Key? key,
    required this.myUsername,
    required this.isLeftHand,
    required this.setActiveFeed,
    required this.activeFeed,
  }) : super(key: key);

  final String myUsername;
  final bool isLeftHand;
  final Function(int i) setActiveFeed;
  final int activeFeed;

  @override
  State<CustomFeedList> createState() => _CustomFeedListState();
}

class _CustomFeedListState extends State<CustomFeedList>
    with SingleTickerProviderStateMixin {
  bool _showEdit = false;
  bool _isNew = false;
  int? activeIndex;

  double _width = 230;
  // double _height = 100;

  bool _visible = true;

  int durMilliseconds = 500;

  @override
  void initState() {
    super.initState();
  }

  back() {
    setToList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return AnimatedSize(
        duration: const Duration(milliseconds: 80),
        alignment: Alignment.topCenter,
        child: AnimatedContainer(
          duration: Duration(milliseconds: durMilliseconds),
          curve: Curves.fastLinearToSlowEaseIn,
          width: _width,
          // height: _height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            color: Theme.of(context).colorScheme.searchBarColor,
          ),
          child: AnimatedOpacity(
            curve: Curves.ease,
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: (durMilliseconds / 2).round()),
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: FutureBuilder(
                  future: cf_utils.fetchUserCustomFeedsPreview(
                      connection.returnConnection()),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      print("DEBUZG");
                      if (_showEdit) {
                        return CustomFeedEdit(
                            isLeftHand: widget.isLeftHand,
                            cfId: snapshot.data!
                                .elementAt(activeIndex!)['customFeedId'],
                            back: back,
                            isNew: _isNew);
                      } else {
                        return Column(
                            children: _getCustomFeedsList(
                                snapshot.data!, connection.returnConnection()));
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ),
        ),
      );
    });
  }

  void setToEdit(int? index, bool isNew) async {
    setState(() {
      _width = 400;
      _visible = false;
    });
    await Future.delayed(Duration(milliseconds: (durMilliseconds / 2).round()));
    setState(() {
      _isNew = isNew;
      _showEdit = true;
      activeIndex = index;
      _visible = true;
    });
  }

  void setToList() {
    setState(() {
      _isNew = false;
      _showEdit = false;
      activeIndex = null;
      _width = 230;
    });
  }

  void animateVisibility() async {
    setState(() {
      _visible = false;
    });
    await Future.delayed(Duration(milliseconds: (durMilliseconds / 2).round()));
    setState(() {
      _visible = true;
    });
  }

  //generate CustomFeed List
  List<Widget> _getCustomFeedsList(
      List<Map<String, dynamic>> list, http.Client client) {
    List<Widget> widgetList = List.generate(list.length, (index) {
      return InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          // setToEdit(index);
          print("chose subchannel $index");
          widget.setActiveFeed(list.elementAt(index)['customFeedId']);
        },
        child: Container(
          color: (widget.activeFeed == list.elementAt(index)['customFeedId'])
              ? Colors.deepPurple
              : Colors.transparent,
          child: CustomFeedItem(
            customfeedName: list.elementAt(index)['customFeedName'],
            edit: () => setToEdit(index, false),
          ),
        ),
      );
    });

    if (list.length < 3) {
      widgetList.add(InkWell(
          onTap: () {
            print('new');
            createCustomFeed(client).then((value) => setToEdit(0, true));
          },
          child: const SizedBox(
            width: double.infinity,
            height: 30,
            child: Center(
              child: Text(
                "Add Custom Feed +",
                style: TextStyle(fontFamily: "Segoe UI", fontSize: 16),
              ),
            ),
          )));
    }

    widgetList.insert(
        0,
        InkWell(
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            // setToEdit(index);
            print("chose subchannel 0");
            widget.setActiveFeed(0);
          },
          child: CustomFeedItem(
            customfeedName: "default feed",
            edit: () {},
            isDefault: true,
          ),
        ));
    return widgetList;
  }
}
