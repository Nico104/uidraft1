import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/tag/tag_chip_widget.dart';

class ChooseSubchannelLargeScreen extends StatelessWidget {
  const ChooseSubchannelLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                border: Border.all(
                    color: Theme.of(context).colorScheme.navBarIconColor,
                    width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(59))),
            width: 400,
            alignment: Alignment.topCenter,
            child: const ChooseSubchannel()),
      ),
    );
  }
}

class ChooseSubchannel extends StatefulWidget {
  const ChooseSubchannel({Key? key}) : super(key: key);

  @override
  _ChooseSubchannelState createState() => _ChooseSubchannelState();
}

class _ChooseSubchannelState extends State<ChooseSubchannel> {
  bool _loading = true;

  List<String> subchannelNames = <String>[];
  bool isLoading = false;

  // String parentTag = "none";
  // String grandpaTag = "none";

  //Get PostIds List
  // Future<void> fetchTags(String parentTagName) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://localhost:3000/tag/getTagsByParent/$parentTagName'));

  //     if (response.statusCode == 200) {
  //       // If the call to the server was successful, parse the JSON
  //       List<dynamic> values = <dynamic>[];
  //       values = json.decode(response.body);
  //       if (values.isNotEmpty) {
  //         for (int i = 0; i < values.length; i++) {
  //           if (values[i] != null) {
  //             Map<String, dynamic> map = values[i];
  //             tagNames.add(map['tagName']);
  //             print('Tagname-------${map['tagName']}');
  //           }
  //         }
  //       }
  //       // print(postIds);
  //       setState(() {
  //         _loading = false;
  //       });
  //     } else {
  //       // If that call was not successful, throw an error.
  //       //Beamer.of(context).beamToNamed("/error/feed");
  //       throw Exception('Failed to load tags');
  //     }
  //   } catch (e) {
  //     print("Error: " + e.toString());
  //     //Beamer.of(context).beamToNamed("/error/feed");
  //   }
  // }

  // //Check if Tag has Subtags
  // Future<bool> _hasSubtags(String parentTagName) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://localhost:3000/tag/getTagsByParent/$parentTagName'));

  //     if (response.statusCode == 200) {
  //       // If the call to the server was successful, parse the JSON
  //       print("Response Body Json: " + json.decode(response.body).toString());
  //       List<dynamic> values = <dynamic>[];
  //       values = json.decode(response.body);
  //       if (values.isNotEmpty) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     } else {
  //       // If that call was not successful, throw an error.
  //       throw Exception('Failed to load tags');
  //     }
  //   } catch (e) {
  //     print("Loading Error: " + e.toString());
  //     throw Exception('Failed to load tags response');
  //   }
  // }

  // Future<String> getTagParent(String parentTagName) async {
  //   try {
  //     final response = await http.get(
  //         Uri.parse('http://localhost:3000/tag/getTagParent/$parentTagName'));

  //     if (response.statusCode == 200) {
  //       // If the call to the server was successful, parse the JSON
  //       // List<dynamic> values = <dynamic>[];
  //       // String value = json.decode(response.body)['parentTag'];
  //       if (json.decode(response.body)['parentTag'] != null) {
  //         print("Return: " +
  //             json.decode(response.body)['parentTag']['tagName'].toString());
  //         return json.decode(response.body)['parentTag']['tagName'].toString();
  //       } else {
  //         return "none";
  //       }
  //     } else {
  //       // If that call was not successful, throw an error.
  //       //Beamer.of(context).beamToNamed("/error/feed");
  //       throw Exception('Failed to load tags');
  //     }
  //   } catch (e) {
  //     print("Loading Error: " + e.toString());
  //     throw Exception('Failed to load tags');
  //     //Beamer.of(context).beamToNamed("/error/feed");
  //   }
  // }

  @override
  void initState() {
    subchannelNames.add('CoolSamuraiStuff');
    subchannelNames.add('Nature');
    subchannelNames.add('Ballplay');
    subchannelNames.add('Rocktes');
    subchannelNames.add('Animals');
    subchannelNames.add('goon');
    subchannelNames.add('Chicago');

    _loading = false;

    super.initState();
    // fetchTags("none");
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                  // controller: _postTitleTextController,
                  // enableSuggestions: false,
                  maxLength: 21,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: "Subchannel Name",
                    labelStyle: const TextStyle(
                        fontFamily: "Segoe UI", color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.pink),
                    ),
                  ),
                  // validator: (val) {
                  //   if (val!.isEmpty) {
                  //     return "Title cannot be empty";
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                      fontFamily: "Segoe UI", color: Colors.black),
                  onChanged: (text) {
                    EasyDebounce.debounce(
                        'titleTextField-debouncer', // <-- An ID for this particular debouncer
                        const Duration(
                            milliseconds: 300), // <-- The debounce duration
                        () => setState(() {
                              print("subchannel searched for $text");
                            }) // <-- The target method
                        );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: subchannelNames.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.pop(
                          context, subchannelNames.elementAt(index)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            child: Image.network(
                              "https://picsum.photos/100",
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
                            "c/" + subchannelNames.elementAt(index),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 3,
                        ),
                        Divider(),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    );
                  },
                ),
                // ListView(
                //   children: List.generate(subchannelNames.length, (index) {
                //     return InkWell(
                //       onTap: () => Navigator.pop(
                //           context, subchannelNames.elementAt(index)),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           ClipRRect(
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(20)),
                //             child: Image.network(
                //               "https://picsum.photos/100",
                //               fit: BoxFit.cover,
                //               alignment: Alignment.center,
                //               width: 32,
                //               height: 32,
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 15,
                //           ),
                //           const Text(
                //             "c/SubchannelName",
                //             style: TextStyle(
                //                 fontSize: 18, color: Colors.black),
                //           ),
                //         ],
                //       ),
                //     );
                //   }),
                // ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }
}

// child: Center(
//   child: GridView.builder(
//       shrinkWrap: true,
//       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//           maxCrossAxisExtent: 150,
//           childAspectRatio: 3 / 1,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20),
//       itemCount: tagNames.length,
//       itemBuilder: (BuildContext ctx, index) {
//         return GestureDetector(
//             onDoubleTap: () =>
//                 Navigator.pop(context, tagNames.elementAt(index)),
//             child: TagChip(tagname: tagNames.elementAt(index)));
//       }),
