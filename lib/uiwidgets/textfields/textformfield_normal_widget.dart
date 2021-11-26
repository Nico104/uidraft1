import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/widgets/keyhandler/textformfield_tab_handler_widget.dart';

class TextFormFieldNormal extends StatelessWidget {
  const TextFormFieldNormal(
      {Key? key,
      required this.controller,
      this.errorText,
      this.onFieldSubmitted,
      required this.labelText,
      this.validator,
      this.autofocus = false,
      required this.fontSize,
      required this.focusNode,
      this.onTab})
      : super(key: key);

  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onFieldSubmitted;
  final String labelText;
  final String? Function(String?)? validator;
  final bool autofocus;
  final double fontSize;

  final FocusNode focusNode;
  final Function()? onTab;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldTabHandler(
      focusNode: focusNode,
      onTab: () => onTab!.call(),
      child: TextFormField(
        autofocus: autofocus,
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
              fontSize: fontSize > 2 ? fontSize - 1 : 1,
              fontFamily: 'Segoe UI'),
          errorText: errorText,
        ),
        validator: (value) => validator!.call(value),
        onFieldSubmitted: onFieldSubmitted != null
            ? (_) => onFieldSubmitted!.call(_)
            : (_) {},
      ),
    );
  }
}
