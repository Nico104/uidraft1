import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/widgets/tag/tag_chip_widget.dart';

class TagGridLargeScreen extends StatelessWidget {
  const TagGridLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border.all(
                    color: Theme.of(context).colorScheme.navBarIconColor,
                    width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(59))),
            // width: 400,
            alignment: Alignment.center,
            child: const TagGrid()),
      ),
    );
  }
}

class TagGrid extends StatefulWidget {
  const TagGrid({Key? key}) : super(key: key);

  @override
  _TagGridState createState() => _TagGridState();
}

class _TagGridState extends State<TagGrid> {
  bool _loading = true;

  List<String> tagNames = <String>[];
  bool isLoading = false;

  String parentTag = "none";
  // String grandpaTag = "none";

  //Get PostIds List
  Future<void> fetchTags(String parentTagName) async {
    try {
      final response = await http
          .get(Uri.parse(baseURL + 'tag/getTagsByParent/$parentTagName'));

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        List<dynamic> values = <dynamic>[];
        values = json.decode(response.body);
        if (values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              tagNames.add(map['tagName']);
              print('Tagname-------${map['tagName']}');
            }
          }
        }
        // print(postIds);
        setState(() {
          _loading = false;
        });
      } else {
        // If that call was not successful, throw an error.
        //Beamer.of(context).beamToNamed("/error/feed");
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print("Error: " + e.toString());
      //Beamer.of(context).beamToNamed("/error/feed");
    }
  }

  //Check if Tag has Subtags
  Future<bool> _hasSubtags(String parentTagName) async {
    try {
      final response = await http
          .get(Uri.parse(baseURL + 'tag/getTagsByParent/$parentTagName'));

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        print("Response Body Json: " + json.decode(response.body).toString());
        List<dynamic> values = <dynamic>[];
        values = json.decode(response.body);
        if (values.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print("Loading Error: " + e.toString());
      throw Exception('Failed to load tags response');
    }
  }

  Future<String> getTagParent(String parentTagName) async {
    try {
      final response = await http
          .get(Uri.parse(baseURL + 'tag/getTagParent/$parentTagName'));

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        // List<dynamic> values = <dynamic>[];
        // String value = json.decode(response.body)['parentTag'];
        if (json.decode(response.body)['parentTag'] != null) {
          print("Return: " +
              json.decode(response.body)['parentTag']['tagName'].toString());
          return json.decode(response.body)['parentTag']['tagName'].toString();
        } else {
          return "none";
        }
      } else {
        // If that call was not successful, throw an error.
        //Beamer.of(context).beamToNamed("/error/feed");
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print("Loading Error: " + e.toString());
      throw Exception('Failed to load tags');
      //Beamer.of(context).beamToNamed("/error/feed");
    }
  }

  @override
  void initState() {
    super.initState();

    fetchTags("none");
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Back to Parent
                  Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      parentTag != "none"
                          ? OutlinedButton(
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
                              onPressed: () {
                                setState(() async {
                                  // parentTag =
                                  //     tagNames.elementAt(index).toString();
                                  parentTag = await getTagParent(parentTag);
                                  tagNames.clear();
                                  fetchTags(parentTag);
                                });
                              },
                              child: Text(
                                'Back to ' + parentTag,
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                            )
                          : const SizedBox(
                              width: 0,
                            ),
                    ],
                  ),
                  //Close Dialog
                  Row(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.brandColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Close X',
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.brandColor),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
                    child: Wrap(
                      runSpacing: 20,
                      spacing: 20,
                      // alignment: WrapAlignment.center,
                      // direction: Axis.vertical,
                      children: List.generate(tagNames.length, (index) {
                        return InkWell(
                            onTap: () => Navigator.pop(
                                context, tagNames.elementAt(index)),
                            onDoubleTap: () async {
                              if (await _hasSubtags(
                                  tagNames.elementAt(index))) {
                                setState(() {
                                  // grandpaTag = parentTag;
                                  parentTag =
                                      tagNames.elementAt(index).toString();
                                  tagNames.clear();
                                  fetchTags(parentTag);
                                });
                              } else {
                                print(
                                    "no kids for " + tagNames.elementAt(index));
                              }
                            },
                            child: TagChip(
                              tagname: tagNames.elementAt(index),
                              hasSubtags:
                                  _hasSubtags(tagNames.elementAt(index)),
                            ));
                      }),
                    ),
                  ),
                ),
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
