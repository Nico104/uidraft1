import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

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
  // final _profilePicturePathTextController = TextEditingController();
  // //final _profileDisplayNameTextController = TextEditingController();
  // final _profileBioTextController = TextEditingController();

  double _formProgress = 0;

  @override
  void dispose() {
    _usernameTextController.dispose();
    _userpasswordTextController.dispose();
    super.dispose();
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
                    hintText: 'Username...',
                    hintStyle: TextStyle(
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
                    //check if username exists
                    if (value == null || value.isEmpty) {
                      return 'You may enter your username, sir';
                    }
                    return null;
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
                    hintText: 'Password...',
                    hintStyle: TextStyle(
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
                    //check if password is right
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password wrong or you took someone elses username, sir';
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
                    'Login',
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
