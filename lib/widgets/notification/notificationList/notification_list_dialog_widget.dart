import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/notifications/notification_util_methods.dart';
import 'package:uidraft1/utils/widgets/notification/message/message_list_item_widget.dart';
import 'package:uidraft1/utils/widgets/notification/notification/detail_notification_widget.dart';
import 'package:uidraft1/utils/widgets/notification/notification/notification_list_item_widget.dart';
import 'package:uidraft1/widgets/chatNotification/chat_dialog_widget.dart';

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
  // bool _showChat = false;
  NotificationMode _notificationMode = NotificationMode.none;
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
                      if (_notificationMode == NotificationMode.chat &&
                          activeIndex != null) {
                        //NotificationDetail
                        return ChatNotification(
                          username: snapshot.data!
                              .elementAt(activeIndex!)['formUsername'],
                          picturePath:
                              snapshot.data!.elementAt(activeIndex!)['fromUser']
                                  ['userProfile']['profilePicturePath'],
                          myUsername: widget.myUsername,
                          isLeftHand: widget.isLeftHand,
                          onBackPressed: () {
                            seeNotification(snapshot.data!.elementAt(
                                    activeIndex!)['userNotificationId'])
                                .then((value) {
                              widget.notifyParent();
                              // setState(() {});
                            });
                            setToList();
                          },
                        );
                      }
                      if (_notificationMode == NotificationMode.notification &&
                          activeIndex != null) {
                        //NotificationDetail
                        return DetailNotification(
                          title:
                              snapshot.data!.elementAt(activeIndex!)['title'],
                          notificationText: snapshot.data!
                              .elementAt(activeIndex!)['notificationText'],
                          isLeftHand: widget.isLeftHand,
                          onBackPressed: () {
                            seeNotification(snapshot.data!.elementAt(
                                    activeIndex!)['userNotificationId'])
                                .then((value) {
                              widget.notifyParent();
                              // setState(() {});
                            });
                            setToList();
                          },
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
                                    if (snapshot.data!
                                            .elementAt(index)['title'] !=
                                        null) {
                                      setToNotificationDetail(index);
                                    } else {
                                      setToChat(index);
                                    }
                                  },
                                  child: snapshot.data!.elementAt(index)['title'] !=
                                          null
                                      ? NotificationItem(
                                          title: snapshot.data!
                                              .elementAt(index)['title'],
                                          notificationText: snapshot.data!.elementAt(
                                              index)['notificationText'],
                                          // picturePath: snapshot.data!.elementAt(index)['fromUser']
                                          //         ['userProfile']
                                          // ['profilePicturePath'],
                                          assignedDate: snapshot.data!
                                              .elementAt(index)['assignedDate'])
                                      : MessageItem(
                                          username: snapshot.data!
                                              .elementAt(index)['formUsername'],
                                          notificationText: snapshot.data!.elementAt(
                                              index)['notificationText'],
                                          picturePath: snapshot.data!
                                                      .elementAt(index)['fromUser']
                                                  ['userProfile']
                                              ['profilePicturePath'],
                                          assignedDate: snapshot.data!
                                              .elementAt(index)['assignedDate']));
                            },
                          ),
                        );
                      }
                    } else {
                      return const Text("you have 0 notification");
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
    setState(() {
      _width = 600;
      _visible = false;
    });
    await Future.delayed(Duration(milliseconds: (durMilliseconds / 2).round()));
    setState(() {
      _notificationMode = NotificationMode.chat;
      activeIndex = index;
      _visible = true;
    });
  }

  void setToNotificationDetail(int index) async {
    setState(() {
      _width = 600;
      _visible = false;
    });
    await Future.delayed(Duration(milliseconds: (durMilliseconds / 2).round()));
    setState(() {
      _notificationMode = NotificationMode.notification;
      activeIndex = index;
      _visible = true;
    });
  }

  void setToList() {
    setState(() {
      _notificationMode = NotificationMode.none;
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
