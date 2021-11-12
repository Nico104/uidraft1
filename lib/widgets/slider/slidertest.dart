import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/slider/snapslidertest.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Slidertest extends StatefulWidget {
  const Slidertest({Key? key}) : super(key: key);

  @override
  State<Slidertest> createState() => _SlidertestState();
}

class _SlidertestState extends State<Slidertest> {
  double sliderval = 0;

  @override
  Widget build(BuildContext context) {
    double _value = 0;

    return Material(
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 250,
              // child: Slider(
              //   value: sliderval,
              //   min: 0,
              //   max: 100,
              //   divisions: 23,

              //   activeColor: Theme.of(context).colorScheme.brandColor,
              //   thumbColor: Theme.of(context).colorScheme.brandColor,
              //   // label: sliderval
              //   //     .round()
              //   //     .toString(),
              //   onChanged: (double value) {
              //     setState(() {
              //       sliderval = value;
              //     });
              //   },
              // ),
              // child: SnapSlider(
              //   activeColor: Colors.purple,
              //   divisions: 4,
              //   inactiveColor: Colors.red,
              //   label: 'yy',
              //   onChanged: (double value) {
              //     setState(() {
              //       _value = value;
              //     });
              //   },
              //   onChangeEnd: (double value) {
              //     setState(() {
              //       _value = value;
              //     });
              //   },
              //   onChangeStart: (double value) {
              //     setState(() {
              //       _value = value;
              //     });
              //   },
              //   onSnapValueChanged: (double value) {
              //     setState(() {
              //       _value = value;
              //     });
              //   },
              //   semanticFormatterCallback: (double value) {
              //     return 'dervalue';
              //   },
              //   sliderKey: Key('slidertestsss'),
              //   value: _value,
              // ),
              child: SfSliderTheme(
                data: SfSliderThemeData(
                    thumbColor: Colors.white,
                    thumbRadius: 15,
                    thumbStrokeWidth: 2,
                    thumbStrokeColor: Colors.blue),
                child: Center(
                  child: SfSlider(
                    min: 2.0,
                    max: 10.0,
                    interval: 1,
                    thumbIcon: Icon(Icons.arrow_forward_ios,
                        color: Colors.blue, size: 20.0),
                    showLabels: true,
                    value: _value,
                    onChanged: (dynamic newValue) {
                      setState(() {
                        _value = newValue;
                      });
                    },
                  ),
                ),
              ),
              // child:
              //     JonathansSlider(),
            ),
            const SizedBox(
              width: 40,
            )
          ],
        ),
      ),
    );
  }
}
