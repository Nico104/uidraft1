import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/navicons/dark_mode_switcher_icon.dart';
import 'package:uidraft1/uiwidgets/navicons/left_hand_switcher_icon.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class OptionsGrid extends StatefulWidget {
  const OptionsGrid(
      {Key? key, required this.lhIsLeftHand, required this.lhOnPressed})
      : super(key: key);

  final bool lhIsLeftHand;
  final Function() lhOnPressed;

  @override
  _OptionsGridState createState() => _OptionsGridState();
}

class _OptionsGridState extends State<OptionsGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          color: Theme.of(context).colorScheme.searchBarColor,
        ),
        child: GridView.count(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            LeftHandSwitcherIcon(
                isLeftHand: widget.lhIsLeftHand,
                onPressed: () => widget.lhOnPressed.call(),
                iconSize: 32),
            const DarkModeSwitcherIcon(iconSize: 32),
            const Icon(
              Icons.dark_mode,
              size: 32,
            ),
            const Icon(
              Icons.dark_mode,
              size: 32,
            ),
          ],
        ));
  }
}
