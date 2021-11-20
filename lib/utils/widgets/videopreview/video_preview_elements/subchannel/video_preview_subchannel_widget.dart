import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class VideoPreviewSubchannelLarge extends StatelessWidget {
  const VideoPreviewSubchannelLarge({Key? key, required this.subchannelname})
      : super(key: key);

  final String subchannelname;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      excludeFromSemantics: true,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Beamer.of(context).beamToNamed('subchannel/' + subchannelname);
        print("go to subchnanel or profile");
      },
      child: Row(
        children: [
          //Subchannel Icon
          Icon(
            Icons.smart_display_outlined,
            color: Theme.of(context).colorScheme.navBarIconColor,
            size: 17,
          ),
          const SizedBox(
            width: 4,
          ),
          //Subchannelname
          Text('c/' + subchannelname),
        ],
      ),
    );
  }
}
