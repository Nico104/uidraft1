import 'package:flutter/material.dart';
import 'package:uidraft1/widgets/submod/submod_users/submod_member_details.dart';
import 'package:uidraft1/widgets/submod/submod_users/userlist.dart';

class SubModUsersTab extends StatefulWidget {
  const SubModUsersTab({Key? key, required this.subchannelName})
      : super(key: key);

  final String subchannelName;

  @override
  _SubModUsersTabState createState() => _SubModUsersTabState();
}

class _SubModUsersTabState extends State<SubModUsersTab> {
  bool _showDetail = false;
  String? _activeUsername;

  bool _fromAbove = false;

  void setToDetail(String username) {
    setState(() {
      _showDetail = true;
      _activeUsername = username;
      _fromAbove = false;
    });
  }

  void refresh() {
    setState(() {
      _fromAbove = true;
    });
    print("refreshed parentz");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              if (_showDetail) {
                setState(() {
                  _showDetail = false;
                });
              }
            },
            child: Row(
              children: [
                Flexible(fit: FlexFit.tight, flex: 1, child: Container()),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
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
                        child: SubmodUserlist(
                          handleUsername: setToDetail,
                          fromAbove: _fromAbove,
                          subchannelName: widget.subchannelName,
                        )),
                  ),
                ),
                Flexible(fit: FlexFit.tight, flex: 1, child: Container()),
              ],
            ),
          ),
        ),
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
                  notifyParents: () => refresh.call(),
                  subchannelName: widget.subchannelName,
                )
              : const SizedBox(),
        ),
        // Flexible(fit: FlexFit.tight, flex: 1, child: Container()),
      ],
    );
  }
}
