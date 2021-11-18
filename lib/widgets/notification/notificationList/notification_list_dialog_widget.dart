import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/notifications/notification_util_methods.dart';
import 'package:uidraft1/widgets/chatNotification/chat_dialog_widget.dart';
import 'package:uidraft1/widgets/notification/notificationList/notification_list_item_widget.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

// import 'package:animations/animations.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    Key? key,
    required this.myUsername,
    required this.notifyParent,
    required this.isLeftHand,
  }) : super(key: key);

  final String myUsername;
  final Function() notifyParent;
  final bool isLeftHand;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with SingleTickerProviderStateMixin {
  bool _showChat = false;
  int? activeIndex;

  double _width = 230;
  // double _height = 100;

  bool _visible = true;

  int durMilliseconds = 500;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                future: fetchUserNotifications(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      print("DEBUZG");
                      if (_showChat && activeIndex != null) {
                        //NotificationDetail
                        return Column(
                          children: [
                            Row(
                              textDirection: widget.isLeftHand
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: Image.network(
                                        baseURL +
                                            snapshot.data!.elementAt(
                                                        activeIndex!)[
                                                    'fromUser']['userProfile']
                                                ['profilePicturePath'],
                                        fit: BoxFit.contain,
                                        width: 34,
                                        height: 34,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(snapshot.data!.elementAt(
                                        activeIndex!)['formUsername']),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                IconButton(
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      seeNotification(snapshot.data!
                                                  .elementAt(activeIndex!)[
                                              'userNotificationId'])
                                          .then((value) {
                                        widget.notifyParent();
                                        // setState(() {});
                                      });
                                      setToList();
                                    },
                                    icon: Icon(widget.isLeftHand
                                        ? Icons.arrow_back
                                        : Icons.arrow_forward))
                              ],
                            ),
                            ChatNotification(
                              username: snapshot.data!
                                  .elementAt(activeIndex!)['formUsername'],
                              picturePath: snapshot.data!
                                      .elementAt(activeIndex!)['fromUser']
                                  ['userProfile']['profilePicturePath'],
                              myUsername: widget.myUsername,
                            ),
                          ],
                        );
                      } else {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxHeight: 400, minHeight: 56.0),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  setToChat(index);
                                },
                                child: NotificationItem(
                                    username: snapshot.data!
                                        .elementAt(index)['formUsername'],
                                    notificationText: snapshot.data!
                                        .elementAt(index)['notificationText'],
                                    picturePath: snapshot.data!
                                            .elementAt(index)['fromUser']
                                        ['userProfile']['profilePicturePath'],
                                    assignedDate: snapshot.data!
                                        .elementAt(index)['assignedDate']),
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return const Text(
                          "you have 0 notification, you lonely f***");
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ),
      ),
    );
  }

  void setToChat(int index) async {
    // setState(() {
    //   _showChat = true;
    //   activeIndex = index;
    //   _width = 600;
    // });
    setState(() {
      // _height = 400;
      _width = 600;
      _visible = false;
    });
    await Future.delayed(Duration(milliseconds: (durMilliseconds / 2).round()));
    setState(() {
      _showChat = true;
      activeIndex = index;
      _visible = true;
    });
  }

  void setToList() {
    setState(() {
      // _height = 100;
      _showChat = false;
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
}
