import 'package:flutter/material.dart';
import 'package:uidraft1/customIcons/light_outlined/light_outline_notification_icon_icons.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class EmptyNavbarProfileRow extends StatelessWidget {
  const EmptyNavbarProfileRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Notifications
        Row(
          children: [
            Icon(
              LightOutlineNotificationIcon.notification,
              color: Theme.of(context).colorScheme.navBarIconColor,
              size: 24,
            ),
          ],
        ),
        const SizedBox(
          width: 18,
        ),
        //Dark Light Mode Switch
        // widget.theme
        //     ? const DarkModeSwitcherIcon()
        //     : const SizedBox(),
        // const SizedBox(
        //   width: 18,
        // ),
        //CustomFeedSelection
        Icon(
          Icons.filter_list_outlined,
          color: Theme.of(context).colorScheme.navBarIconColor,
          size: 30,
        ),
        const SizedBox(
          width: 18,
        ),
        //Options Menu
        Row(
          children: [
            Icon(
              Icons.apps_outlined,
              color: Theme.of(context).colorScheme.navBarIconColor,
              size: 26,
            ),
          ],
        ),
        const SizedBox(width: 32),
        //ProfilePicture
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0), color: Colors.grey),
        )
      ],
    );
  }
}
