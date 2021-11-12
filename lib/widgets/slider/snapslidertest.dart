import 'package:flutter/material.dart';

class SnapSlider extends StatefulWidget {
  SnapSlider({
    Key? key,
    required this.sliderKey,
    this.snapValues = const {},
    required this.value,
    required this.onSnapValueChanged,
    this.snapDistance = 0.05,
    this.animCurve: Curves.fastOutSlowIn,
    this.animDuration: const Duration(milliseconds: 350),
    this.min: 0.0,
    this.max: 1.0,
    required this.label,
    required this.divisions,
    required this.onChanged,
    required this.onChangeEnd,
    required this.onChangeStart,
    required this.activeColor,
    required this.inactiveColor,
    required this.semanticFormatterCallback,
  })  : assert(snapValues != null),
        assert(snapValues.every((it) => it >= min && it <= max),
            'Each snap value needs to be within slider values range.'),
        super(key: key);

  final Key sliderKey;

  final Set<double> snapValues;

  final double value;

  final ValueChanged<double> onSnapValueChanged;

  final double snapDistance;

  final Curve animCurve;

  final Duration animDuration;

  final double min;

  final double max;

  final String label;

  final int divisions;

  final Color activeColor;

  final Color inactiveColor;

  final ValueChanged<double> onChanged;

  final ValueChanged<double> onChangeEnd;

  final ValueChanged<double> onChangeStart;

  final SemanticFormatterCallback semanticFormatterCallback;

  @override
  _StepSliderState createState() => _StepSliderState();
}

class _StepSliderState extends State<SnapSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animator;
  late CurvedAnimation _baseAnim;
  late Animation<double> _animation;
  late double? _lastSnapValue;

  @override
  void didUpdateWidget(SnapSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animator.duration = widget.animDuration;
    _baseAnim.curve = widget.animCurve;
  }

  @override
  void initState() {
    super.initState();
    _animator = AnimationController(
        vsync: this, duration: widget.animDuration, value: 1.0);
    _baseAnim = CurvedAnimation(parent: _animator, curve: widget.animCurve);
    _recreateAnimation(widget.value, widget.value);
    _animation.addListener(() {
      _onSliderChanged(_animation.value);
      widget.onChanged.call(_animation.value);
    });
  }

  @override
  void dispose() {
    _animator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animator,
      builder: (_, __) => Slider(
        key: widget.sliderKey,
        min: widget.min,
        max: widget.max,
        label: widget.label,
        divisions: widget.divisions,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        semanticFormatterCallback: widget.semanticFormatterCallback,
        value: widget.value,
        onChangeStart: (it) {
          _animator.stop();
          _onSliderChangeStart(it);
          widget.onChangeStart.call(it);
        },
        onChangeEnd: (it) {
          _onSliderChangeEnd(it);
          widget.onChangeEnd.call(it);
        },
        onChanged: (it) {
          _onSliderChanged(it);
          widget.onChanged.call(it);
        },
      ),
    );
  }

  void _onSliderChangeStart(double value) {}

  void _onSliderChangeEnd(double value) {
    double snapValue = _closestSnapValue(value);
    var distance = (value - snapValue).abs();
    if (snapValue != _lastSnapValue) {
      if (distance <= widget.snapDistance) {
        _animateTo(widget.value, snapValue, true);
        widget.onSnapValueChanged.call(widget.value);
        _lastSnapValue = snapValue;
      }
    } else {
      if (distance > widget.snapDistance) {
        _lastSnapValue = null;
      }
    }
  }

  double _closestSnapValue(double value) {
    return widget.snapValues.reduce((a, b) {
      var distanceA = (value - a).abs();
      var distanceB = (value - b).abs();
      return distanceA < distanceB ? a : b;
    });
  }

  void _onSliderChanged(double value) {}

  void _animateTo(double start, double end, bool restart) {
    _recreateAnimation(start, end);
    _animator.forward(from: 0.0);
  }

  void _recreateAnimation(double start, double end) {
    _animation = Tween(begin: start, end: end).animate(_baseAnim);
  }
}
