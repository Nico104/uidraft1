import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/constants/global_constants.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/widgets/auth/code_input_field_large_widget.dart';

enum ReSend { neutral, loading, resended, error }

class SignUpConfirmationCodeLarge extends StatefulWidget {
  const SignUpConfirmationCodeLarge(
      {Key? key,
      required this.password,
      required this.username,
      required this.useremail,
      required this.changeEmail,
      required this.resendVerificationCode})
      : super(key: key);

  final String password;
  final String username;
  final String useremail;

  final Function() changeEmail;

  final Function(http.Client) resendVerificationCode;

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
      "Hey, you, you're finally awake.\nYou should have received an Email with a 6 digit verification code.\nPlease enter the code below.\nThanks for signing up";

  //FocusNodes
  FocusNode fnCodeDigitOne = FocusNode();
  FocusNode fnCodeDigitTwo = FocusNode();
  FocusNode fnCodeDigitThree = FocusNode();
  FocusNode fnCodeDigitFour = FocusNode();
  FocusNode fnCodeDigitFive = FocusNode();
  FocusNode fnCodeDigitSix = FocusNode();

  //ReSend
  ReSend _currentResendStatus = ReSend.neutral;

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

  //TODO outsource http methods and add http client

//LoginMethod
  Future<bool> _login(String username, String password) async {
    var url = Uri.parse(baseURL + 'login');
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
    var url = Uri.parse(baseURL + 'user/signupv3');
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
    } else {
      print("nope");
    }
  }

  void setReSendStatusTo(ReSend newStatus) {
    if (mounted) {
      setState(() {
        _currentResendStatus = newStatus;
      });
    }
  }

  void clearCodeDigits() {
    setState(() {
      _codeDigitOneController.clear();
      _codeDigitTwoController.clear();
      _codeDigitThreeController.clear();
      _codeDigitFourController.clear();
      _codeDigitFiveController.clear();
      _codeDigitSixController.clear();
    });
    fnCodeDigitOne.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.brandColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Consumer<ConnectionService>(builder: (context, connection, _) {
          return Column(
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
                  "Please verify your Email",
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
                          handleInputAction: () =>
                              fnCodeDigitTwo.requestFocus(),
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
                          handleInputAction: () =>
                              fnCodeDigitFour.requestFocus(),
                          handleDeleteAction: () => handleDelete(
                              fnCodeDigitTwo, _codeDigitTwoController),
                          codeDigitController: _codeDigitThreeController),
                      //Code Digit Four
                      CodeInputField(
                          focusNode: fnCodeDigitFour,
                          handleInputAction: () =>
                              fnCodeDigitFive.requestFocus(),
                          handleDeleteAction: () => handleDelete(
                              fnCodeDigitThree, _codeDigitThreeController),
                          codeDigitController: _codeDigitFourController),
                      //Code Digit Five
                      CodeInputField(
                          focusNode: fnCodeDigitFive,
                          handleInputAction: () =>
                              fnCodeDigitSix.requestFocus(),
                          handleDeleteAction: () => handleDelete(
                              fnCodeDigitFour, _codeDigitFourController),
                          codeDigitController: _codeDigitFiveController),
                      //Code Digit Six
                      CodeInputField(
                          focusNode: fnCodeDigitSix,
                          handleInputAction: () =>
                              submit(connection.returnConnection()),
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
                      backgroundColor:
                          Theme.of(context).colorScheme.brandColor),
                  child: Text(
                    'Verify Email',
                    style: TextStyle(
                        fontFamily: 'Segoe UI Black',
                        fontSize: 18,
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor),
                  ),
                  onPressed: () => submit(connection.returnConnection()),
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
                    Consumer<ConnectionService>(
                      builder: (context, connection, _) {
                        return InkWell(
                          onTap: () async {
                            setReSendStatusTo(ReSend.loading);

                            Future<bool> succFu = widget.resendVerificationCode
                                .call(connection.returnConnection());

                            bool succ = await succFu;

                            await Future.delayed(
                                const Duration(milliseconds: 500));

                            if (succ) {
                              setReSendStatusTo(ReSend.resended);
                            } else {
                              setReSendStatusTo(ReSend.error);
                            }

                            print("Resending was: " + succ.toString());

                            clearCodeDigits();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Re-send",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'Segoe UI',
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .textInputCursorColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 4),
                              getResendStatusIcon(_currentResendStatus)
                            ],
                          ),
                        );
                      },
                    ),
                    Text(
                      " email or ",
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 16,
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () => widget.changeEmail.call(),
                      child: Text(
                        "change the email address",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .textInputCursorColor,
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
                        color:
                            Theme.of(context).colorScheme.textInputCursorColor,
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
                          color: Theme.of(context)
                              .colorScheme
                              .textInputCursorColor,
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
          );
        }));
  }

  Future<void> submit(http.Client client) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      if (await checkCode(widget.useremail, getCode(), client)) {
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

Widget getResendStatusIcon(ReSend status) {
  switch (status) {
    case ReSend.neutral:
      return const SizedBox();
    case ReSend.loading:
      return const SizedBox(
        height: 12,
        width: 12,
        child: CircularProgressIndicator(),
      );
    case ReSend.resended:
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 1, color: Colors.blue)),
        child: const Icon(Icons.check, color: Colors.blue, size: 12),
      );
    case ReSend.error:
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 1, color: Colors.red)),
        child: const Icon(Icons.error, color: Colors.red, size: 12),
      );
  }
}
