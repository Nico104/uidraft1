import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/notifications/notification_util_methods.dart';
import 'package:uidraft1/widgets/navbar/chatNotification/chat_dialog_widget.dart';
import 'package:uidraft1/widgets/notification/notificationList/notification_list_item_widget.dart';

// import 'package:animations/animations.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool _showChat = false;
  int? activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      // width: 230,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        color: Theme.of(context).colorScheme.searchBarColor,
      ),
      child: FutureBuilder(
          future: fetchUserNotifications(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                print("DEBUZG");
                if (_showChat && activeIndex != null) {
                  return InkWell(
                    onTap: () => setState(() {
                      _showChat = false;
                      activeIndex = null;
                    }),
                    child: ChatNotification(
                        username: snapshot.data!
                            .elementAt(activeIndex!)['formUsername'],
                        notificationText: snapshot.data!
                            .elementAt(activeIndex!)['notificationText'],
                        picturePath:
                            snapshot.data!.elementAt(activeIndex!)['fromUser']
                                ['userProfile']['profilePicturePath']),
                  );
                } else {
                  return SizedBox(
                    width: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => setState(() {
                            _showChat = true;
                            activeIndex = index;
                          }),
                          child: NotificationItem(
                              username: snapshot.data!
                                  .elementAt(index)['formUsername'],
                              notificationText: snapshot.data!
                                  .elementAt(index)['notificationText'],
                              picturePath:
                                  snapshot.data!.elementAt(index)['fromUser']
                                      ['userProfile']['profilePicturePath']),
                        );
                      },
                    ),
                  );
                }

                // return OpenContainer<String>(
                //   openBuilder: (_, closeContainer) => InkWell(
                //     onTap: closeContainer,
                //     child: Container(
                //       color: Colors.blue,
                //       width: 230,
                //       height: 400,
                //     ),
                //   ),
                //   onClosed: (res) => setState(() {
                //     // searchString = res;
                //   }),
                //   tappable: false,
                //   closedBuilder: (_, openContainer) => InkWell(
                //     onTap: openContainer,
                //     child: Container(
                //       color: Colors.green,
                //       width: 400,
                //       height: 800,
                //     ),
                //   ),
                // );
              } else {
                return const Text("you have 0 notification, you lonely f***");
              }
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
