import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChooseUserUtil extends StatefulWidget {
  const ChooseUserUtil({Key? key, required this.notifyParent})
      : super(key: key);

  final Function(String val) notifyParent;

  @override
  _ChooseUserUtilState createState() => _ChooseUserUtilState();
}

class _ChooseUserUtilState extends State<ChooseUserUtil> {
  final String baseURL = 'http://localhost:3000/';

  bool _loading = true;

  List<List<String>> userNames = [];
  bool isLoading = false;

  final TextEditingController _searchText = TextEditingController();

  //Get SubchannleNames List
  Future<void> fetchUsers(String search) async {
    try {
      final response =
          await http.get(Uri.parse(baseURL + 'user/searchUser/$search'));

      if (response.statusCode == 200) {
        userNames.clear();
        List<dynamic> values = <dynamic>[];
        values = json.decode(response.body);
        if (values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              userNames.add([
                '${map['username']}',
                '${map['userProfile']['profilePicturePath']}'
              ]);
            }
          }
        }
        setState(() {
          _loading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  void initState() {
    _loading = false;

    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => fetchUsers(_searchText.text));
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
                      await fetchUsers(text);
                      setState(() {
                        print("username searched for $text");
                        print("usernameList: " + userNames.toString());
                      });
                    } // <-- The target method
                        );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: userNames.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => widget.notifyParent(
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
