import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class WriteMessageDialogLargeScreen extends StatelessWidget {
  const WriteMessageDialogLargeScreen({Key? key, required this.toUsername})
      : super(key: key);

  final String toUsername;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(Radius.circular(24))),
          width: 400,
          alignment: Alignment.center,
          child: WriteMessageDialog(
            toUsername: toUsername,
          )),
    );
  }
}

class WriteMessageDialog extends StatefulWidget {
  const WriteMessageDialog({Key? key, required this.toUsername})
      : super(key: key);

  final String toUsername;

  @override
  _WriteMessageDialogState createState() => _WriteMessageDialogState();
}

class _WriteMessageDialogState extends State<WriteMessageDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController msgController = TextEditingController();

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("to: " + widget.toUsername),
        const SizedBox(height: 15),
        //Message
        Form(
          key: _formKey,
          child: TextFormField(
            controller: msgController,
            // enableSuggestions: false,
            cursorColor: Colors.white70,
            autocorrect: false,
            keyboardType: TextInputType.multiline,
            maxLength: 512,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
              labelText: "Message",
              labelStyle: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.searchBarTextColor),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.brandColor,
                    width: 0.5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.brandColor, width: 2),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            validator: (val) {
              if (val!.isEmpty) {
                return "Message cannot be empty";
              } else {
                return null;
              }
            },
            style:
                const TextStyle(fontFamily: "Segoe UI", color: Colors.white70),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //Submit Button
        SizedBox(
          width: 200,
          height: 40,
          child: TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Theme.of(context).colorScheme.brandColor),
            child: Text(
              'Login',
              style: TextStyle(
                  fontFamily: 'Segoe UI Black',
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.textInputCursorColor),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
