import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/widgets/auth/code_input_field_large_widget.dart';

class SignUpConfirmationCodeLarge extends StatefulWidget {
  const SignUpConfirmationCodeLarge(
      {Key? key,
      required this.password,
      required this.username,
      required this.useremail,
      required this.changeEmail})
      : super(key: key);

  final String password;
  final String username;
  final String useremail;

  final Function() changeEmail;

  @override
  _SignUpConfirmationCodeLargeState createState() =>
      _SignUpConfirmationCodeLargeState();
}

//SignUPLarge
class _SignUpConfirmationCodeLargeState
    extends State<SignUpConfirmationCodeLarge> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeDigitOneController = TextEditingController();
  final TextEditingController _codeDigitTwoController = TextEditingController();
  final TextEditingController _codeDigitThreeController =
      TextEditingController();
  final TextEditingController _codeDigitFourController =
      TextEditingController();
  final TextEditingController _codeDigitFiveController =
      TextEditingController();
  final TextEditingController _codeDigitSixController = TextEditingController();

  String titleText =
      "It is a long established fact that a reader will be distracted by the readable content of a page when Looking";

  //FocusNodes
  FocusNode fnCodeDigitOne = FocusNode();
  FocusNode fnCodeDigitTwo = FocusNode();
  FocusNode fnCodeDigitThree = FocusNode();
  FocusNode fnCodeDigitFour = FocusNode();
  FocusNode fnCodeDigitFive = FocusNode();
  FocusNode fnCodeDigitSix = FocusNode();

  @override
  void initState() {
    super.initState();
    fnCodeDigitOne.requestFocus();
  }

  @override
  void dispose() {
    _codeDigitOneController.dispose();
    _codeDigitTwoController.dispose();
    _codeDigitThreeController.dispose();
    _codeDigitFourController.dispose();
    _codeDigitFiveController.dispose();
    _codeDigitSixController.dispose();
    fnCodeDigitOne.dispose();
    fnCodeDigitTwo.dispose();
    fnCodeDigitThree.dispose();
    fnCodeDigitFour.dispose();
    fnCodeDigitFive.dispose();
    fnCodeDigitSix.dispose();
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

  Future<void> _signUp(
      String username, String useremail, String password) async {
    // var url = Uri.parse('http://localhost:3000/user/signupv2');
    var url = Uri.parse('http://localhost:3000/user/signupv3');
    var response = await http.post(url, body: {
      "username": username,
      "useremail": useremail,
      "userLanguage": "en",
      "userpassword": password
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print("yes");

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const AuthScreen(
      //       isLoginInitial: true,
      //       firstTimeLogin: true,
      //     ),
      //   ),
      // );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
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
            //Please veryfy email
            SizedBox(
              width: 270,
              child: Text(
                "please verify your Email",
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.textInputCursorColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
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
            //CodeField
            Expanded(
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Code Digit One
                    CodeInputField(
                        focusNode: fnCodeDigitOne,
                        handleInputAction: () => fnCodeDigitTwo.requestFocus(),
                        handleDeleteAction: () {},
                        codeDigitController: _codeDigitOneController),
                    //Code Digit Two
                    CodeInputField(
                        focusNode: fnCodeDigitTwo,
                        handleInputAction: () =>
                            fnCodeDigitThree.requestFocus(),
                        handleDeleteAction: () => handleDelete(
                            fnCodeDigitOne, _codeDigitOneController),
                        codeDigitController: _codeDigitTwoController),
                    //Code Digit Three
                    CodeInputField(
                        focusNode: fnCodeDigitThree,
                        handleInputAction: () => fnCodeDigitFour.requestFocus(),
                        handleDeleteAction: () => handleDelete(
                            fnCodeDigitTwo, _codeDigitTwoController),
                        codeDigitController: _codeDigitThreeController),
                    //Code Digit Four
                    CodeInputField(
                        focusNode: fnCodeDigitFour,
                        handleInputAction: () => fnCodeDigitFive.requestFocus(),
                        handleDeleteAction: () => handleDelete(
                            fnCodeDigitThree, _codeDigitThreeController),
                        codeDigitController: _codeDigitFourController),
                    //Code Digit Five
                    CodeInputField(
                        focusNode: fnCodeDigitFive,
                        handleInputAction: () => fnCodeDigitSix.requestFocus(),
                        handleDeleteAction: () => handleDelete(
                            fnCodeDigitFour, _codeDigitFourController),
                        codeDigitController: _codeDigitFiveController),
                    //Code Digit Six
                    CodeInputField(
                        focusNode: fnCodeDigitSix,
                        handleInputAction: () => submit(),
                        handleDeleteAction: () => handleDelete(
                            fnCodeDigitFive, _codeDigitFiveController),
                        codeDigitController: _codeDigitSixController),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            //TODO manually verify code button
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
                  'Verify Email',
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
              height: 50,
            ),
            SizedBox(
              width: 270,
              child: Text(
                "Didn't reveive the email? Check your spam folder.",
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.textInputCursorColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 340,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TODO Resend email
                  Text(
                    "Re-send",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Segoe UI',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.textInputCursorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    " email or ",
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.textInputCursorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  //! Takes User back to SignUp but with all fields filled again, except email and set focus on email field
                  //TODO testen
                  InkWell(
                    onTap: () => widget.changeEmail.call(),
                    child: Text(
                      "change the email address",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Segoe UI',
                        fontSize: 16,
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 270,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have a Ligma account? ",
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.textInputCursorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  //! Takes User to Login
                  InkWell(
                    onTap: () => Beamer.of(context).beamToNamed('/login'),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Segoe UI',
                        fontSize: 16,
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            //Already have an Account?
          ],
        ));
  }

  Future<void> submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      if (await checkCode(widget.useremail, getCode())) {
        await _signUp(widget.username, widget.useremail, widget.password);

        if (await _login(widget.username, widget.password)) {
          print("logged in");
          Beamer.of(context).beamToNamed('/feed');
        } else {
          setState(() {
            print("Username or Password wrong");
          });
        }
      } else {
        print("code wrong");
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
    }
  }

  String getCode() {
    return _codeDigitOneController.text +
        _codeDigitTwoController.text +
        _codeDigitThreeController.text +
        _codeDigitFourController.text +
        _codeDigitFiveController.text +
        _codeDigitSixController.text;
  }
}

void handleDelete(FocusNode fn, TextEditingController tctrl) {
  tctrl.clear();
  fn.requestFocus();
}
