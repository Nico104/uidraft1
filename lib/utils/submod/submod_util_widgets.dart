import 'package:flutter/material.dart';

///Button showed on each SubMod Subchannel Display Element to Edit saud Element
class SubModEditButton extends StatelessWidget {
  const SubModEditButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple,
      ),
      width: 40,
      height: 40,
      child: const Center(
        child: Icon(Icons.edit),
      ),
    );
  }
}
