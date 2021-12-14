import 'dart:convert';

import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util_methods.dart';

enum VideoPreviewMode { feed, subchannel, profile }

/// Callback when mouse clicked on `Listener` wrapped widget.
Future<void> onPointerDown(BuildContext context, PointerDownEvent event,
    int postId, String subchannelName, String creatorUsername) async {
  // Check if right mouse button clicked
  if (event.kind == PointerDeviceKind.mouse &&
      event.buttons == kSecondaryMouseButton) {
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final menuItem = await showMenu<int>(
        context: context,
        items: [
          const PopupMenuItem(child: Text('Open Video in new tab'), value: 1),
          const PopupMenuItem(
              child: Text('Open Subchannel in new tab'), value: 2),
          const PopupMenuItem(
              child: Text('Open Creator Profile in new tab'), value: 3),
        ],
        position: RelativeRect.fromSize(
            event.position & const Size(48.0, 48.0), overlay.size));
    // Check if menu item clicked
    switch (menuItem) {
      case 1:
        launchURL("http://localhost:55555/#/whatch/$postId");
        break;
      case 2:
        launchURL("http://localhost:55555/#/subchannel/$subchannelName");
        break;
      case 3:
        launchURL("http://localhost:55555/#/profile/$creatorUsername");
        break;
      default:
    }
  } else if (event.kind == PointerDeviceKind.mouse && event.buttons == 4) {
    launchURL("http://localhost:55555/#/whatch/$postId");
  }
}

//Get PostPreview Data by Id
Future<Map<String, dynamic>> fetchPostPreviewData(
    int id, http.Client client) async {
  final response =
      await client.get(Uri.parse(baseURL + 'post/getPostPreviewData/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map.isNotEmpty) {
      return map;
    } else {
      throw Exception('Failed to load post');
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
