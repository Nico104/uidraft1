import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/customfeed/custom_feed_util_methods.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/widgets/subchannel/choose/choose_subchannel_util_widget.dart';
import 'package:uidraft1/widgets/tag/choose_tag_util_widget.dart';
import 'package:uidraft1/widgets/user/choose/choose_user_util_widget.dart';
import 'package:http/http.dart' as http;

class CustomFeedEdit extends StatefulWidget {
  const CustomFeedEdit(
      {Key? key,
      required this.cfId,
      required this.isLeftHand,
      required this.back,
      this.isNew = false})
      : super(key: key);

  final int cfId;
  final bool isLeftHand;
  final Function() back;
  final bool isNew;

  @override
  State<CustomFeedEdit> createState() => _CustomFeedEditState();
}

enum CFsearchElement { none, subchannel, tag, creator }

class _CustomFeedEditState extends State<CustomFeedEdit> {
  CFsearchElement activeSearchElement = CFsearchElement.none;
  double? _height = null;

  backToEdit() {
    setState(() {
      activeSearchElement = CFsearchElement.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future: getCustomFeed(widget.cfId, connection.returnConnection()),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return snapshot.hasData
                ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    MenuBar(
                      customFeedName: snapshot.data!['customFeedName'],
                      customFeedId: widget.cfId,
                      isLeftHand: widget.isLeftHand,
                      back: widget.back,
                      isNew: widget.isNew,
                      client: connection.returnConnection(),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              child: child, scale: animation);
                        },
                        child: getBodyWidget(activeSearchElement,
                            snapshot.data!, connection.returnConnection())),
                  ])
                : const SizedBox(
                    height: 300, child: CircularProgressIndicator());
          });
    });
  }

  //Return either the added Elements of the custom feed or a search screen
  Widget getBodyWidget(
      CFsearchElement se, Map<String, dynamic> map, http.Client client) {
    switch (se) {
      case CFsearchElement.none:
        Future.delayed(Duration.zero, () async {
          if (mounted) {
            setState(() {
              _height = null;
            });
          }
        });
        return Column(
          children: [
            //Subchannels
            Column(
              children: [
                const Text("Subchannels"),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  runSpacing: 5,
                  spacing: 5,
                  children: _getWrapWidgets(map['subchannels'], widget.cfId,
                      CFElement.subchannel, client),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              children: [
                const Text("Tags"),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    children: _getWrapWidgets(
                      map['tags'],
                      widget.cfId,
                      CFElement.tag,
                      client,
                    )),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              children: [
                const Text("Creators"),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  runSpacing: 5,
                  spacing: 5,
                  children: _getWrapWidgets(map['addedUsers'], widget.cfId,
                      CFElement.creator, client),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteCustomFeed(widget.cfId, client)
                    .then((value) => widget.back.call()),
              ),
            )
          ],
        );
      case CFsearchElement.subchannel:
        Future.delayed(Duration.zero, () async {
          if (mounted) {
            setState(() {
              _height = null;
            });
          }
        });
        return ChooseSubchannelUtil(
            notifyParent: (val) =>
                addToCustomFeed(CFElement.subchannel, widget.cfId, val, client)
                    .then((value) => setState(() {
                          activeSearchElement = CFsearchElement.none;
                        })));
      case CFsearchElement.tag:
        return SizedBox(
          height: 600,
          child: ChooseTagUtil(
              notifyParent: (val) =>
                  addToCustomFeed(CFElement.tag, widget.cfId, val, client)
                      .then((value) => setState(() {
                            activeSearchElement = CFsearchElement.none;
                          })),
              back: backToEdit),
        );
      case CFsearchElement.creator:
        return SizedBox(
          height: 600,
          child: ChooseUserUtil(
              notifyParent: (val) =>
                  addToCustomFeed(CFElement.creator, widget.cfId, val, client)
                      .then((value) => setState(() {
                            activeSearchElement = CFsearchElement.none;
                          }))),
        );
    }
  }

  List<Widget> _getWrapWidgets(
      List<dynamic>? list, int cfId, CFElement cfe, http.Client client) {
    List<Widget> widgetList = <Widget>[];
    String fieldName;
    String addName;
    CFsearchElement searchEl;
    switch (cfe) {
      case CFElement.tag:
        fieldName = "tagName";
        addName = "Tag";
        searchEl = CFsearchElement.tag;
        break;
      case CFElement.subchannel:
        fieldName = "subchannelName";
        addName = "Subchannel";
        searchEl = CFsearchElement.subchannel;
        break;
      case CFElement.creator:
        fieldName = "username";
        addName = "Creator";
        searchEl = CFsearchElement.creator;
        break;
    }

    if (list != null) {
      List<Map<String, dynamic>> subchannels = <Map<String, dynamic>>[];
      List<dynamic> values = list;
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            subchannels.add(map);
          }
        }
      }

      widgetList = List.generate(subchannels.length, (index) {
        return Chip(
          label: Text(
            subchannels.elementAt(index)[fieldName],
            style: const TextStyle(fontFamily: "Segoe UI", fontSize: 13),
          ),
          onDeleted: () {
            removeFromCustomFeed(
                    cfe, cfId, subchannels.elementAt(index)[fieldName], client)
                .then((value) => setState(() {}));
          },
        );
      });
    }

    bool add = false;
    if (list == null) {
      add = true;
    } else if (list.length < 25) {
      add = true;
    }

    if (add) {
      widgetList.add(InkWell(
        onTap: () {
          setState(() {
            activeSearchElement = searchEl;
          });
        },
        child: Chip(
          label: Text(
            "Add $addName +",
            style: const TextStyle(fontFamily: "Segoe UI", fontSize: 13),
          ),
        ),
      ));
    }

    return widgetList;
  }
}

class MenuBar extends StatefulWidget {
  const MenuBar(
      {Key? key,
      required this.isLeftHand,
      required this.customFeedName,
      required this.back,
      required this.customFeedId,
      required this.isNew,
      required this.client})
      : super(key: key);

  final bool isLeftHand;
  final String customFeedName;
  final Function() back;
  final int customFeedId;
  final bool isNew;

  final http.Client client;

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  // final FocusNode fnCFName = FocusNode();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.isLeftHand ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Image.network(
                "https://picsum.photos/40",
                fit: BoxFit.contain,
                width: 34,
                height: 34,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: TextFormField(
                autofocus: widget.isNew,
                initialValue: widget.customFeedName,
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  // hintText: 'Username',
                ),
                onChanged: (text) {
                  EasyDebounce.debounce(
                      'titleTextField-debouncer', // <-- An ID for this particular debouncer
                      const Duration(
                          milliseconds: 1000), // <-- The debounce duration
                      () => changeCustomFeedName(
                          widget.customFeedId, text, widget.client));
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        IconButton(
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => widget.back.call(),
            icon: Icon(
                widget.isLeftHand ? Icons.arrow_back : Icons.arrow_forward))
      ],
    );
  }
}
