import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/comment/comment_util_methods.dart';

///Return the Comment Reply TextFormField
///takes [commentpostID] for the current Post
///takes [commentID] for the current Comment
///takes [client] as a HTTP Client
///takes [afterReplySend] as a function to call after the reply was sent
///takes [commentTextController] as the replys textEditingController
///takes [fnReply] as the reply TextFormField FocusNode
class CommentReplyTextFormField extends StatelessWidget {
  const CommentReplyTextFormField({
    Key? key,
    required TextEditingController commentTextController,
    required this.fnReply,
    required this.commentpostId,
    required this.commentId,
    required this.client,
    required this.afterReplySend,
  })  : _commentTextController = commentTextController,
        super(key: key);

  final TextEditingController _commentTextController;
  final FocusNode fnReply;

  final int commentpostId;
  final int commentId;
  final http.Client client;

  final Function() afterReplySend;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      // focusNode: fnReply,
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey.keyLabel == 'Enter') {
            print("enter pressed");
            sendReplyComment(commentpostId, commentId,
                    _commentTextController.text.trim(), client)
                .then((value) {
              afterReplySend.call();
            });
          }
        }
      },
      child: TextFormField(
        focusNode: fnReply,
        controller: _commentTextController,
        cursorColor: Colors.white,
        autocorrect: false,
        keyboardType: TextInputType.multiline,
        maxLength: 256,
        minLines: 1,
        maxLines: 20,
        decoration: InputDecoration(
          // suffixIcon: IconButton(
          //     icon: const Icon(
          //       Icons.send,
          //       color: Colors.white70,
          //     ),
          //     onPressed: () => sendReplyComment(commentpostId, commentId,
          //                 _commentTextController.text.trim(), client)
          //             .then((value) {
          //           afterReplySend.call();
          //         })),
          suffix: InkWell(
            onTap: () {
              _commentTextController.text += '\n';
              _commentTextController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _commentTextController.text.length));
            },
            child: const Icon(Icons.segment),
          ),
          labelText: "Reply to comment",
          labelStyle: const TextStyle(
              fontFamily: "Segoe UI", color: Colors.white38, fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.pink),
          ),
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return "Field cannot be empty";
          } else {
            return null;
          }
        },
        style: const TextStyle(
            fontFamily: "Segoe UI", color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
