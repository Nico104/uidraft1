import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class VideoPreviewUsernameLarge extends StatelessWidget {
  const VideoPreviewUsernameLarge({Key? key, required this.username})
      : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      excludeFromSemantics: true,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Beamer.of(context).beamToNamed('profile/' + username);
      },
      child: Listener(
        // onPointerDown: (ev) => vputils.onPointerDownUser(
        //     context, ev, snapshot.data!['username'].toString()),
        child: Row(
          children: [
            //Icon
            Icon(
              Icons.person_outline_outlined,
              color: Theme.of(context).colorScheme.navBarIconColor,
              size: 17,
            ),
            const SizedBox(
              width: 4,
            ),
            //Username
            Text(username),
          ],
        ),
      ),
    );
  }
}
