import 'package:flutter/material.dart';

class SubModPostButton extends StatelessWidget {
  const SubModPostButton({
    Key? key,
    required this.color,
    required this.iconData,
    required this.toolTipMsg,
    required this.handeleTap,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String toolTipMsg;
  final Function() handeleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            side: BorderSide(width: 2, color: color),
          ),
          onPressed: handeleTap.call(),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(iconData, size: 22, color: color),
          ),
        ),
        const SizedBox(width: 0),
        Tooltip(
            // padding: EdgeInsets.all(20),
            margin: const EdgeInsets.all(4),
            // showDuration: Duration(seconds: 10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            textStyle: const TextStyle(color: Colors.white),
            preferBelow: true,
            verticalOffset: 20,
            message: toolTipMsg,
            child: Icon(Icons.info, size: 20, color: color)),
      ],
    );
  }
}
