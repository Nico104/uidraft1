import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WriteComment extends StatelessWidget {
  const WriteComment(
      {Key? key,
      required this.controller,
      this.onTap,
      required this.onSend,
      required this.focusNode})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function()? onTap;
  final Function() onSend;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      // focusNode: FocusNode(),
      focusNode: focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          // if (event.logicalKey.keyLabel == 'Tab') {
          //   print("Tab pressed");
          //   if (onTab != null) {
          //     onTab!.call();
          //   }
          // }
          if (event.logicalKey.keyLabel == 'Enter') {
            print("Enter pressed");
            onSend.call();
          }
        }
      },
      child: TextFormField(
        onTap: () => onTap!.call(),
        buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) =>
            Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
              alignment: Alignment.centerLeft,
              child:
                  Text(currentLength.toString() + "/" + maxLength.toString())),
        ),
        controller: controller,
        cursorColor: Colors.white,
        autocorrect: false,
        // keyboardType: TextInputType.multiline,
        maxLength: 256,
        minLines: 1,
        maxLines: 20,
        decoration: InputDecoration(
          labelText: "Write a comment",
          labelStyle:
              const TextStyle(fontFamily: "Segoe UI", color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.pink),
          ),
          suffix: InkWell(
            onTap: () {
              controller.text += '\n';
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
            },
            child: const Icon(Icons.segment),
          ),
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return "Field cannot be empty";
          } else {
            return null;
          }
        },
        style: const TextStyle(fontFamily: "Segoe UI", color: Colors.white70),
        onFieldSubmitted: (_) => onSend.call(),
        // onEditingComplete: () => onSend.call(),
        // onSaved: (_) => onSend.call(),
      ),
    );
  }
}
