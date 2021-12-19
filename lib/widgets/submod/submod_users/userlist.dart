import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';

class SubmodUserlist extends StatefulWidget {
  const SubmodUserlist(
      {Key? key,
      required this.handleUsername,
      required this.fromAbove,
      required this.subchannelName})
      : super(key: key);

  final Function(String) handleUsername;

  final bool fromAbove;

  final String subchannelName;

  @override
  _SubmodUserlistState createState() => _SubmodUserlistState();
}

class _SubmodUserlistState extends State<SubmodUserlist> {
  bool _loading = true;

  List<List<dynamic>> userNames = [];
  bool isLoading = false;

  final TextEditingController _searchText = TextEditingController();

  int _tabindex = 0;

  void addUserNameToList(
      String username, String profilePicturePath, bool isMod, bool isBanned) {
    userNames.add([username, profilePicturePath, isMod, isBanned]);
  }

  @override
  void initState() {
    _loading = false;

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userNames.clear();
      fetchMembersBy(_searchText.text, _tabindex, widget.subchannelName,
              addUserNameToList)
          .then((value) {
        if (value == 0) {
          setState(() {});
        } else {
          Beamer.of(context).beamToNamed('/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              //SearchField
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  maxLength: 21,
                  cursorColor: Colors.white,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: "Username",
                    labelStyle: const TextStyle(
                        fontFamily: "Segoe UI",
                        color: Colors.white,
                        fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                      fontFamily: "Segoe UI", color: Colors.white),
                  onChanged: (text) {
                    EasyDebounce.debounce(
                        'titleTextField-debouncer', // <-- An ID for this particular debouncer
                        const Duration(
                            milliseconds: 300), // <-- The debounce duration
                        () async {
                      userNames.clear();
                      await fetchMembersBy(text, _tabindex,
                              widget.subchannelName, addUserNameToList)
                          .then((value) {
                        if (value == 0) {
                          setState(() {});
                        } else {
                          Beamer.of(context).beamToNamed('/login');
                        }
                      });
                      // setState(() {
                      //   print("username searched for $text");
                      //   print("usernameList: " + userNames.toString());
                      // });
                    } // <-- The target method
                        );
                  },
                ),
              ),
              //Filtertabs
              SizedBox(
                height: 100,
                child: DefaultTabController(
                    length: 4,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
                          onTap: (val) async {
                            print(val);
                            setState(() {
                              _tabindex = val;
                            });
                            userNames.clear();
                            await fetchMembersBy(_searchText.text, _tabindex,
                                    widget.subchannelName, addUserNameToList)
                                .then((value) => setState(() {}));
                          },
                          tabs: const [
                            Tab(
                                icon: Icon(Icons.people),
                                child: Text("Members")),
                            Tab(
                                icon: Icon(Icons.videocam),
                                child: Text("Posters")),
                            Tab(icon: Icon(Icons.shield), child: Text("Mods")),
                            Tab(
                                icon: Icon(Icons.cancel),
                                child: Text("Banned")),
                          ],
                        ),
                      ],
                    )),
              ),
              //UserList
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: userNames.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => widget.handleUsername(
                            userNames.elementAt(index).elementAt(0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                  child: Image.network(
                                    // baseURL +
                                    spacesEndpoint +
                                        userNames.elementAt(index).elementAt(1),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  userNames.elementAt(index).first,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                userNames.elementAt(index).elementAt(2) == true
                                    ? const Icon(Icons.shield)
                                    : const SizedBox(),
                                userNames.elementAt(index).elementAt(3) == true
                                    ? const Icon(Icons.cancel)
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Column(
                        children: const [
                          SizedBox(
                            height: 2,
                          ),
                          Divider(),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SubmodUserlist oldWidget) {
    super.didUpdateWidget(oldWidget);

    // print("oldWidget.searchTerm is ${oldWidget.searchTerm}");
    // print("widget.searchTerm is ${widget.searchTerm}");

    // if (oldWidget.searchTerm != widget.searchTerm) {

    // }
    // this.updateChildWithParent();
    if (widget.fromAbove) {
      print("fromAbove is true");
      userNames.clear();
      fetchMembersBy(_searchText.text, _tabindex, widget.subchannelName,
              addUserNameToList)
          .then((value) {
        if (value == 0) {
          setState(() {});
        } else {
          Beamer.of(context).beamToNamed('/login');
        }
      });
    } else {
      print("fromAbove is false");
    }
  }

  // void updateChildWithParent() {
  //   print("updateChildWithParent/search screen");
  //   setState(() {
  //     // _mJsonLoaded = false; // For loader
  //     // if (listArray.length > 0) {
  //     //   listArray.clear();
  //     // }
  //   });

  //   // Do whatever you want here…
  //   // Like call api call again in child widget.
  // }
}
