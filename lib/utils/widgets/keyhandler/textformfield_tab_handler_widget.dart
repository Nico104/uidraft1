import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldTabHandler extends StatelessWidget {
  const TextFormFieldTabHandler(
      {Key? key,
      required this.focusNode,
      this.onTab,
      required this.child,
      this.onCapsLock})
      : super(key: key);

  final FocusNode focusNode;
  final Function()? onTab;
  final Widget child;

  final Function()? onCapsLock;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey.keyLabel == 'Tab') {
            print("Tab pressed");
            if (onTab != null) {
              onTab!.call();
            }
          }
          if (onCapsLock != null) {
            onCapsLock!.call();
          }
        }
      },
      child: child,
    );
  }
}
