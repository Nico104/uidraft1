import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/notifications/notification_util_methods.dart';

class WriteMessageDialogLargeScreen extends StatelessWidget {
  const WriteMessageDialogLargeScreen({Key? key, required this.toUsername})
      : super(key: key);

  final String toUsername;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          width: 600,
          height: 500,
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
  TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //To User
              const SizedBox(height: 15),
              Text("to: " + widget.toUsername),
              const SizedBox(height: 15),
              //Message
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: TextFormField(
                    autofocus: true,
                    controller: _msgController,
                    cursorColor: Colors.white70,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    maxLength: 512,
                    minLines: 1,
                    maxLines: 15,
                    decoration: InputDecoration(
                      labelText: "Message",
                      labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color:
                              Theme.of(context).colorScheme.searchBarTextColor),
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
                      //Error
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 12.0, fontFamily: 'Segoe UI'),
                    ),
                    validator: (val) {
                      val = val!.trim();
                      if (val.isEmpty) {
                        return "Message cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(
                        fontFamily: "Segoe UI", color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
          //Submit Button
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.brandColor),
                  child: Text(
                    'Send',
                    style: TextStyle(
                        fontFamily: 'Segoe UI Black',
                        fontSize: 18,
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendMessageToUser(widget.toUsername, _msgController.text,
                              connection.returnConnection())
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ],
      );
    });
  }
}
