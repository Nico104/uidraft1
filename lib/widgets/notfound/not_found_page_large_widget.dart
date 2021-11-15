import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class NotFoundLarge extends StatelessWidget {
  const NotFoundLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("404 bro, I am sorry"),
        const SizedBox(height: 25),
        TextButton(
            onPressed: () => Beamer.of(context).beamToNamed('/feed'),
            child: Text("Back to Home"))
      ],
    );
  }
}
