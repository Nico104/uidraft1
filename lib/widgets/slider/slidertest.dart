import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/customIcons/slider/outlines/slider_test_outlines_icons.dart';
import 'dart:math' as math;

import 'package:uidraft1/utils/metrics/post/post_util_methods.dart';

class PostSliderV1 extends StatefulWidget {
  const PostSliderV1({Key? key, this.value = 0, required this.postId})
      : super(key: key);

  final double value;

  // final Function() onChange;
  final int postId;

  @override
  State<PostSliderV1> createState() => _PostSliderV1State();
}

extension on Color {
  Color operator +(Color other) => Color.alphaBlend(this, other);
}

class _PostSliderV1State extends State<PostSliderV1> {
  // double sliderval = 0;
  late double _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  thumbShape: PolygonSliderThumb(
                    thumbRadius: 16.0,
                    sliderValue: _value,
                  ),
                  trackHeight: 8,
                  overlayColor: Colors.transparent,
                  inactiveTrackColor: getColor((_value + 25) / 50),
                  activeTrackColor: getColor((_value + 25) / 50)),
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onDoubleTap: () {
                  if (mounted) {
                    if (_value != 0) {
                      setState(() {
                        _value = 0;
                      });
                      //deleteRating
                      print("delete Post");
                      deletePostRating(widget.postId);
                      EasyDebounce.cancel('postslider');
                    }
                  }
                },
                child: Slider(
                  divisions: 37,
                  max: 25,
                  min: -25,
                  onChanged: (double value) {
                    setState(() {
                      _value = value;
                    });
                    EasyDebounce.debounce(
                        'postslider', // <-- An ID for this particular debouncer
                        const Duration(seconds: 1), // <-- The debounce duration
                        () async {
                      print("WidgetVal: " + widget.value.toString());
                      // if (widget.value == 0) {
                      //   if (value != 0) {
                      //     //createRating
                      //     print("rate Post with " +
                      //         widget.postId.toString() +
                      //         " and " +
                      //         value.round().toString());
                      //     ratePost(widget.postId, value.round());
                      //   }
                      // } else {
                      //   if (value == 0) {
                      //     //deleteRating
                      //     print("delete Post");
                      //     deletePostRating(widget.postId);
                      //   } else {
                      //     //updateRating
                      //     print("update Post");
                      //     updatePostRating(widget.postId, value.round());
                      //   }
                      // }
                      if (value == 0) {
                        //deleteRating
                        print("delete Post");
                        deletePostRating(widget.postId);
                      } else {
                        handleRating(value, widget.postId);
                      }
                    });
                  },
                  value: _value,
                ),
              )),
          const SizedBox(
            width: 40,
          )
        ],
      ),
    );
  }
}

Future<void> handleRating(double value, int postId) async {
  if (await getUserPostRating(postId) == 0) {
    //createRating
    print("rate Post with " +
        postId.toString() +
        " and " +
        value.round().toString());
    ratePost(postId, value.round());
  } else {
    //updateRating
    print("update Post");
    updatePostRating(postId, value.round());
  }
}

class PolygonSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final double sliderValue;

  const PolygonSliderThumb({
    required this.thumbRadius,
    required this.sliderValue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // Define the slider thumb design here
    final Canvas canvas = context.canvas;
    int sides = 4;
    double innerPolygonRadius = thumbRadius * 1.2;
    double outerPolygonRadius = thumbRadius * 1.4;
    double angle = (math.pi * 2) / sides;

    // final outerPathColor = Paint()
    //   ..color = Colors.pink.shade800
    //   ..style = PaintingStyle.fill;

    var outerPath = Path();

    Offset startPoint2 = Offset(
      outerPolygonRadius * math.cos(0.0),
      outerPolygonRadius * math.sin(0.0),
    );

    outerPath.moveTo(
      startPoint2.dx + center.dx,
      startPoint2.dy + center.dy,
    );

    for (int i = 1; i <= sides; i++) {
      double x = outerPolygonRadius * math.cos(angle * i) + center.dx;
      double y = outerPolygonRadius * math.sin(angle * i) + center.dy;
      outerPath.lineTo(x, y);
    }

    outerPath.close();

    // final innerPathColor = Paint()
    //   ..color = sliderTheme.thumbColor ?? Colors.black
    //   ..style = PaintingStyle.fill;

    // final innerPath = Paint()
    //   ..color = sliderTheme.thumbColor ?? Colors.black
    //   ..style = PaintingStyle.fill;
    var innerPath = Path();

    Offset startPoint = Offset(
      innerPolygonRadius * math.cos(0.0),
      innerPolygonRadius * math.sin(0.0),
    );

    innerPath.moveTo(
      startPoint.dx + center.dx,
      startPoint.dy + center.dy,
    );

    for (int i = 1; i <= sides; i++) {
      double x = innerPolygonRadius * math.cos(angle * i) + center.dx;
      double y = innerPolygonRadius * math.sin(angle * i) + center.dy;
      innerPath.lineTo(x, y);
    }

    innerPath.close();

    List<IconData> iconsList = [
      Icons.arrow_forward,
      // LightOutlineNotificationIcon.notification,
      SliderTestOutlines.slidericon4
    ];

    List<IconData> sliderArrowIconList = [
      SliderTestOutlines.slidericon0,
      SliderTestOutlines.slidericon1,
      SliderTestOutlines.slidericon2,
      SliderTestOutlines.slidericon3,
      SliderTestOutlines.slidericon4,
      SliderTestOutlines.slidericon5,
      SliderTestOutlines.slidericon6,
      SliderTestOutlines.slidericon7,
      SliderTestOutlines.slidericon8
    ];

    final IconData icon;
    // if (sliderValue < 0) {
    //   icon = Icons.arrow_back;
    // } else {
    //   // icon = Icons.arrow_forward;
    //   if (sliderValue.round().isOdd) {
    //     icon = iconsList.elementAt(0);
    //   } else {
    //     icon = iconsList.elementAt(1);
    //   }
    // }
    // if (sliderValue == 0) {
    //   icon = sliderArrowIconList.elementAt(0);
    // }else if(sliderValue.abs() ){

    // }
    // switch (sliderValue.abs().round()) {
    //   case 25:
    //     icon = sliderArrowIconList.elementAt(9);
    //     break;
    //   default:
    //     icon = sliderArrowIconList.elementAt(0);
    //     break;
    // }
    int val = sliderValue.abs().round();
    if (val >= 0 && val <= 1) {
      icon = sliderArrowIconList.elementAt(0);
    } else if (val >= 2 && val <= 4) {
      icon = sliderArrowIconList.elementAt(1);
    } else if (val >= 5 && val <= 7) {
      icon = sliderArrowIconList.elementAt(2);
    } else if (val >= 8 && val <= 11) {
      icon = sliderArrowIconList.elementAt(3);
    } else if (val >= 12 && val <= 14) {
      icon = sliderArrowIconList.elementAt(4);
    } else if (val >= 15 && val <= 17) {
      icon = sliderArrowIconList.elementAt(5);
    } else if (val >= 18 && val <= 20) {
      icon = sliderArrowIconList.elementAt(6);
    } else if (val >= 21 && val <= 23) {
      icon = sliderArrowIconList.elementAt(7);
    } else if (val >= 24 && val <= 25) {
      icon = sliderArrowIconList.elementAt(8);
    } else {
      print("nothing bro");
      icon = Icons.bus_alert;
    }

    TextPainter tp = TextPainter(
      // text: icon,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: 40.0,
            fontFamily: icon.fontFamily,
            color: getThumbColor((13 + 25) / 50),
            fontWeight: FontWeight.bold));

    tp.layout();

    Offset textCenter = Offset(
      center.dx - (tp.width / 2),
      center.dy - (tp.height / 2),
    );

    //!Test
    // In your paint method
    // final paint = Paint()
    //   ..shader = RadialGradient(
    //     colors: [
    //       Colors.green,
    //       Colors.red,
    //     ],
    //   ).createShader(Rect.fromCircle(
    //     center: textCenter,
    //     radius: 5,
    //   ));

    // canvas.drawPath(innerPath, paint);
    //!Test

    canvas.translate(center.dx, center.dy);
    // if (sliderValue > 0) {
    //   canvas.rotate(-sliderValue / 16);
    // } else {
    //   canvas.rotate(sliderValue / 16);
    // }
    canvas.rotate((-sliderValue / 16) + 3.1415);

    canvas.translate(-center.dx, -center.dy);

    tp.paint(canvas, textCenter);
  }
}

void rotate(Canvas canvas, double cx, double cy, double angle) {
  canvas.translate(cx, cy);
  canvas.rotate(angle);
  canvas.translate(-cx, -cy);
}

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.blue, Colors.red],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

Color getColor(double op) {
  // final colorC = Color.alphaBlend(Colors.red, Colors.white70);
  final combinedColor = Colors.pink.withOpacity(op) + Colors.blue;
  return combinedColor;
}

Color getThumbColor(double op) {
  // final colorC = Color.alphaBlend(Colors.red, Colors.white70);
  final combinedColor = Colors.red.withOpacity(op) + Colors.green;
  return combinedColor;
}
