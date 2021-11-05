import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/notifications/notification_util_methods.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem(
      {Key? key,
      required this.username,
      required this.notificationText,
      required this.picturePath})
      : super(key: key);

  final String username;
  final String notificationText;
  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    baseURL + picturePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(notificationText),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  "5 min ago",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ],
    );
  }
}
