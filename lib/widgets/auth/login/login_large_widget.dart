import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginLargeScreen extends StatelessWidget {
  const LoginLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: SizedBox(height: 440, width: 400, child: LoginForm()),
        )
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

//LoginForm
class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureTextPasswor1 = true;

  final _usernameTextController = TextEditingController();
  final _userpasswordTextController = TextEditingController();

  String buttonText = "Login";

  String? errorText;

  //FocusNodes
  FocusNode fnUsername = FocusNode();
  FocusNode fnPassword = FocusNode();

  @override
  void dispose() {
    _usernameTextController.dispose();
    _userpasswordTextController.dispose();
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
              //LOGO
              SizedBox(
                width: 270,
                child: Text(
                  "LOGO",
                  style: TextStyle(
                      fontFamily: 'Segoe UI Black',
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.brandColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //Username
              KeyboardListener(
                focusNode: fnUsername,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey.keyLabel == 'Tab') {
                      print("Tab pressed");
                      fnPassword.requestFocus();
                    }
                  }
                },
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    autofocus: true,
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
                      errorText: errorText,
                    ),
                    validator: (value) {
                      //check if username exists
                      if (value == null || value.isEmpty) {
                        return 'You may enter your username, sir';
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
              //Password
              KeyboardListener(
                focusNode: fnPassword,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey.keyLabel == 'Tab') {
                      print("Tab2 pressed");
                      fnUsername.requestFocus();
                    }
                  }
                },
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: _userpasswordTextController,
                    obscureText: _obscureTextPasswor1,
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
                      labelText: 'Password...',
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
                      errorText: errorText,

                      //Visibility Icon
                      suffixIcon: IconButton(
                        hoverColor: Colors.transparent,
                        onPressed: () => setState(() {
                          _obscureTextPasswor1 = !_obscureTextPasswor1;
                        }),
                        icon: _obscureTextPasswor1
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter a password';
                      }
                      return null;
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
                    'Login',
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
      if (await _login(
          _usernameTextController.text, _userpasswordTextController.text)) {
        setState(() {
          errorText = null;
        });
        print("success");
        if (await isFirstLogin()) {
          Beamer.of(context).beamToNamed('/changepassword');
        } else {
          Beamer.of(context).beamBack();
        }
      } else {
        setState(() {
          errorText = "Username or Password wrong";
        });
      }
    }
  }
}
