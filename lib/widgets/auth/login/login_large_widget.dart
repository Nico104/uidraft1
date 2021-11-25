import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_normal_widget.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_password_widget.dart';
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
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                print("taped");
                // html.window.location.reload();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => const FeedScreen()),
                // );
                Beamer.of(context).beamToNamed('/feed');
              },
              child: Text(
                "LOGO",
                style: TextStyle(
                    fontFamily: 'Segoe UI Black',
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
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

      return true;
    }

    return false;
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
              SizedBox(
                width: 350,
                child: TextFormFieldNormal(
                  autofocus: true,
                  controller: _usernameTextController,
                  fontSize: 15,
                  labelText: 'Username...',
                  errorText: errorText,
                  onFieldSubmitted: (_) => submit(),
                  validator: (value) {
                    //check if username exists
                    if (value == null || value.isEmpty) {
                      return 'You may enter your username, sir';
                    }
                    return null;
                  },
                  focusNode: fnUsername,
                  onTab: () => fnPassword.requestFocus(),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              //Password
              SizedBox(
                width: 350,
                child: TextFormFieldPassword(
                  autofocus: true,
                  controller: _userpasswordTextController,
                  fontSize: 15,
                  labelText: 'Password...',
                  errorText: errorText,
                  onFieldSubmitted: (_) => submit(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter a password';
                    }
                    return null;
                  },
                  focusNode: fnPassword,
                  onTab: () => fnUsername.requestFocus(),
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
        // if (await isFirstLogin()) {
        //   Beamer.of(context).beamToNamed('/changepassword');
        // } else {
        //   Beamer.of(context).beamBack();
        // }
        Beamer.of(context).beamBack();
      } else {
        setState(() {
          errorText = "Username or Password wrong";
        });
      }
    }
  }
}
