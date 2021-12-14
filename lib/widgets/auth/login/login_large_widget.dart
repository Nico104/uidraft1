import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_normal_widget.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_password_widget.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/network/http_client.dart';

class LoginLargeScreen extends StatelessWidget {
  const LoginLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(height: 440, width: 400, child: LoginForm()),
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

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.brandColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Consumer<ConnectionService>(builder: (context, connection, _) {
          // child: Form(
          return Form(
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
                      onFieldSubmitted: (_) =>
                          submit(connection.returnConnection()),
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
                      onFieldSubmitted: (_) =>
                          submit(connection.returnConnection()),
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
                            color: Theme.of(context)
                                .colorScheme
                                .textInputCursorColor),
                      ),
                      onPressed: () => submit(connection.returnConnection()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ));
        }));
  }

  Future<void> submit(http.Client client) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      if (await login(_usernameTextController.text,
          _userpasswordTextController.text, client)) {
        setState(() {
          errorText = null;
        });
        print("success");
        Beamer.of(context).beamBack();
      } else {
        setState(() {
          errorText = "Username or Password wrong";
        });
      }
    }
  }
}
