import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/widgets/keyhandler/textformfield_tab_handler_widget.dart';

/// Return a rounded TextFormField with an obscure Text option, which is default on,
/// a CapsLock on Warning
/// and being themed and decorated accordingly
/// Requires a TextEditingController for [controller],
/// a String for [labelText]. Will be shown as hint and eventually animate inside the topLeft border
/// a Double for [fontSize]. Will size all Text accordingly
/// a FocusNode() for [focusNode]. Is needed so other TextFormFields can Tab to this TextFormField
///
/// [errorText] takes in a String to show a custom errorText
/// [onFieldSubmitted] is called when the Enter-Key is pressed while the TextFormField is focused
/// [validator] is called when a Parent Form widget is validated
/// [autofocus] takes in a bool and automatically requests Focus accordingly on Widget build
/// [onTab] is called when the Tabulator Key is pressed while the TextFormField is focused
class TextFormFieldPassword extends StatefulWidget {
  const TextFormFieldPassword({
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

  @override
  _TextFormFieldPasswordState createState() => _TextFormFieldPasswordState();
}

class _TextFormFieldPasswordState extends State<TextFormFieldPassword> {
  bool _obscure = true;
  bool _capsLockOn = false;

  @override
  void initState() {
    super.initState();

    ///Initially check if CapsLock is on or off
    if (HardwareKeyboard.instance.lockModesEnabled
            .contains(KeyboardLockMode.capsLock) !=
        _capsLockOn) {
      setState(() {
        _capsLockOn = !_capsLockOn;
      });
    }

    ///Call [_onFocusChange] on every focus change the [focusNode] experiences
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  ///Chekcs if CapsLock is on or off and updates the TextFormField accordingly
  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      if (HardwareKeyboard.instance.lockModesEnabled
              .contains(KeyboardLockMode.capsLock) !=
          _capsLockOn) {
        setState(() {
          _capsLockOn = !_capsLockOn;
        });
      }
    }
  }

  void checkAndToggleCapsLock() {
    if (HardwareKeyboard.instance.lockModesEnabled
            .contains(KeyboardLockMode.capsLock) !=
        _capsLockOn) {
      setState(() {
        _capsLockOn = !_capsLockOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldTabHandler(
      focusNode: widget.focusNode,
      onTab: () => widget.onTab!.call(),
      onCapsLock: () => checkAndToggleCapsLock.call(),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              autofocus: widget.autofocus,
              controller: widget.controller,
              obscureText: _obscure,
              style: TextStyle(
                  fontSize: widget.fontSize > 2 ? widget.fontSize : 2,
                  fontFamily: 'Segoe UI',
                  letterSpacing: 0.3),
              cursorColor: Theme.of(context).colorScheme.textInputCursorColor,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.brandColor,
                      width: 0.5),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.brandColor,
                      width: 2),
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
                    right:
                        ((widget.fontSize > 2 ? widget.fontSize : 2) / 3) * 2),
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

                //Obscure Password Icon
                suffixIcon: IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () => setState(() {
                    _obscure = !_obscure;
                  }),
                  icon: _obscure
                      ? Icon(Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor)
                      : Icon(Icons.visibility_off_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor),
                ),
              ),
              validator: (value) => widget.validator!.call(value),
              onFieldSubmitted: (_) => widget.onFieldSubmitted!.call(_),
            ),
          ),
          _capsLockOn
              ? const Tooltip(
                  message: "CapsLock is on boy", child: Icon(Icons.lock))
              : const SizedBox()
        ],
      ),
    );
  }
}
