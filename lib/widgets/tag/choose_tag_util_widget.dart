import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/widgets/tag/tag_chip_widget.dart';

class ChooseTagUtil extends StatefulWidget {
  const ChooseTagUtil(
      {Key? key, required this.notifyParent, required this.back})
      : super(key: key);

  final Function(String val) notifyParent;
  final Function() back;

  @override
  _ChooseTagUtilState createState() => _ChooseTagUtilState();
}

class _ChooseTagUtilState extends State<ChooseTagUtil> {
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
        setState(() {
          _loading = false;
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  //Check if Tag has Subtags
  Future<bool> _hasSubtags(String parentTagName) async {
    try {
      final response = await http
          .get(Uri.parse(baseURL + 'tag/getTagsByParent/$parentTagName'));

      if (response.statusCode == 200) {
        print("Response Body Json: " + json.decode(response.body).toString());
        List<dynamic> values = <dynamic>[];
        values = json.decode(response.body);
        if (values.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
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
        if (json.decode(response.body)['parentTag'] != null) {
          print("Return: " +
              json.decode(response.body)['parentTag']['tagName'].toString());
          return json.decode(response.body)['parentTag']['tagName'].toString();
        } else {
          return "none";
        }
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print("Loading Error: " + e.toString());
      throw Exception('Failed to load tags');
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
                        onPressed: () => widget.back.call(),
                        child: Text(
                          'Cancel',
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: SingleChildScrollView(
                      child: Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        children: List.generate(tagNames.length, (index) {
                          return InkWell(
                              onTap: () => widget
                                  .notifyParent(tagNames.elementAt(index)),
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
                                  print("no kids for " +
                                      tagNames.elementAt(index));
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
