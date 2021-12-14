import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

import '../util_methods.dart';

enum Menu { none, menu, notification, customfeed, options }

///Returns the number count of unseen notifications the logged in User has
Future<int> getMyUnseenNotificationCount(http.Client client) async {
  String? token = await getToken();
  final response = await client.get(
    Uri.parse(baseURL + 'user/getMyUnseenNotificationsCount'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("Status Code: " + response.statusCode.toString());
  print("Notification Count" + response.body);

  int result = json.decode(response.body)['_count']['userNotificationId'];
  return result;
}

Future<void> onLogoPointerDown(
    BuildContext context, PointerDownEvent event) async {
  // Check if right mouse button clicked
  if (event.kind == PointerDeviceKind.mouse &&
      event.buttons == kSecondaryMouseButton) {
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final menuItem = await showMenu<int>(
        context: context,
        items: [
          const PopupMenuItem(child: Text('Open in new tab'), value: 1),
        ],
        position: RelativeRect.fromSize(
            event.position & const Size(48.0, 48.0), overlay.size));
    // Check if menu item clicked
    switch (menuItem) {
      case 1:
        launchURL("http://localhost:55555/#/feed");
        break;
      default:
    }
  } else if (event.kind == PointerDeviceKind.mouse && event.buttons == 4) {
    launchURL("http://localhost:55555/#/feed");
  }
}
