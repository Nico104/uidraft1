import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/widgets/submod/submod_users/submod_member_details.dart';
import 'package:uidraft1/widgets/submod/submod_users/userlist.dart';

class SubModUsersTab extends StatefulWidget {
  const SubModUsersTab({Key? key}) : super(key: key);

  @override
  _SubModUsersTabState createState() => _SubModUsersTabState();
}

class _SubModUsersTabState extends State<SubModUsersTab> {
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
    return Row(
      children: [
        Flexible(fit: FlexFit.tight, flex: 1, child: Container()),
        Flexible(
          fit: FlexFit.tight,
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: InkWell(
              // onTap: () => setState(() {
              //   _showDetail = !_showDetail;
              // }),
              child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.amber,
                          Colors.deepOrange,
                        ],
                      )),
                  // height: 800,
                  // width: 500,
                  child: SubmodUserlist(handleUsername: setToDetail)),
            ),
          ),
        ),
        Flexible(fit: FlexFit.tight, flex: 1, child: Container()),
        AnimatedContainer(
          // alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink,
              Colors.blue,
            ],
          )),
          width: _showDetail ? 400 : 0,
          // height: 800,
          child: _activeUsername != null
              ? SubModMemberDetails(
                  username: _activeUsername!,
                )
              : const SizedBox(),
        ),
        // Flexible(fit: FlexFit.tight, flex: 1, child: Container()),
      ],
    );
  }
}
