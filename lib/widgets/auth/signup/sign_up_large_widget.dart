import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_check_widget.dart';
import 'package:uidraft1/uiwidgets/textfields/textformfield_password_widget.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

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
                child: TextFormFieldCheck(
                  checking: isUsernameAvailable(_usernameTextController.text),
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
                  onFieldSubmitted: (_) => submit(),
                  onTab: () => fnUseremail.requestFocus(),
                ),
                //TODO Check if CHECKING works properly with server and delete commented part
                // child: KeyboardListener(
                //   focusNode: fnUsername,
                //   onKeyEvent: (event) {
                //     if (event is KeyDownEvent) {
                //       if (event.logicalKey.keyLabel == 'Tab') {
                //         print("Tab pressed");
                //         fnUseremail.requestFocus();
                //       }
                //     }
                //   },
                //   child: StatefulBuilder(
                //     builder: (BuildContext context, setUsernameState) {
                //       return TextFormField(
                //         autofocus: widget.username.isEmpty ? true : false,
                //         controller: _usernameTextController,
                //         style: const TextStyle(
                //             fontSize: 15,
                //             fontFamily: 'Segoe UI',
                //             letterSpacing: 0.3),
                //         cursorColor:
                //             Theme.of(context).colorScheme.textInputCursorColor,
                //         decoration: InputDecoration(
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: Theme.of(context).colorScheme.brandColor,
                //                 width: 0.5),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: Theme.of(context).colorScheme.brandColor,
                //                 width: 2),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           filled: true,
                //           fillColor: Theme.of(context).canvasColor,
                //           labelText: 'Username...',
                //           labelStyle: TextStyle(
                //               fontFamily: 'Segoe UI',
                //               fontSize: 15,
                //               color: Theme.of(context)
                //                   .colorScheme
                //                   .searchBarTextColor),
                //           isDense: true,
                //           contentPadding: const EdgeInsets.only(
                //               bottom: 15, top: 15, left: 15, right: 10),
                //           //Error
                //           errorBorder: OutlineInputBorder(
                //             borderSide:
                //                 const BorderSide(color: Colors.red, width: 1),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           focusedErrorBorder: OutlineInputBorder(
                //             borderSide:
                //                 const BorderSide(color: Colors.red, width: 3),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           errorStyle: const TextStyle(
                //               fontSize: 14.0, fontFamily: 'Segoe UI'),
                //           suffixIcon: _usernameTextController.text.isNotEmpty
                //               ? FutureBuilder(
                //                   future: isUsernameAvailable(
                //                       _usernameTextController.text),
                //                   builder: (BuildContext context,
                //                       AsyncSnapshot<bool> snapshot) {
                //                     if (snapshot.hasData) {
                //                       if (snapshot.data!) {
                //                         return const Icon(Icons.check);
                //                       } else {
                //                         return const Icon(Icons.cancel);
                //                       }
                //                     } else {
                //                       return Transform.scale(
                //                           scale: 0.5,
                //                           child:
                //                               const CircularProgressIndicator());
                //                     }
                //                   },
                //                 )
                //               : null,
                //         ),
                //         validator: (value) {
                //           //Check if username is free
                //           if (value == null || value.isEmpty) {
                //             return 'You may choose a username, sir';
                //           }
                //           return null;
                //         },
                //         onFieldSubmitted: (_) => submit(),
                //         onChanged: (_) {
                //           EasyDebounce.debounce(
                //               'subchannelNameTextField-debouncer', // <-- An ID for this particular debouncer
                //               const Duration(
                //                   milliseconds:
                //                       500), // <-- The debounce duration
                //               () => setUsernameState(
                //                   () {})); // <-- The target method
                //         },
                //       );
                //     },
                //   ),
                // ),
              ),
              const SizedBox(
                height: 40,
              ),
              //Useremail
              SizedBox(
                width: 350,
                child: TextFormFieldCheck(
                  checking: isUseremailAvailable(_useremailTextController.text),
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
                  onFieldSubmitted: (_) => submit(),
                  onTab: () => fnUserpassword.requestFocus(),
                ),
                //TODO Check if CHECKING works properly with server and delete commented part
                // child: KeyboardListener(
                //   focusNode: fnUseremail,
                //   onKeyEvent: (event) {
                //     if (event is KeyDownEvent) {
                //       if (event.logicalKey.keyLabel == 'Tab') {
                //         print("Tab pressed");
                //         fnUserpassword.requestFocus();
                //       }
                //     }
                //   },
                //   child: StatefulBuilder(
                //     builder: (BuildContext context, setUseremailState) {
                //       return TextFormField(
                //         autofocus: widget.useremail.isEmpty ? true : false,
                //         controller: _useremailTextController,
                //         keyboardType: TextInputType.emailAddress,
                //         style: const TextStyle(
                //             fontSize: 15,
                //             fontFamily: 'Segoe UI',
                //             letterSpacing: 0.3),
                //         cursorColor:
                //             Theme.of(context).colorScheme.textInputCursorColor,
                //         decoration: InputDecoration(
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: Theme.of(context).colorScheme.brandColor,
                //                 width: 0.5),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: Theme.of(context).colorScheme.brandColor,
                //                 width: 2),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           filled: true,
                //           fillColor: Theme.of(context).canvasColor,
                //           // hintText: 'Email...',
                //           // hintStyle: TextStyle(
                //           //     fontFamily: 'Segoe UI',
                //           //     fontSize: 15,
                //           //     color:
                //           //         Theme.of(context).colorScheme.searchBarTextColor),
                //           labelText: 'Email...',
                //           labelStyle: TextStyle(
                //               fontFamily: 'Segoe UI',
                //               fontSize: 15,
                //               color: Theme.of(context)
                //                   .colorScheme
                //                   .searchBarTextColor),
                //           isDense: true,
                //           contentPadding: const EdgeInsets.only(
                //               bottom: 15, top: 15, left: 15, right: 10),
                //           //Error
                //           errorBorder: OutlineInputBorder(
                //             borderSide:
                //                 const BorderSide(color: Colors.red, width: 1),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           focusedErrorBorder: OutlineInputBorder(
                //             borderSide:
                //                 const BorderSide(color: Colors.red, width: 3),
                //             borderRadius: BorderRadius.circular(30.0),
                //           ),
                //           errorStyle: const TextStyle(
                //               fontSize: 14.0, fontFamily: 'Segoe UI'),
                //           suffixIcon: _useremailTextController.text.isNotEmpty
                //               ? FutureBuilder(
                //                   future: isUseremailAvailable(
                //                       _useremailTextController.text),
                //                   builder: (BuildContext context,
                //                       AsyncSnapshot<bool> snapshot) {
                //                     if (snapshot.hasData) {
                //                       if (snapshot.data!) {
                //                         return const Icon(Icons.check);
                //                       } else {
                //                         return const Icon(Icons.cancel);
                //                       }
                //                     } else {
                //                       return const CircularProgressIndicator();
                //                     }
                //                   },
                //                 )
                //               : null,
                //         ),
                //         validator: (value) {
                //           //check if email is already used
                //           Pattern pattern =
                //               r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                //               r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                //               r"{0,253}[a-zA-Z0-9])?)*$";
                //           RegExp regex = RegExp(pattern.toString());
                //           if (!regex.hasMatch(value!)) {
                //             return 'Enter a valid email address, sir';
                //           } else {
                //             return null;
                //           }
                //         },
                //         onFieldSubmitted: (_) => submit(),
                //         onChanged: (_) {
                //           EasyDebounce.debounce(
                //               'subchannelNameTextField-debouncer', // <-- An ID for this particular debouncer
                //               const Duration(
                //                   milliseconds:
                //                       500), // <-- The debounce duration
                //               () => setUseremailState(
                //                   () {})); // <-- The target method
                //         },
                //       );
                //     },
                //   ),
                // ),
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
                  onFieldSubmitted: (_) => submit(),
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
                  onFieldSubmitted: (_) => submit(),
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
    if (_formKey.currentState!.validate()) {
      if (await createPendingAccount(_useremailTextController.text)) {
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
