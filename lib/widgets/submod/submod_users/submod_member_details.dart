import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/widgets/submod/submod_users/submod_member_commentmodel_widget.dart';
import 'package:uidraft1/widgets/submod/submod_users/submod_member_details_options_widget.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

class SubModMemberDetails extends StatefulWidget {
  const SubModMemberDetails(
      {Key? key,
      required this.username,
      required this.notifyParents,
      required this.subchannelName})
      : super(key: key);

  final String username;
  final void Function() notifyParents;
  final String subchannelName;

  @override
  _SubModMemberDetailsState createState() => _SubModMemberDetailsState();
}

class _SubModMemberDetailsState extends State<SubModMemberDetails> {
  int _showActivity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future: getSubModUserData(widget.username, widget.subchannelName,
              connection.returnConnection()),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              // print("SubModUserData: " + snapshot.data.toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),
                  //Data
                  Column(
                    children: [
                      //Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Image.network(
                          // baseURL +
                          spacesEndpoint +
                              snapshot.data!['userProfile']
                                  ['profilePicturePath'],
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          width: 187,
                          height: 187,
                        ),
                      ),
                      const SizedBox(height: 25),
                      InkWell(
                        onTap: () => setState(() {
                          _showActivity = 1;
                        }),
                        child: Column(
                          children: [
                            Text((snapshot.data!['userPosts'] as List)
                                    .length
                                    .toString() +
                                " posts"),
                            const SizedBox(height: 15),
                            Text((snapshot.data!['userComments'] as List)
                                    .length
                                    .toString() +
                                " comments"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                  Expanded(
                    flex: 10,
                    child: (_showActivity == 0)
                        ? SubModMemberOptions(
                            banUser: () => banUser(
                                    widget.username,
                                    widget.subchannelName,
                                    connection.returnConnection())
                                .then((value) => widget.notifyParents.call()),
                            unbanUser: () => unbanUser(
                                    widget.username,
                                    widget.subchannelName,
                                    connection.returnConnection())
                                .then((value) => widget.notifyParents.call()),
                            makeUserSubchannelMod: () => makeUserSubchannelMod(
                                    widget.username,
                                    widget.subchannelName,
                                    connection.returnConnection())
                                .then((value) => widget.notifyParents.call()),
                            removeUserSubchannelMod: () =>
                                removeUserSubchannelMod(
                                        widget.username,
                                        widget.subchannelName,
                                        connection.returnConnection())
                                    .then(
                                        (value) => widget.notifyParents.call()),
                            subchannelName: widget.subchannelName,
                            username: widget.username,
                            userRole: getUserOption(snapshot.data!),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                            child: InkWell(
                              onTap: () => setState(() {
                                _showActivity = 0;
                              }),
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshot.data!['userComments'].length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SubModMemberCommentModel(
                                              commentId: snapshot
                                                  .data!['userComments']
                                                  .elementAt(
                                                      index)['commentId']),
                                          const SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          });
    });
  }
}

int getUserOption(Map<String, dynamic> data) {
  if ((data['subchannelsModerater'] as List).isNotEmpty) {
    return 2;
  } else if ((data['bannedFromSubchannel'] as List).isNotEmpty) {
    return 1;
  } else {
    return 0;
  }
}
