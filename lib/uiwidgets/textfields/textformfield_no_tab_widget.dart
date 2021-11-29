import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/widgets/keyhandler/textformfield_tab_handler_widget.dart';

/// Return a rounded TextFormField with no other special Attributes other that
/// being themed and decorated accordingly
/// Requires a TextEditingController for [controller],
/// a String for [labelText]. Will be shown as hint and eventually animate inside the topLeft border
/// a Double for [fontSize]. Will size all Text accordingly
/// a FocusNode() for [focusNode]. Is needed so other TextFormFields can Tab to this TextFormField
///
/// [errorText] takes in a String to show a custom errorText
/// [onFieldSubmitted] is called when the Enter-Key is pressed while the TextFormField is focused
/// [validator] is called when a Parent Form widget is validated
/// [autofocus] takes in a bool and automatically requests Focus accordingly on Widget build
class TextFormFieldNoTab extends StatelessWidget {
  const TextFormFieldNoTab({
    Key? key,
    required this.controller,
    this.errorText,
    this.onFieldSubmitted,
    required this.labelText,
    this.validator,
    this.autofocus = false,
    required this.fontSize,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onFieldSubmitted;
  final String labelText;
  final String? Function(String?)? validator;
  final bool autofocus;
  final double fontSize;

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      focusNode: focusNode,
      controller: controller,
      style: TextStyle(
          fontSize: fontSize > 2 ? fontSize : 2,
          fontFamily: 'Segoe UI',
          letterSpacing: 0.3),
      cursorColor: Theme.of(context).colorScheme.textInputCursorColor,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.brandColor, width: 0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.brandColor, width: 2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        labelText: labelText,
        labelStyle: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: fontSize > 2 ? fontSize : 2,
            color: Theme.of(context).colorScheme.searchBarTextColor),
        isDense: true,
        contentPadding: EdgeInsets.only(
            bottom: fontSize > 2 ? fontSize : 2,
            top: fontSize > 2 ? fontSize : 2,
            left: fontSize > 2 ? fontSize : 2,
            right: ((fontSize > 2 ? fontSize : 2) / 3) * 2),
        //Error
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 3),
          borderRadius: BorderRadius.circular(30.0),
        ),
        errorStyle: TextStyle(
            fontSize: fontSize > 2 ? fontSize - 1 : 1, fontFamily: 'Segoe UI'),
        errorText: errorText,
      ),
      validator: (value) => validator!.call(value),
      onFieldSubmitted:
          onFieldSubmitted != null ? (_) => onFieldSubmitted!.call(_) : (_) {},
    );
  }
}
