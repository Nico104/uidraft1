import 'dart:convert';

import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        _launchURL("http://localhost:55555/#/whatch/$postId");
        break;
      case 2:
        _launchURL("http://localhost:55555/#/subchannel/$subchannelName");
        break;
      case 3:
        _launchURL("http://localhost:55555/#/profile/$creatorUsername");
        break;
      default:
    }
  } else if (event.kind == PointerDeviceKind.mouse && event.buttons == 4) {
    _launchURL("http://localhost:55555/#/whatch/$postId");
  }
}

// Future<void> onPointerDownSubchannel(
//     BuildContext context, PointerDownEvent event, String subchannelname) async {
//   // Check if right mouse button clicked
//   if (event.kind == PointerDeviceKind.mouse &&
//       event.buttons == kSecondaryMouseButton) {
//     final overlay =
//         Overlay.of(context)!.context.findRenderObject() as RenderBox;
//     final menuItem = await showMenu<int>(
//         context: context,
//         items: [
//           const PopupMenuItem(
//               child: Text('Open Subchannel in new tab'), value: 1),
//           const PopupMenuItem(child: Text('gfy'), value: 2),
//         ],
//         position: RelativeRect.fromSize(
//             event.position & const Size(48.0, 48.0), overlay.size));
//     // Check if menu item clicked
//     switch (menuItem) {
//       case 1:
//         // html.window
//         //     .open('https://stackoverflow.com/questions/ask', 'new tab');
//         _launchURL("http://localhost:55555/#/subchannel/$subchannelname");
//         break;
//       case 2:
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text('Cut clicked'), behavior: SnackBarBehavior.floating));
//         break;
//       default:
//     }
//   } else if (event.kind == PointerDeviceKind.mouse && event.buttons == 4) {
//     _launchURL("http://localhost:55555/#/subchannel/$subchannelname");
//   }
// }

// Future<void> onPointerDownUser(
//     BuildContext context, PointerDownEvent event, String username) async {
//   // Check if right mouse button clicked
//   if (event.kind == PointerDeviceKind.mouse &&
//       event.buttons == kSecondaryMouseButton) {
//     final overlay =
//         Overlay.of(context)!.context.findRenderObject() as RenderBox;
//     final menuItem = await showMenu<int>(
//         context: context,
//         items: [
//           const PopupMenuItem(child: Text('Open in new tab'), value: 1),
//           const PopupMenuItem(child: Text('Cut'), value: 2),
//         ],
//         position: RelativeRect.fromSize(
//             event.position & const Size(48.0, 48.0), overlay.size));
//     // Check if menu item clicked
//     switch (menuItem) {
//       case 1:
//         // html.window
//         //     .open('https://stackoverflow.com/questions/ask', 'new tab');
//         _launchURL("http://localhost:55555/#/username/$username");
//         break;
//       case 2:
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text('Cut clicked'), behavior: SnackBarBehavior.floating));
//         break;
//       default:
//     }
//   } else if (event.kind == PointerDeviceKind.mouse && event.buttons == 4) {
//     _launchURL("http://localhost:55555/#/whatch/username/$username");
//   }
// }

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//Get PostPreview Data by Id
Future<Map<String, dynamic>> fetchPostPreviewData(int id) async {
  final response =
      await http.get(Uri.parse(baseURL + 'post/getPostPreviewData/$id'));

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
