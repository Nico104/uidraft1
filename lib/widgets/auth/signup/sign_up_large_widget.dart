import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_check_widget.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_password_widget.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:http/http.dart' as http;

class SignUpLarge extends StatefulWidget {
  const SignUpLarge(
      {Key? key,
      required this.setUser,
      required this.password,
      required this.username,
      required this.useremail})
      : super(key: key);

  final String password;
  final String username;
  final String useremail;

  final Function(String, String, String) setUser;

  @override
  _SignUpLargeState createState() => _SignUpLargeState();
}

//SignUPLarge
class _SignUpLargeState extends State<SignUpLarge> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _useremailTextController = TextEditingController();
  final _userpasswordTextController = TextEditingController();
  final _userpasswordControlTextController = TextEditingController();

  FocusNode fnUsername = FocusNode();
  FocusNode fnUseremail = FocusNode();
  FocusNode fnUserpassword = FocusNode();
  FocusNode fnUserControlpassword = FocusNode();

  String titleText =
      "It is a long established fact that a reader will be distracted by the readable content of a page when Looking";

  @override
  void dispose() {
    _usernameTextController.dispose();
    _useremailTextController.dispose();
    _userpasswordTextController.dispose();
    _userpasswordControlTextController.dispose();
    fnUserControlpassword.dispose();
    fnUseremail.dispose();
    fnUsername.dispose();
    fnUserpassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _usernameTextController.text = widget.username;
      _useremailTextController.text = widget.useremail;
      _userpasswordTextController.text = widget.password;
      _userpasswordControlTextController.text = widget.password;
    });
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
          // child: const SizedBox(),
          child: Consumer<ConnectionService>(builder: (context, connection, _) {
            return Column(
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
                  child: TextFormFieldCheck(
                    // checking: isUsernameAvailable(_usernameTextController.text),
                    checking: (check) => isUsernameAvailable.call(
                        check, connection.returnConnection()),
                    controller: _usernameTextController,
                    focusNode: fnUsername,
                    fontSize: 15,
                    labelText: 'Username...',
                    autofocus: widget.username.isEmpty ? true : false,
                    validator: (value) {
                      //Check if username is free
                      if (value == null || value.isEmpty) {
                        return 'You may choose a username, sir';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) =>
                        submit(connection.returnConnection()),
                    onTab: () => fnUseremail.requestFocus(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                //Useremail
                SizedBox(
                  width: 350,
                  child: TextFormFieldCheck(
                    checking: (check) => isUseremailAvailable.call(
                        check, connection.returnConnection()),
                    controller: _useremailTextController,
                    focusNode: fnUseremail,
                    fontSize: 15,
                    labelText: 'Email...',
                    autofocus: widget.useremail.isEmpty ? true : false,
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
                    onFieldSubmitted: (_) =>
                        submit(connection.returnConnection()),
                    onTab: () => fnUserpassword.requestFocus(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                //Password
                SizedBox(
                  width: 350,
                  child: TextFormFieldPassword(
                    controller: _userpasswordTextController,
                    fontSize: 15,
                    labelText: 'Password...',
                    onFieldSubmitted: (_) =>
                        submit(connection.returnConnection()),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password has to be at least 6 characters, sir';
                      }
                      return null;
                    },
                    focusNode: fnUserpassword,
                    onTab: () => fnUserControlpassword.requestFocus(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                //Password2
                SizedBox(
                  width: 350,
                  child: TextFormFieldPassword(
                    controller: _userpasswordControlTextController,
                    fontSize: 15,
                    labelText: 'Re-enter your Password...',
                    onFieldSubmitted: (_) =>
                        submit(connection.returnConnection()),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != _userpasswordTextController.text) {
                        return 'Password does not match, sir';
                      }
                      return null;
                    },
                    focusNode: fnUserControlpassword,
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
                      'Sign Up',
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
            );
          }),
        ));
  }

  Future<void> submit(http.Client client) async {
    if (_formKey.currentState!.validate()) {
      if (await createPendingAccount(_useremailTextController.text, client)) {
        widget.setUser(
            _usernameTextController.text,
            _useremailTextController.text,
            _userpasswordControlTextController.text);
      } else {
        print("pending user error");
      }
    }
  }
}
