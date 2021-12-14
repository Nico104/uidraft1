import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';

class SubModWriteAnnouncement extends StatefulWidget {
  const SubModWriteAnnouncement({Key? key, required this.subchannelName})
      : super(key: key);

  final String subchannelName;

  @override
  _SubModWriteAnnouncementState createState() =>
      _SubModWriteAnnouncementState();
}

class _SubModWriteAnnouncementState extends State<SubModWriteAnnouncement> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              //Message
              Form(
                key: _formKey,
                child: Padding(
                  //!Bottom Padding auch, deswegen Button overflow
                  padding: const EdgeInsets.fromLTRB(130, 130, 130, 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        cursorColor: Colors.white70,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        maxLength: 64,
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .searchBarTextColor),
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
                      const SizedBox(height: 60),
                      TextFormField(
                        // expands: true,
                        controller: _msgController,
                        cursorColor: Colors.white70,
                        autocorrect: false,
                        keyboardType: TextInputType.multiline,
                        maxLength: 512,
                        // minLines: 1,
                        maxLines: 18,
                        decoration: InputDecoration(
                          labelText: "Message",
                          labelStyle: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .searchBarTextColor),
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
                    ],
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
                      sendAnnouncementToMembers(
                              widget.subchannelName,
                              _titleController.text,
                              _msgController.text,
                              connection.returnConnection())
                          .then((value) => setState(() {
                                _titleController.clear();
                                _msgController.clear();
                              }));
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
