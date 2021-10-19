import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:http/http.dart' as http;

class SignUpLargeScreen extends StatelessWidget {
  const SignUpLargeScreen({Key? key}) : super(key: key);

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
          child: SizedBox(height: 670, width: 400, child: SignUpForm()),
        )
      ],
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

//SignUPForm
class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureTextPasswor1 = true;
  bool _obscureTextPasswor2 = true;

  final _usernameTextController = TextEditingController();
  final _useremailTextController = TextEditingController();
  final _userpasswordTextController = TextEditingController();
  final _userpasswordControlTextController = TextEditingController();
  // final _profilePicturePathTextController = TextEditingController();
  // //final _profileDisplayNameTextController = TextEditingController();
  // final _profileBioTextController = TextEditingController();

  String titleText =
      "It is a long established fact that a reader will be distracted by the readable content of a page when Looking";

  double _formProgress = 0;

  @override
  void dispose() {
    _usernameTextController.dispose();
    _useremailTextController.dispose();
    _userpasswordTextController.dispose();
    _userpasswordControlTextController.dispose();
    super.dispose();
  }

  Future<void> _signUp(
      String username, String useremail, String userpassword) async {
    DateTime signUpDate = DateTime.now();

    var url = Uri.parse('http://localhost:3000/user/signup');
    var response = await http.post(url, body: {
      "username": "$username",
      "useremail": "$useremail",
      "userpassword": "$userpassword",
      "userSignUpDateTime": "$signUpDate",
      // "$DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now())}",
      // "2012-04-23T18:25:43.511Z",
      "userLanguage": "en"
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print("yes");
      Navigator.of(context).pushNamed('/login');
    } else {
      print("nope");
      //Navigator.of(context).pushNamed('/login');
      setState(() {
        _usernameTextController.text = "";
        _useremailTextController.text = "";
        _userpasswordTextController.text = "";
        _userpasswordControlTextController.text = "";
        titleText = "Something went wrong, please retry";
      });
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
                child: TextFormField(
                  controller: _usernameTextController,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'Segoe UI', letterSpacing: 0.3),
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
                      return 'You may choose a username, sir';
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
                  controller: _useremailTextController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'Segoe UI', letterSpacing: 0.3),
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
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              //Password
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: _userpasswordTextController,
                  obscureText: _obscureTextPasswor1,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'Segoe UI', letterSpacing: 0.3),
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
                    // hintText: 'Password...',
                    // hintStyle: TextStyle(
                    //     fontFamily: 'Segoe UI',
                    //     fontSize: 15,
                    //     color:
                    //         Theme.of(context).colorScheme.searchBarTextColor),
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
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 3),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        const TextStyle(fontSize: 14.0, fontFamily: 'Segoe UI'),

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
              const SizedBox(
                height: 40,
              ),
              //Password2
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: _userpasswordControlTextController,
                  obscureText: _obscureTextPasswor2,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'Segoe UI', letterSpacing: 0.3),
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
                    // hintText: 'Re-enter your Password...',
                    // hintStyle: TextStyle(
                    //     fontFamily: 'Segoe UI',
                    //     fontSize: 15,
                    //     color:
                    //         Theme.of(context).colorScheme.searchBarTextColor),
                    labelText: 'Re-enter your Password...',
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
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 3),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        const TextStyle(fontSize: 14.0, fontFamily: 'Segoe UI'),

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
                        value != _userpasswordTextController.text) {
                      return 'Password does not match, sir';
                    }
                    return null;
                  },
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
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      _signUp(
                          _usernameTextController.text,
                          _useremailTextController.text,
                          _userpasswordControlTextController.text);

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
        ));
  }
}
