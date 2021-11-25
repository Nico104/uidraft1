import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class TextFormFieldCheck extends StatefulWidget {
  const TextFormFieldCheck({
    Key? key,
    required this.controller,
    this.errorText,
    this.onFieldSubmitted,
    required this.labelText,
    this.validator,
    this.autofocus = false,
    required this.fontSize,
    required this.focusNode,
    this.onTab,
    required this.checking,
  }) : super(key: key);

  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onFieldSubmitted;
  final String labelText;
  final String? Function(String?)? validator;
  final bool autofocus;
  final double fontSize;

  final FocusNode focusNode;
  final Function()? onTab;

  final Future<bool> checking;

  @override
  _TextFormFieldCheckState createState() => _TextFormFieldCheckState();
}

class _TextFormFieldCheckState extends State<TextFormFieldCheck> {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: widget.focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey.keyLabel == 'Tab') {
            print("Tab pressed");
            if (widget.onTab != null) {
              widget.onTab!.call();
            }
          }
        }
      },
      child: TextFormField(
        autofocus: widget.autofocus,
        controller: widget.controller,
        style: TextStyle(
            fontSize: widget.fontSize > 2 ? widget.fontSize : 2,
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
          labelText: widget.labelText,
          labelStyle: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: widget.fontSize > 2 ? widget.fontSize : 2,
              color: Theme.of(context).colorScheme.searchBarTextColor),
          isDense: true,
          contentPadding: EdgeInsets.only(
              bottom: widget.fontSize > 2 ? widget.fontSize : 2,
              top: widget.fontSize > 2 ? widget.fontSize : 2,
              left: widget.fontSize > 2 ? widget.fontSize : 2,
              right: ((widget.fontSize > 2 ? widget.fontSize : 2) / 3) * 2),
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
              fontSize: widget.fontSize > 2 ? widget.fontSize - 1 : 1,
              fontFamily: 'Segoe UI'),
          errorText: widget.errorText,
          suffixIcon: widget.controller.text.isNotEmpty
              ? FutureBuilder(
                  future: widget.checking,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return const Icon(Icons.check);
                      } else {
                        return const Icon(Icons.cancel);
                      }
                    } else {
                      return Transform.scale(
                          scale: 0.5, child: const CircularProgressIndicator());
                    }
                  },
                )
              : null,
        ),
        validator: (value) => widget.validator!.call(value),
        onFieldSubmitted: (_) => widget.onFieldSubmitted!.call(_),
        onChanged: (_) {
          EasyDebounce.debounce(
              'checking' +
                  widget.focusNode.toStringShort() +
                  'TextField-debouncer', // <-- An ID for this particular debouncer
              const Duration(milliseconds: 500), // <-- The debounce duration
              () => setState(() {})); // <-- The target method
        },
      ),
    );
  }
}
