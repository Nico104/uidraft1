// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/widgets/submod/submod_posts/submod_post_list_item_widget.dart';
import 'package:uidraft1/widgets/submod/submod_users/submod_member_details.dart';
import 'package:uidraft1/widgets/submod/submod_users/userlist.dart';

class SubModPostTab extends StatefulWidget {
  const SubModPostTab({Key? key}) : super(key: key);

  @override
  _SubModPostTabState createState() => _SubModPostTabState();
}

class _SubModPostTabState extends State<SubModPostTab> {
  bool _showDetail = false;
  String? _activeUsername;

  void setToDetail(String username) {
    setState(() {
      _showDetail = true;
      _activeUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemCount: 100,
          itemBuilder: (context, index) {
            return SubModPostListItem();
          },
          separatorBuilder: (BuildContext context, int index) {
            return Column(
              children: const [
                // SizedBox(
                //   height: 8,
                // ),
                Divider(
                  color: Colors.white60,
                ),
                // SizedBox(
                //   height: 8,
                // ),
              ],
            );
          },
        ),
        Positioned(
            right: 20,
            top: 20,
            child: Container(
              // color: Colors.purple.withOpacity(0.9),
              width: 180,
              height: 40,
              child: KeyboardListener(
                focusNode: FocusNode(),
                // focusNode: fnUsername,
                // onKeyEvent: (event) {
                //   if (event is KeyDownEvent) {
                //     if (event.logicalKey.keyLabel == 'Tab') {
                //       print("Tab pressed");
                //       fnPassword.requestFocus();
                //     }
                //   }
                // },
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    // autofocus: true,
                    // controller: _usernameTextController,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Segoe UI',
                        letterSpacing: 0.3),
                    cursorColor:
                        Theme.of(context).colorScheme.textInputCursorColor,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.brandColor,
                            width: 1),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.brandColor,
                            width: 2),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).canvasColor,
                      labelText: 'Search',
                      labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color:
                              Theme.of(context).colorScheme.searchBarTextColor),
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 15, top: 15, left: 15, right: 10),
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
                          fontSize: 14.0, fontFamily: 'Segoe UI'),
                      // errorText: errorText,
                    ),
                    validator: (value) {
                      //check if username exists
                      if (value == null || value.isEmpty) {
                        return 'You may enter your username, sir';
                      }
                      return null;
                    },
                    // onFieldSubmitted: (_) => submit(),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
