import 'package:flutter/material.dart';
import 'package:uidraft1/utils/util_methods.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem(
      {Key? key,
      required this.title,
      required this.notificationText,
      // required this.picturePath,
      required this.assignedDate})
      : super(key: key);

  final String title;
  final String notificationText;
  // final String picturePath;
  final String assignedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 8,
          child: Row(
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(8.0),
              //       child: Image.network(
              //         baseURL + picturePath,
              //         fit: BoxFit.cover,
              //         alignment: Alignment.center,
              //         width: 40,
              //         height: 40,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 40,
                width: 8,
              ),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatNotificationDate(assignedDate),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
