import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/auth/password/change_password_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveWidget(
      smallScreen: Text("smallScreen"),
      mediumScreen: Text("mediumScreen"),
      largeScreen: Scaffold(
        body: ChangePasswordLargeScreen(),
      ),
      veryLargeScreen: Text("veryLargeScreen"),
    );
  }
}
