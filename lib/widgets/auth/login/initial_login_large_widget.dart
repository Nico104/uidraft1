// import 'package:beamer/beamer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:uidraft1/utils/auth/authentication_global.dart';
// import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uidraft1/utils/constants/global_constants.dart';

// class InitialLoginLargeScreen extends StatelessWidget {
//   const InitialLoginLargeScreen({Key? key, required this.username})
//       : super(key: key);

//   final String username;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Align(
//           alignment: Alignment.topLeft,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(72, 34, 0, 0),
//             child: Text(
//               "LOGO",
//               style: TextStyle(
//                   fontFamily: 'Segoe UI Black',
//                   fontSize: 28,
//                   color: Theme.of(context).colorScheme.brandColor),
//             ),
//           ),
//         ),
//         Center(
//           child: SizedBox(
//               height: 620,
//               width: 400,
//               child: InitialLoginForm(
//                 username: username,
//               )),
//         )
//       ],
//     );
//   }
// }

// class InitialLoginForm extends StatefulWidget {
//   const InitialLoginForm({Key? key, required this.username}) : super(key: key);

//   final String username;

//   @override
//   _InitialLoginFormState createState() => _InitialLoginFormState();
// }

// //InitialLoginForm
// class _InitialLoginFormState extends State<InitialLoginForm> {
//   final _formKey = GlobalKey<FormState>();
//   bool _obscureTextPasswor1 = true;
//   bool _obscureTextPasswor2 = true;
//   bool _obscureTextPasswor3 = true;

//   final _usernameTextController = TextEditingController();
//   final _userpasswordTextController = TextEditingController();

//   final _newUserpasswordTextController = TextEditingController();
//   final _newConfirmUserpasswordTextController = TextEditingController();

//   String buttonText = "Login";

//   String? errorText;

//   //FocusNodes
//   FocusNode fnUsername = FocusNode();
//   FocusNode fnPassword = FocusNode();
//   FocusNode fnNewPassword = FocusNode();
//   FocusNode fnNewConfirmPAssword = FocusNode();

//   @override
//   void dispose() {
//     _usernameTextController.dispose();
//     _userpasswordTextController.dispose();
//     _newConfirmUserpasswordTextController.dispose();
//     _newUserpasswordTextController.dispose();
//     fnUsername.dispose();
//     fnPassword.dispose();
//     fnNewConfirmPAssword.dispose();
//     fnNewPassword.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     fnPassword.requestFocus();
//   }

//   //LoginMethod
//   Future<bool> _login(String username, String password) async {
//     var url = Uri.parse(baseURL + 'login');
//     var response = await http
//         .post(url, body: {'username': '$username', 'password': '$password'});
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 201) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString(
//           'access_token', json.decode(response.body)["access_token"]);
//       print("Acess Token: ${prefs.getString('access_token')}");

//       // Navigator.of(context).pushNamed('/');
//       // Beamer.of(context).beamToNamed('/');
//       return true;
//     }

//     return false;
//     //Navigator.of(context).pushNamed('/welcome');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: Theme.of(context).colorScheme.brandColor, width: 2),
//             borderRadius: const BorderRadius.all(Radius.circular(20))),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               //LOGO
//               SizedBox(
//                 width: 270,
//                 child: Text(
//                   "LOGO",
//                   style: TextStyle(
//                       fontFamily: 'Segoe UI Black',
//                       fontSize: 28,
//                       color: Theme.of(context).colorScheme.brandColor),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               //Username
//               SizedBox(
//                 width: 350,
//                 child: KeyboardListener(
//                   focusNode: fnUsername,
//                   onKeyEvent: (event) {
//                     if (event is KeyDownEvent) {
//                       if (event.logicalKey.keyLabel == 'Tab') {
//                         print("Tab pressed");
//                         fnPassword.requestFocus();
//                       }
//                     }
//                   },
//                   child: TextFormField(
//                     initialValue: widget.username,
//                     controller: _usernameTextController,
//                     style: const TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'Segoe UI',
//                         letterSpacing: 0.3),
//                     cursorColor:
//                         Theme.of(context).colorScheme.textInputCursorColor,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 0.5),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 2),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       filled: true,
//                       fillColor: Theme.of(context).canvasColor,
//                       // hintText: 'Username...',
//                       // hintStyle: TextStyle(
//                       //     fontFamily: 'Segoe UI',
//                       //     fontSize: 15,
//                       //     color:
//                       //         Theme.of(context).colorScheme.searchBarTextColor),
//                       labelText: 'Username...',
//                       labelStyle: TextStyle(
//                           fontFamily: 'Segoe UI',
//                           fontSize: 15,
//                           color:
//                               Theme.of(context).colorScheme.searchBarTextColor),
//                       isDense: true,
//                       contentPadding: const EdgeInsets.only(
//                           bottom: 15, top: 15, left: 15, right: 10),
//                       //Error
//                       errorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 1),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 3),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       errorStyle: const TextStyle(
//                           fontSize: 14.0, fontFamily: 'Segoe UI'),
//                       errorText: errorText,
//                     ),
//                     validator: (value) {
//                       //check if username exists
//                       if (value == null || value.isEmpty) {
//                         return 'You may enter your username, sir';
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (_) => submit(),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               //Password
//               SizedBox(
//                 width: 350,
//                 child: KeyboardListener(
//                   focusNode: fnPassword,
//                   onKeyEvent: (event) {
//                     if (event is KeyDownEvent) {
//                       if (event.logicalKey.keyLabel == 'Tab') {
//                         print("Tab pressed");
//                         fnNewPassword.requestFocus();
//                       }
//                     }
//                   },
//                   child: TextFormField(
//                     controller: _userpasswordTextController,
//                     obscureText: _obscureTextPasswor1,
//                     // autovalidateMode: AutovalidateMode.onUserInteraction,
//                     style: const TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'Segoe UI',
//                         letterSpacing: 0.3),
//                     cursorColor:
//                         Theme.of(context).colorScheme.textInputCursorColor,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 0.5),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 2),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       filled: true,
//                       fillColor: Theme.of(context).canvasColor,
//                       // hintText: 'Password...',
//                       // hintStyle: TextStyle(
//                       //     fontFamily: 'Segoe UI',
//                       //     fontSize: 15,
//                       //     color:
//                       //         Theme.of(context).colorScheme.searchBarTextColor),
//                       labelText: 'Current Password...',
//                       labelStyle: TextStyle(
//                           fontFamily: 'Segoe UI',
//                           fontSize: 15,
//                           color:
//                               Theme.of(context).colorScheme.searchBarTextColor),
//                       isDense: true,
//                       contentPadding: const EdgeInsets.only(
//                           bottom: 15, top: 15, left: 15, right: 10),
//                       //Error
//                       errorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 1),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 3),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       errorStyle: const TextStyle(
//                           fontSize: 14.0, fontFamily: 'Segoe UI'),
//                       errorText: errorText,

//                       //Visibility Icon
//                       suffixIcon: IconButton(
//                         hoverColor: Colors.transparent,
//                         onPressed: () => setState(() {
//                           _obscureTextPasswor1 = !_obscureTextPasswor1;
//                         }),
//                         icon: _obscureTextPasswor1
//                             ? const Icon(Icons.visibility_outlined)
//                             : const Icon(Icons.visibility_off_outlined),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'please enter a password';
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (_) => submit(),
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 40,
//               ),
//               //New Password
//               SizedBox(
//                 width: 350,
//                 child: KeyboardListener(
//                   focusNode: fnNewPassword,
//                   onKeyEvent: (event) {
//                     if (event is KeyDownEvent) {
//                       if (event.logicalKey.keyLabel == 'Tab') {
//                         print("Tab pressed");
//                         fnNewConfirmPAssword.requestFocus();
//                       }
//                     }
//                   },
//                   child: TextFormField(
//                     controller: _newUserpasswordTextController,
//                     obscureText: _obscureTextPasswor2,
//                     style: const TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'Segoe UI',
//                         letterSpacing: 0.3),
//                     cursorColor:
//                         Theme.of(context).colorScheme.textInputCursorColor,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 0.5),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 2),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       filled: true,
//                       fillColor: Theme.of(context).canvasColor,
//                       labelText: 'New Password...',
//                       labelStyle: TextStyle(
//                           fontFamily: 'Segoe UI',
//                           fontSize: 15,
//                           color:
//                               Theme.of(context).colorScheme.searchBarTextColor),
//                       isDense: true,
//                       contentPadding: const EdgeInsets.only(
//                           bottom: 15, top: 15, left: 15, right: 10),
//                       //Error
//                       errorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 1),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 3),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       errorStyle: const TextStyle(
//                           fontSize: 14.0, fontFamily: 'Segoe UI'),
//                       // errorText: errorText,

//                       //Visibility Icon
//                       suffixIcon: IconButton(
//                         hoverColor: Colors.transparent,
//                         onPressed: () => setState(() {
//                           _obscureTextPasswor2 = !_obscureTextPasswor2;
//                         }),
//                         icon: _obscureTextPasswor2
//                             ? const Icon(Icons.visibility_outlined)
//                             : const Icon(Icons.visibility_off_outlined),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty || value.length < 6) {
//                         return 'Password has to be at least 6 characters, sir';
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (_) => submit(),
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 40,
//               ),
//               //Confirm New Password
//               SizedBox(
//                 width: 350,
//                 child: KeyboardListener(
//                   focusNode: fnNewConfirmPAssword,
//                   onKeyEvent: (event) {
//                     if (event is KeyDownEvent) {
//                       if (event.logicalKey.keyLabel == 'Tab') {
//                         print("Tab pressed");
//                         fnUsername.requestFocus();
//                       }
//                     }
//                   },
//                   child: TextFormField(
//                     controller: _newConfirmUserpasswordTextController,
//                     obscureText: _obscureTextPasswor3,
//                     style: const TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'Segoe UI',
//                         letterSpacing: 0.3),
//                     cursorColor:
//                         Theme.of(context).colorScheme.textInputCursorColor,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 0.5),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.brandColor,
//                             width: 2),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       filled: true,
//                       fillColor: Theme.of(context).canvasColor,
//                       labelText: 'Confirm New Password...',
//                       labelStyle: TextStyle(
//                           fontFamily: 'Segoe UI',
//                           fontSize: 15,
//                           color:
//                               Theme.of(context).colorScheme.searchBarTextColor),
//                       isDense: true,
//                       contentPadding: const EdgeInsets.only(
//                           bottom: 15, top: 15, left: 15, right: 10),
//                       //Error
//                       errorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 1),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.red, width: 3),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       errorStyle: const TextStyle(
//                           fontSize: 14.0, fontFamily: 'Segoe UI'),
//                       // errorText: errorText,

//                       //Visibility Icon
//                       suffixIcon: IconButton(
//                         hoverColor: Colors.transparent,
//                         onPressed: () => setState(() {
//                           _obscureTextPasswor3 = !_obscureTextPasswor3;
//                         }),
//                         icon: _obscureTextPasswor3
//                             ? const Icon(Icons.visibility_outlined)
//                             : const Icon(Icons.visibility_off_outlined),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null ||
//                           value.isEmpty ||
//                           value != _newUserpasswordTextController.text) {
//                         return 'Password does not match, sir';
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (_) => submit(),
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 60,
//               ),
//               //Submit Button
//               SizedBox(
//                 width: 200,
//                 height: 40,
//                 child: TextButton(
//                   style: TextButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       backgroundColor:
//                           Theme.of(context).colorScheme.brandColor),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                         fontFamily: 'Segoe UI Black',
//                         fontSize: 18,
//                         color:
//                             Theme.of(context).colorScheme.textInputCursorColor),
//                   ),
//                   onPressed: () => submit(),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ));
//   }

//   Future<void> submit() async {
//     // Validate returns true if the form is valid, or false otherwise.
//     if (_formKey.currentState!.validate()) {
//       if (await _login(
//           _usernameTextController.text, _userpasswordTextController.text)) {
//         setState(() {
//           errorText = null;
//         });
//         print("login success");
//         if (await changePassword(_newConfirmUserpasswordTextController.text) ==
//             200) {
//           print("password chnaged");
//         } else {
//           print("problem while changing password");
//         }

//         Beamer.of(context).beamToNamed('/feed');
//         // Beamer.of(context).beamBack();
//       } else {
//         setState(() {
//           errorText = "Username or Password wrong";
//         });
//       }
//     }
//   }
// }
