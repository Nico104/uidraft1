import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
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
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 100,
      itemBuilder: (context, index) {
        return InkWell(
          // onTap: () =>
          //     widget.handleUsername(userNames.elementAt(index).elementAt(0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      child: Image.network(
                        // baseURL + userNames.elementAt(index).elementAt(1),
                        "https://picsum.photos/1280/720",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        // width: 40,
                        // height: 40,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        // userNames.elementAt(index).first,
                        "Title jojojsjas",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // userNames.elementAt(index).first,
                        "Title jojojsjas",
                        style: TextStyle(fontSize: 13, color: Colors.white38),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        // userNames.elementAt(index).first,
                        "Reports: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // userNames.elementAt(index).first,
                        "Rating: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // userNames.elementAt(index).first,
                        "Views: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // userNames.elementAt(index).first,
                        "UploadDateTime: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      // SizedBox(height: 8),
                    ],
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Delete
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.delete,
                                  size: 22,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                          ),
                          const SizedBox(width: 0),
                          Tooltip(
                              // padding: EdgeInsets.all(20),
                              margin: const EdgeInsets.all(4),
                              // showDuration: Duration(seconds: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              preferBelow: true,
                              verticalOffset: 20,
                              message: "This is a Tooltip",
                              child: Icon(Icons.info,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .brandColor)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.delete,
                                  size: 22,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                          ),
                          const SizedBox(width: 0),
                          Tooltip(
                              // padding: EdgeInsets.all(20),
                              margin: const EdgeInsets.all(4),
                              // showDuration: Duration(seconds: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              preferBelow: true,
                              verticalOffset: 20,
                              message: "This is a Tooltip",
                              child: Icon(Icons.info,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .brandColor)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.delete,
                                  size: 22,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                          ),
                          const SizedBox(width: 0),
                          Tooltip(
                              // padding: EdgeInsets.all(20),
                              margin: const EdgeInsets.all(4),
                              // showDuration: Duration(seconds: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              preferBelow: true,
                              verticalOffset: 20,
                              message: "This is a Tooltip",
                              child: Icon(Icons.info,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .brandColor)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.delete,
                                  size: 22,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                          ),
                          const SizedBox(width: 0),
                          Tooltip(
                              // padding: EdgeInsets.all(20),
                              margin: const EdgeInsets.all(4),
                              // showDuration: Duration(seconds: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              preferBelow: true,
                              verticalOffset: 20,
                              message: "This is a Tooltip",
                              child: Icon(Icons.info,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .brandColor)),
                        ],
                      ),
                      // SizedBox(height: 8),
                      // Text(
                      //   // userNames.elementAt(index).first,
                      //   "Rating: ",
                      //   style: TextStyle(fontSize: 16, color: Colors.white),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   // userNames.elementAt(index).first,
                      //   "Views: ",
                      //   style: TextStyle(fontSize: 16, color: Colors.white),
                      // ),
                      // const SizedBox(height: 8),
                      // const Text(
                      //   // userNames.elementAt(index).first,
                      //   "UploadDateTime: ",
                      //   style: TextStyle(fontSize: 16, color: Colors.white),
                      // ),
                      // SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
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
    );
  }
}
