import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uidraft1/screens/auth/auth_screen.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:http/http.dart' as http;

class SignUpV2LargeScreen extends StatelessWidget {
  const SignUpV2LargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(height: 470, width: 400, child: SignUpV2Form()),
    );
  }
}

class SignUpV2Form extends StatefulWidget {
  const SignUpV2Form({Key? key}) : super(key: key);

  @override
  _SignUpV2FormState createState() => _SignUpV2FormState();
}

//SignUPForm
class _SignUpV2FormState extends State<SignUpV2Form> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _useremailTextController = TextEditingController();

  String titleText =
      "It is a long established fact that a reader will be distracted by the readable content of a page when Looking";

  //FocusNodes
  FocusNode fnUsername = FocusNode();
  FocusNode fnPassword = FocusNode();

  @override
  void dispose() {
    _usernameTextController.dispose();
    _useremailTextController.dispose();
    fnUsername.dispose();
    fnPassword.dispose();
    super.dispose();
  }

//LoginMethod
  Future<bool> _login(String username, String password) async {
    var url = Uri.parse('http://localhost:3000/login');
    var response = await http
        .post(url, body: {'username': '$username', 'password': '$password'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'access_token', json.decode(response.body)["access_token"]);
      print("Acess Token: ${prefs.getString('access_token')}");

      // Navigator.of(context).pushNamed('/');
      // Beamer.of(context).beamToNamed('/');
      return true;
    }

    return false;
    //Navigator.of(context).pushNamed('/welcome');
  }

  Future<void> _signUp(String username, String useremail) async {
    var url = Uri.parse('http://localhost:3000/user/signupv2');
    var response = await http.post(url, body: {
      "username": username,
      "useremail": useremail,
      "userLanguage": "en"
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print("yes");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(
            isLoginInitial: true,
            // firstTimeLogin: true,
          ),
        ),
      );
    } else {
      print("nope");
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
                  titleText,
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
                child: KeyboardListener(
                  focusNode: fnUsername,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey.keyLabel == 'Tab') {
                        print("Tab pressed");
                        fnPassword.requestFocus();
                      }
                    }
                  },
                  child: TextFormField(
                    controller: _usernameTextController,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Segoe UI',
                        letterSpacing: 0.3),
                    cursorColor:
                        Theme.of(context).colorScheme.textInputCursorColor,
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
                      // hintText: 'Username...',
                      // hintStyle: TextStyle(
                      //     fontFamily: 'Segoe UI',
                      //     fontSize: 15,
                      //     color:
                      //         Theme.of(context).colorScheme.searchBarTextColor),
                      labelText: 'Username...',
                      labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color:
                              Theme.of(context).colorScheme.searchBarTextColor),
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 15, top: 15, left: 15, right: 10),
                      //Error
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 14.0, fontFamily: 'Segoe UI'),
                    ),
                    validator: (value) {
                      //Check if username is free
                      if (value == null || value.isEmpty) {
                        return 'You may choose a username, sir';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => submit(),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              //Useremail
              SizedBox(
                width: 350,
                child: KeyboardListener(
                  focusNode: fnPassword,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey.keyLabel == 'Tab') {
                        print("Tab pressed");
                        fnUsername.requestFocus();
                      }
                    }
                  },
                  child: TextFormField(
                    controller: _useremailTextController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Segoe UI',
                        letterSpacing: 0.3),
                    cursorColor:
                        Theme.of(context).colorScheme.textInputCursorColor,
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
                      // hintText: 'Email...',
                      // hintStyle: TextStyle(
                      //     fontFamily: 'Segoe UI',
                      //     fontSize: 15,
                      //     color:
                      //         Theme.of(context).colorScheme.searchBarTextColor),
                      labelText: 'Email...',
                      labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color:
                              Theme.of(context).colorScheme.searchBarTextColor),
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 15, top: 15, left: 15, right: 10),
                      //Error
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 14.0, fontFamily: 'Segoe UI'),
                    ),
                    validator: (value) {
                      //check if email is already used
                      Pattern pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = RegExp(pattern.toString());
                      if (!regex.hasMatch(value!)) {
                        return 'Enter a valid email address, sir';
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (_) => submit(),
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
                      backgroundColor:
                          Theme.of(context).colorScheme.brandColor),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontFamily: 'Segoe UI Black',
                        fontSize: 18,
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor),
                  ),
                  onPressed: () => submit(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  Future<void> submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      await _signUp(
          _usernameTextController.text, _useremailTextController.text);
    }
  }
}
