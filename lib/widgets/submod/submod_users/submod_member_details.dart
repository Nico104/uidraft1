import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/widgets/comment/comment_model_widget.dart';

class SubModMemberDetails extends StatefulWidget {
  const SubModMemberDetails({Key? key, required this.username})
      : super(key: key);

  final String username;

  @override
  _SubModMemberDetailsState createState() => _SubModMemberDetailsState();
}

class _SubModMemberDetailsState extends State<SubModMemberDetails> {
  int _showActivity = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSubModUserData(widget.username, 'isgut'),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
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
                        baseURL +
                            snapshot.data!['userProfile']['profilePicturePath'],
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
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Ban',
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                            ),
                            const SizedBox(height: 15),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Make Mod',
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                            )
                          ],
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
                                        CommentModel(
                                            commentId: snapshot
                                                .data!['userComments']
                                                .elementAt(index)['commentId']),
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
  }
}
