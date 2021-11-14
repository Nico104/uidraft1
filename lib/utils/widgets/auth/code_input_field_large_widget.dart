import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class CodeInputField extends StatelessWidget {
  const CodeInputField({
    Key? key,
    required this.focusNode,
    required this.handleInputAction,
    required this.handleDeleteAction,
    required TextEditingController codeDigitController,
  })  : _codeDigitController = codeDigitController,
        super(key: key);

  final FocusNode focusNode;
  final Function() handleInputAction;
  final Function() handleDeleteAction;
  final TextEditingController _codeDigitController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 70,
      child: KeyboardListener(
        focusNode: FocusNode(
            canRequestFocus: false,
            descendantsAreFocusable: true), // or FocusNode()
        // onKey: (event) {
        //   if (event.logicalKey == LogicalKeyboardKey.backspace) {
        //     // here you can check if textfield is focused
        //     print('backspace clicked');
        //   }
        // },
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.backspace) {
              print("Delte pressed");
              handleDeleteAction.call();
              // fnUseremail.requestFocus();
            }
          }
        },
        child: TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: focusNode,
            expands: true,
            controller: _codeDigitController,
            maxLength: 1,
            maxLines: null,
            minLines: null,
            style: const TextStyle(
                fontSize: 36, fontFamily: 'Segoe UI', letterSpacing: 0.3),
            cursorColor: Theme.of(context).colorScheme.textInputCursorColor,
            showCursor: false,
            decoration: InputDecoration(
                counterText: "",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.brandColor,
                      width: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.brandColor,
                      width: 3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                isDense: true,
                contentPadding: const EdgeInsets.only(
                    bottom: 15, top: 15, left: 15, right: 10),
                //Error
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // errorStyle: const TextStyle(fontSize: 14.0, fontFamily: 'Segoe UI'),
                errorText: null),
            validator: (value) {
              //Check if username is free
              if (value == null || value.isEmpty) {
                return 'You may choose a username, sir';
              }
              return null;
            },
            onChanged: (val) {
              if (val == "") {
                print("goback");
              } else {
                handleInputAction.call();
              }
            },
            onTap: () => _codeDigitController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _codeDigitController.value.text.length)
            // onTap: () => handleInputAction.call(),
            // onFieldSubmitted: (_) => submit(),
            ),
      ),
    );
  }
}
