import 'package:flutter/material.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_confirmation_code_widget.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_large_widget.dart';

class SignUpV3LargeScreen extends StatefulWidget {
  const SignUpV3LargeScreen({Key? key}) : super(key: key);

  @override
  _SignUpV3LargeScreenState createState() => _SignUpV3LargeScreenState();
}

class _SignUpV3LargeScreenState extends State<SignUpV3LargeScreen> {
  bool _enterCode = false;
  // bool _enterCode = true;

  String _password = "";
  String _username = "";
  String _useremail = "";

  void setUser(String username, String useremail, String password) {
    print("setUSer");
    setState(() {
      _password = password;
      _useremail = useremail;
      _username = username;
    });
    setEnterCode(true);
  }

  void setEnterCode(bool val) {
    if (mounted) {
      if (_enterCode != val) {
        setState(() {
          _enterCode = val;
        });
      }
    }
  }

  void changeEmail() {
    if (mounted) {
      setState(() {
        _useremail = "";
      });
      setEnterCode(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_enterCode) {
      return Center(
        child: SizedBox(
            height: 760,
            width: 420,
            child: SignUpConfirmationCodeLarge(
              password: _password,
              username: _username,
              useremail: _useremail,
              changeEmail: () => changeEmail.call(),
            )),
      );
    } else {
      return Center(
        child: SizedBox(
            height: 670,
            width: 400,
            child: SignUpLarge(
              password: _password,
              username: _username,
              useremail: _useremail,
              setUser: (v, d, s) => setUser(v, d, s),
            )),
      );
    }
  }
}
