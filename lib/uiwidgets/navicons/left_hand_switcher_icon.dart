import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class LeftHandSwitcherIcon extends StatelessWidget {
  const LeftHandSwitcherIcon(
      {Key? key,
      required this.isLeftHand,
      required this.onPressed,
      this.iconSize})
      : super(key: key);

  final bool isLeftHand;
  final Function() onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          isLeftHand ? Icons.switch_left : Icons.switch_right,
          color: Theme.of(context).colorScheme.navBarIconColor,
          size: 24,
        ),
        onPressed: () => onPressed.call());
  }
}
