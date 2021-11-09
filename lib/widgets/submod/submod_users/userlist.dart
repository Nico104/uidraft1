import 'package:flutter/material.dart';

// class SubmodUserlist extends StatelessWidget {
//   const SubmodUserlist({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             bottom: const TabBar(
//               tabs: [
//                 Tab(icon: Icon(Icons.directions_car)),
//                 Tab(icon: Icon(Icons.directions_transit)),
//                 Tab(icon: Icon(Icons.directions_bike)),
//               ],
//             ),
//             title: const Text('Tabs Demo'),
//           ),
//           body: const TabBarView(
//             children: [
//               Icon(Icons.directions_car),
//               Icon(Icons.directions_transit),
//               Icon(Icons.directions_bike),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/submod/submod_util_methods.dart';

class SubmodUserlist extends StatefulWidget {
  const SubmodUserlist({Key? key, required this.handleUsername})
      : super(key: key);

  final Function(String) handleUsername;

  @override
  _SubmodUserlistState createState() => _SubmodUserlistState();
}

class _SubmodUserlistState extends State<SubmodUserlist> {
  final String baseURL = 'http://localhost:3000/';

  bool _loading = true;

  List<List<String>> userNames = [];
  bool isLoading = false;

  final TextEditingController _searchText = TextEditingController();

  int _tabindex = 0;

  // //Get SubchannleNames List
  // Future<void> fetchUsers(String search, int method
  //     // , String subchannel
  //     ) async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse(baseURL + 'user/searchUser/$search'));

  //     if (response.statusCode == 200) {
  //       userNames.clear();
  //       List<dynamic> values = <dynamic>[];
  //       values = json.decode(response.body);
  //       if (values.isNotEmpty) {
  //         for (int i = 0; i < values.length; i++) {
  //           if (values[i] != null) {
  //             Map<String, dynamic> map = values[i];
  //             userNames.add([
  //               '${map['username']}',
  //               '${map['userProfile']['profilePicturePath']}'
  //             ]);
  //           }
  //         }
  //       }
  //       setState(() {
  //         _loading = false;
  //       });
  //     } else {
  //       throw Exception('Failed to load users');
  //     }
  //   } catch (e) {
  //     print("Error: " + e.toString());
  //   }
  // }

  void addUserNameToList(String username, String profilePicturePath) {
    userNames.add([username, profilePicturePath]);
  }

  @override
  void initState() {
    _loading = false;

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userNames.clear();
      fetchMembersBy(_searchText.text, 0, 'isgut', addUserNameToList)
          .then((value) => setState(() {}));
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
                      await fetchMembersBy(text, 0, 'isgut', addUserNameToList)
                          .then((value) => setState(() {}));
                      setState(() {
                        print("username searched for $text");
                        print("usernameList: " + userNames.toString());
                      });
                    } // <-- The target method
                        );
                  },
                ),
              ),
              //Filtertabs
              SizedBox(
                height: 100,
                child: DefaultTabController(
                    length: 3,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
                          onTap: (val) {
                            print(val);
                            _tabindex = val;
                          },
                          tabs: const [
                            Tab(
                                icon: Icon(Icons.people),
                                child: Text("Members")),
                            Tab(
                                icon: Icon(Icons.videocam),
                                child: Text("Posters")),
                            Tab(icon: Icon(Icons.shield), child: Text("Mods")),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)),
                              child: Image.network(
                                baseURL +
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
}
