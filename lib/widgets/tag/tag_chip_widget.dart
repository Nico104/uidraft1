import 'dart:convert';

import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class TagChip extends StatelessWidget {
  final String tagname;
  final Future<bool> hasSubtags;

  const TagChip({Key? key, required this.tagname, required this.hasSubtags})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: hasSubtags,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              //Loading Tag
              // return Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //       color: Theme.of(context).colorScheme.brandColor,
              //       // border: Border.all(
              //       //     color: Theme.of(context).colorScheme.brandColor, width: 2),
              //       borderRadius: const BorderRadius.all(Radius.circular(20))),
              //   child: Center(
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              //       child: Text(
              //         "Loading...",
              //         style: TextStyle(
              //             color: Theme.of(context).canvasColor,
              //             fontSize: 23,
              //             fontFamily: 'Segoe UI'),
              //       ),
              //     ),
              //   ),
              // );
              return Chip(
                label: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 18,
                        fontFamily: 'Segoe UI'),
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.brandColor,
              );
            default:
              if (snapshot.hasError) {
                //Error while Loading Tag
                // return Container(
                //   height: 50,
                //   decoration: const BoxDecoration(
                //       color: Colors.red,
                //       // border: Border.all(color: Colors.red, width: 2),
                //       borderRadius: BorderRadius.all(Radius.circular(20))),
                //   child: Center(
                //     child: Padding(
                //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                //       child: Text(
                //         "Error...",
                //         style: TextStyle(
                //             color: Theme.of(context).canvasColor,
                //             fontSize: 23,
                //             fontFamily: 'Segoe UI'),
                //       ),
                //     ),
                //   ),
                // );
                return Chip(
                  label: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      "Error...",
                      style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 18,
                          fontFamily: 'Segoe UI'),
                    ),
                  ),
                  backgroundColor: Colors.red,
                );
              } else {
                if (snapshot.data == true) {
                  //Tag with Subtags
                  // return Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.brandColor,
                  //       border: Border.all(
                  //           color: Theme.of(context).colorScheme.highlightColor,
                  //           width: 4),
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(20))),
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  //       child: Text(
                  //         tagname,
                  //         style: TextStyle(
                  //             color: Theme.of(context).canvasColor,
                  //             fontSize: 23,
                  //             fontFamily: 'Segoe UI'),
                  //       ),
                  //     ),
                  //   ),
                  // );
                  return Chip(
                    label: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        tagname,
                        style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 18,
                            fontFamily: 'Segoe UI'),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.brandColor,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.highlightColor,
                        width: 4),
                  );
                } else {
                  //Tag without Subtags
                  // return Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.brandColor,
                  //       // border: Border.all(
                  //       //     color: Theme.of(context).colorScheme.brandColor, width: 2),
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(20))),
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  //       child: Text(
                  //         tagname,
                  //         style: TextStyle(
                  //             color: Theme.of(context).canvasColor,
                  //             fontSize: 23,
                  //             fontFamily: 'Segoe UI'),
                  //       ),
                  //     ),
                  //   ),
                  // );
                  return Chip(
                    label: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        tagname,
                        style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 18,
                            fontFamily: 'Segoe UI'),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.brandColor,
                  );
                }
              }
          }
        });
  }

  // Future<bool> _hasSubtags(String parentTagName) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://localhost:3000/tag/getTagsByParent/$parentTagName'));

  //     if (response.statusCode == 200) {
  //       // If the call to the server was successful, parse the JSON
  //       print("Response Body Json: " + json.decode(response.body));
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
  //     print("Error: " + e.toString());
  //     throw Exception('Failed to load tags response');
  //   }
  // }
}
