import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class ChatNotification extends StatefulWidget {
  const ChatNotification(
      {Key? key,
      required this.username,
      required this.notificationText,
      required this.picturePath})
      : super(key: key);

  final String username;
  final String notificationText;
  final String picturePath;

  @override
  State<ChatNotification> createState() => _ChatNotificationState();
}

class _ChatNotificationState extends State<ChatNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        color: Colors.green,
      ),
      width: 600,
      height: 800,
    );
  }
}
