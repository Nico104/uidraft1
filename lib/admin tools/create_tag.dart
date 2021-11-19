import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateTagLargeScreen extends StatelessWidget {
  const CreateTagLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(72, 34, 0, 0),
              child: Text(
                "LOGO",
                style: TextStyle(
                    fontFamily: 'Segoe UI Black',
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
          ),
          const Center(
            child: SizedBox(height: 670, width: 400, child: CreateTagForm()),
          )
        ],
      ),
    );
  }
}

class CreateTagForm extends StatefulWidget {
  const CreateTagForm({Key? key}) : super(key: key);

  @override
  _CreateTagFormState createState() => _CreateTagFormState();
}

//CreateTagForm
class _CreateTagFormState extends State<CreateTagForm> {
  final _formKey = GlobalKey<FormState>();

  final _tagNameTextController = TextEditingController();
  final _tagParentNameTextController = TextEditingController();

  @override
  void dispose() {
    _tagNameTextController.dispose();
    _tagParentNameTextController.dispose();
    super.dispose();
  }

  Future<void> _createTag(String tagname) async {
    var url = Uri.parse('http://localhost:3000/tag/createTag');
    var response = await http.post(url, body: {'tagname': '$tagname'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print("CREATING TAG WITH TAGNAME: $tagname WAS SUCCESSFULL");
    } else {
      print("CREATING TAG WITH TAGNAME: $tagname WAS !!!NOT!!! SUCCESSFULL");
    }
  }

  Future<void> _createTagWithParent(
      String tagname, String parenttagname) async {
    var url = Uri.parse('http://localhost:3000/tag/createTagWithParentTag');
    var response = await http.post(url,
        body: {'tagname': '$tagname', 'parenttagname': '$parenttagname'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print(
          "CREATING TAG WITH TAGNAME: $tagname and Parent $parenttagname WAS SUCCESSFULL");
    } else {
      print(
          "CREATING TAG WITH TAGNAME: $tagname and Parent $parenttagname WAS !!!NOT!!! SUCCESSFULL");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.brandColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Thank you for signing up text
            SizedBox(
              width: 270,
              child: Text(
                "Enter Tag and Parent Tag",
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.textInputCursorColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            //Username
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: _tagNameTextController,
                style: const TextStyle(
                    fontSize: 15, fontFamily: 'Segoe UI', letterSpacing: 0.3),
                cursorColor: Theme.of(context).colorScheme.textInputCursorColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.brandColor,
                        width: 0.5),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.brandColor,
                        width: 2),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).canvasColor,
                  hintText: 'Tagname...',
                  hintStyle: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.searchBarTextColor),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                      bottom: 15, top: 15, left: 15, right: 10),
                  //Error
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  errorStyle:
                      const TextStyle(fontSize: 14.0, fontFamily: 'Segoe UI'),
                ),
                validator: (value) {
                  //Check if username is free
                  if (value == null || value.isEmpty) {
                    return 'You may enter a tagname, master';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            //Useremail
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: _tagParentNameTextController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    fontSize: 15, fontFamily: 'Segoe UI', letterSpacing: 0.3),
                cursorColor: Theme.of(context).colorScheme.textInputCursorColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.brandColor,
                        width: 0.5),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.brandColor,
                        width: 2),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).canvasColor,
                  hintText: 'ParentTag...',
                  hintStyle: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.searchBarTextColor),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                      bottom: 15, top: 15, left: 15, right: 10),
                  //Error
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  errorStyle:
                      const TextStyle(fontSize: 14.0, fontFamily: 'Segoe UI'),
                ),
              ),
            ),

            const SizedBox(
              height: 60,
            ),
            //Submit Button
            SizedBox(
              width: 200,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.brandColor),
                child: Text(
                  'Create Tag',
                  style: TextStyle(
                      fontFamily: 'Segoe UI Black',
                      fontSize: 18,
                      color: Theme.of(context).canvasColor),
                ),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    if (_tagNameTextController.text.isNotEmpty &&
                        _tagParentNameTextController.text.isNotEmpty) {
                      _createTagWithParent(
                          _tagNameTextController.text.toLowerCase(),
                          _tagParentNameTextController.text.toLowerCase());
                    } else if (_tagNameTextController.text.isNotEmpty &&
                        _tagParentNameTextController.text.isEmpty) {
                      _createTag(_tagNameTextController.text.toLowerCase());
                    } else {
                      print("No if is true");
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
