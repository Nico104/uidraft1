import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/slider/snapslidertest.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'dart:math' as math;

class Slidertest extends StatefulWidget {
  const Slidertest({Key? key}) : super(key: key);

  @override
  State<Slidertest> createState() => _SlidertestState();
}

extension on Color {
  Color operator +(Color other) => Color.alphaBlend(this, other);
}

class _SlidertestState extends State<Slidertest> {
  double sliderval = 0;
  double _value = 0;

  Color getColor(double op) {
    // final colorC = Color.alphaBlend(Colors.red, Colors.white70);
    final combinedColor = Colors.pink.withOpacity(op) + Colors.blue;
    return combinedColor;
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

    final outerPathColor = Paint()
      ..color = Colors.pink.shade800
      ..style = PaintingStyle.fill;

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
    // canvas.drawPath(outerPath, outerPathColor);

    final innerPathColor = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.black
      ..style = PaintingStyle.fill;

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
    // canvas.drawPath(innerPath, innerPathColor);

    // TextSpan span = new TextSpan(
    //   style: new TextStyle(
    //     fontSize: thumbRadius,
    //     fontWeight: FontWeight.w700,
    //     color: Colors.white,
    //   ),
    //   text: sliderValue.round().toString(),
    // );

    final IconData icon;
    if (sliderValue < 0) {
      icon = Icons.arrow_back;
    } else {
      icon = Icons.arrow_forward;
    }

    TextPainter tp = TextPainter(
      // text: icon,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: 40.0, fontFamily: icon.fontFamily, color: Colors.white));

    tp.layout();

    Offset textCenter = Offset(
      center.dx - (tp.width / 2),
      center.dy - (tp.height / 2),
    );

    canvas.translate(center.dx, center.dy);
    if (sliderValue > 0) {
      canvas.rotate(-sliderValue / 16);
    } else {
      canvas.rotate(sliderValue / 16);
    }

    // canvas.rotate(1.5625);
    canvas.translate(-center.dx, -center.dy);

    tp.paint(canvas, textCenter);

    // final icon = Icons.add;
    // TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    // textPainter.text = TextSpan(
    //     text: String.fromCharCode(icon.codePoint),
    //     style: TextStyle(
    //         fontSize: 40.0, fontFamily: icon.fontFamily, color: Colors.white));
    // textPainter.layout();
    // textPainter.paint(canvas, Offset(center.dx - (tp.width / 2), 0));
  }
}

void rotate(Canvas canvas, double cx, double cy, double angle) {
  canvas.translate(cx, cy);
  canvas.rotate(angle);
  canvas.translate(-cx, -cy);
}
