import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uidraft1/utils/network/http_client.dart';

class ChangePasswordLargeScreen extends StatelessWidget {
  const ChangePasswordLargeScreen({Key? key}) : super(key: key);

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
          child: SizedBox(height: 440, width: 400, child: ChangePasswordForm()),
        )
      ],
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

//ChangePasswordForm
class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureTextPasswor1 = true;
  bool _obscureTextPasswor2 = true;

  final _newUserpasswordTextController = TextEditingController();
  final _newConfirmUserpasswordTextController = TextEditingController();

  String buttonText = "Change Password";

  String? errorText;

  //FocusNodes
  FocusNode fnNewPassword = FocusNode();
  FocusNode fnNewConfirmPAssword = FocusNode();

  @override
  void dispose() {
    _newConfirmUserpasswordTextController.dispose();
    _newUserpasswordTextController.dispose();
    fnNewConfirmPAssword.dispose();
    fnNewPassword.dispose();
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
              //New Password
              SizedBox(
                width: 350,
                child: KeyboardListener(
                  focusNode: fnNewPassword,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey.keyLabel == 'Tab') {
                        print("Tab pressed");
                        fnNewConfirmPAssword.requestFocus();
                      }
                    }
                  },
                  child: TextFormField(
                    controller: _newUserpasswordTextController,
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
                      labelText: 'New Password...',
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
                      // errorText: errorText,

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
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password has to be at least 6 characters, sir';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),
              //Confirm New Password
              SizedBox(
                width: 350,
                child: KeyboardListener(
                  focusNode: fnNewConfirmPAssword,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey.keyLabel == 'Tab') {
                        print("Tab pressed");
                        fnNewPassword.requestFocus();
                      }
                    }
                  },
                  child: TextFormField(
                    controller: _newConfirmUserpasswordTextController,
                    obscureText: _obscureTextPasswor2,
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
                      labelText: 'Confirm New Password...',
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
                      // errorText: errorText,

                      //Visibility Icon
                      suffixIcon: IconButton(
                        hoverColor: Colors.transparent,
                        onPressed: () => setState(() {
                          _obscureTextPasswor2 = !_obscureTextPasswor2;
                        }),
                        icon: _obscureTextPasswor2
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != _newUserpasswordTextController.text) {
                        return 'Password does not match, sir';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 60,
              ),
              //Submit Button
              Consumer<ConnectionService>(builder: (context, connection, _) {
                return SizedBox(
                  // width: 200,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.brandColor),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                          fontFamily: 'Segoe UI Black',
                          fontSize: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .textInputCursorColor),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        if (await changePassword(
                                _newConfirmUserpasswordTextController.text,
                                connection.returnConnection()) ==
                            200) {
                          print("password chnaged");
                        } else {
                          print("problem while changing password");
                        }
                        Beamer.of(context).beamToNamed('/feed');
                      }
                    },
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
