import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class NotFoundLarge extends StatelessWidget {
  const NotFoundLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Text("404 bro, I am sorry"),
    //     const SizedBox(height: 25),
    //     TextButton(
    //         onPressed: () => Beamer.of(context).beamToNamed('/feed'),
    //         child: Text("Back to Home"))
    //   ],
    // );
    return Container(
      width: double.infinity,
      color: Colors.deepPurple.shade900,
      child: Stack(
        children: [
          const RiveAnimation.asset('assets/animations/rive/space_coffee.riv'),
          Align(
            alignment: const Alignment(0, -0.7),
            child: Column(
              children: [
                const Text(
                  "404",
                  style: TextStyle(fontSize: 186, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                TextButton(
                    onPressed: () => Beamer.of(context).beamToNamed('/feed'),
                    child: Text("Back to Home"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
