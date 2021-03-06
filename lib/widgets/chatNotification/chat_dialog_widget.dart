import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/notifications/notification_util_methods.dart';

class ChatNotification extends StatefulWidget {
  const ChatNotification(
      {Key? key,
      required this.username,
      required this.picturePath,
      required this.myUsername,
      required this.onBackPressed,
      required this.isLeftHand})
      : super(key: key);

  final String username;
  final String picturePath;

  final String myUsername;
  final bool isLeftHand;

  final Function() onBackPressed;

  @override
  State<ChatNotification> createState() => _ChatNotificationState();
}

class _ChatNotificationState extends State<ChatNotification> {
  final TextEditingController _newMsgTextController = TextEditingController();

  @override
  void dispose() {
    _newMsgTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text("yo"));
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return Column(
        children: [
          Row(
            textDirection:
                widget.isLeftHand ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image.network(
                      // baseURL
                      spacesEndpoint + widget.picturePath,
                      fit: BoxFit.contain,
                      width: 34,
                      height: 34,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(widget.username),
                  const SizedBox(width: 8),
                ],
              ),
              IconButton(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => widget.onBackPressed.call(),
                  icon: Icon(widget.isLeftHand
                      ? Icons.arrow_back
                      : Icons.arrow_forward))
            ],
          ),
          //Chat
          FutureBuilder(
              future: fetchConversationWithUser(
                  widget.username, connection.returnConnection()),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: 400, minHeight: 56.0),
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                textDirection: snapshot.data!
                                            .elementAt(index)['formUsername'] ==
                                        widget.myUsername
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(snapshot.data!.elementAt(
                                            index)['notificationText']),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text(
                            "seem like you two did not contact each other yet"));
                  }
                } else {
                  return const SizedBox(
                      height: 400, child: CircularProgressIndicator());
                }
              }),
          //New Message
          //Button muas outsourced werden
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
            child: KeyboardListener(
              // focusNode: fnReply,
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey.keyLabel == 'Enter' &&
                      _newMsgTextController.text.trim().isNotEmpty) {
                    print("enter pressed");
                    // _sendReply(snapshot.data!['commentPostId'],
                    //     snapshot.data!['commentId']);
                    submitMsg(widget.username, _newMsgTextController.text,
                            connection.returnConnection())
                        .then((value) {
                      if (value) {
                        _newMsgTextController.clear();
                        setState(() {});
                      } else {
                        _newMsgTextController.clear();
                      }
                    });
                  }
                }
              },
              child: TextFormField(
                controller: _newMsgTextController,
                cursorColor: Colors.white,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLength: 256,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white70,
                      ),
                      onPressed: () => submitMsg(
                                  widget.username,
                                  _newMsgTextController.text,
                                  connection.returnConnection())
                              .then((value) {
                            if (value) {
                              setState(() {});
                            } else {
                              _newMsgTextController.clear();
                            }
                          })),
                  labelText: "Write a message",
                  labelStyle: const TextStyle(
                      fontFamily: "Segoe UI",
                      color: Colors.white38,
                      fontSize: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                ),
                style: const TextStyle(
                    fontFamily: "Segoe UI",
                    color: Colors.white70,
                    fontSize: 14),
                // onFieldSubmitted: (_) => _sendReply(
                //     snapshot.data!['commentPostId'],
                //     snapshot.data!['commentId']),
              ),
            ),
          ),
        ],
      );
    });
  }
}
