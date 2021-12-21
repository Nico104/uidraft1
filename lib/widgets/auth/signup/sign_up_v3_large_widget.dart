import 'package:flutter/material.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_confirmation_code_widget.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_large_widget.dart';
import 'package:http/http.dart' as http;

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
              resendVerificationCode: (client) =>
                  resendVerificationCode(client),
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
          ),
        ),
      );
    }
  }

  Future<bool> resendVerificationCode(http.Client client) async {
    if (_useremail.isNotEmpty && _username.isNotEmpty && _password.isNotEmpty) {
      return await createPendingAccount(_useremail, client);
    } else {
      print("User SignUp Data is empty. Cannot create Pending Account");
      return false;
    }
  }
}
