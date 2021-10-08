import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorFeed extends StatelessWidget{
  const ErrorFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("There was an error while loading your Feed"),
          OutlinedButton(onPressed: () => Beamer.of(context).beamToNamed("/feed"), child: const Text("Reload Feed"))
        ],
      ),
    );
  }

}