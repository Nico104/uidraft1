import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class JonathansSlider extends StatefulWidget {
  JonathansSlider({Key? key}) : super(key: key);

  @override
  _JonathansSliderState createState() => _JonathansSliderState();
}

class _JonathansSliderState extends State<JonathansSlider> {
  @override
  Widget build(BuildContext context) {
    // return SliderTheme(
    //   data: SliderTheme.of(context).copyWith(
    //     activeTrackColor: Theme.of(context).colorScheme.highlightColor,
    //     inactiveTrackColor: Theme.of(context)
    //         .colorScheme
    //         .videoPlayerIconBackgroundColor
    //         .withOpacity(0.6),
    //     // trackShape: RectangularSliderTrackShape(),
    //     trackHeight: 10,
    //     thumbColor: Theme.of(context).colorScheme.highlightColor,
    //     thumbShape: const RoundSliderThumbShape(
    //         enabledThumbRadius: 7,
    //         elevation: 0,
    //         pressedElevation: 0,
    //         disabledThumbRadius: 7),

    //     overlayColor: Colors.transparent,
    //     // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
    //   ),
    //   child: Slider(
    //     mouseCursor: SystemMouseCursors.resizeUpDown,

    //     value: 0,
    //     min: 0,
    //     max: 100,
    //     //divisions: 20,
    //     //label: (_controller!.value.volume * 100).round().toString(),
    //     onChanged: (double value) {
    //       // if (mounted) {
    //       //   setState(() {
    //       //     _controller
    //       //         .setVolume(
    //       //             value /
    //       //                 100);
    //       //   });
    //       // }

    //       // if (!_showMenu) {
    //       //   if (mounted) {
    //       //     setState(() {
    //       //       _showMenu = true;
    //       //       print(
    //       //           "_showMenu set to true");
    //       //     });
    //       //   }

    //       //   Future.delayed(
    //       //       const Duration(
    //       //           seconds: 5),
    //       //       () {
    //       //     if (_showMenu) {
    //       //       if (mounted) {
    //       //         setState(() {
    //       //           _showMenu =
    //       //               false;
    //       //           print(
    //       //               "_showMenu set to false");
    //       //         });
    //       //       }
    //       //     }
    //       //   });
    //       // }
    //     },
    //   ),
    // );
    dynamic _lowerValue;
    dynamic _upperValue;
    return FlutterSlider(
      values: [100, 200, 300],
      max: 500,
      min: 0,
      onDragging: (handlerIndex, lowerValue, upperValue) {
        _lowerValue = lowerValue;
        _upperValue = upperValue;
        setState(() {});
      },
    );
  }
}
