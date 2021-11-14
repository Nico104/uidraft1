import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';

class SubModUpdateAboutDialog extends StatefulWidget {
  const SubModUpdateAboutDialog({Key? key, required this.subchannelName})
      : super(key: key);

  final String subchannelName;

  @override
  State<SubModUpdateAboutDialog> createState() =>
      _SubModUpdateAboutDialogState();
}

class _SubModUpdateAboutDialogState extends State<SubModUpdateAboutDialog> {
  final TextEditingController _subchannelAboutTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.5, -0.4),
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink,
                  Colors.blue,
                ],
              )),
          width: 400,
          height: 650,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: //About
                TextFormField(
              controller: _subchannelAboutTextController,
              // enableSuggestions: false,
              cursorColor: Colors.white,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              maxLength: 512,
              minLines: null,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "About...",
                labelStyle: const TextStyle(
                    fontFamily: "Segoe UI", color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Field cannot be empty";
                } else {
                  return null;
                }
              },
              style:
                  const TextStyle(fontFamily: "Segoe UI", color: Colors.white),
              onChanged: (text) {
                EasyDebounce.debounce(
                    'subchannelNameTextField-debouncer', // <-- An ID for this particular debouncer
                    const Duration(
                        milliseconds: 500), // <-- The debounce duration
                    () => updateSubchannelAboutText(
                        widget.subchannelName, text) // <-- The target method
                    );
              },
            ),
          ),
        ),
      ),
    );
  }
}
// shape:
//     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
// color: Colors.green,
