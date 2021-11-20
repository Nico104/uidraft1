import 'package:flutter/material.dart';

class DetailNotification extends StatefulWidget {
  const DetailNotification(
      {Key? key,
      required this.title,
      required this.notificationText,
      required this.onBackPressed,
      required this.isLeftHand})
      : super(key: key);

  final String title;
  final String notificationText;

  final bool isLeftHand;

  final Function() onBackPressed;

  @override
  State<DetailNotification> createState() => _DetailNotificationState();
}

class _DetailNotificationState extends State<DetailNotification> {
  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text("yo"));
    return Column(
      children: [
        //Menu
        Row(
          textDirection:
              widget.isLeftHand ? TextDirection.rtl : TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(width: 8),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(14.0),
                //   child: Image.network(
                //     baseURL + widget.picturePath,
                //     fit: BoxFit.contain,
                //     width: 34,
                //     height: 34,
                //   ),
                // ),
                // const SizedBox(width: 4),
                Text(widget.title),
                const SizedBox(width: 8),
              ],
            ),
            IconButton(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () => widget.onBackPressed.call(),
                icon: Icon(
                    widget.isLeftHand ? Icons.arrow_back : Icons.arrow_forward))
          ],
        ),
        //Notification Text
        Text(widget.notificationText)
      ],
    );
  }
}
