import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/navicons/dark_mode_switcher_icon.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/utils/widgets/toggle/toggle_animated_button_widget.dart';
import 'package:uidraft1/widgets/auth/login/initial_login_large_widget.dart';
import 'package:uidraft1/widgets/auth/login/login_large_widget.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_large_widget.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_v2_large_widget.dart';
import 'package:uidraft1/widgets/auth/signup/sign_up_v3_large_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(
      {Key? key,
      required this.isLoginInitial,
      // required this.firstTimeLogin,
      this.username})
      : super(key: key);

  final bool isLoginInitial;
  // final bool firstTimeLogin;
  final String? username;

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  late bool isLogin;

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   isLogin = widget.isLoginInitial;
    // });
    isLogin = widget.isLoginInitial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: const Text("smallScreen"),
      mediumScreen: const Text("mediumScreen"),
      largeScreen: Scaffold(
        body: Stack(
          children: [
            isLogin
                ? const LoginLargeScreen()
                // : const SignUpV2LargeScreen(),
                : const SignUpV3LargeScreen(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(72, 34, 0, 0),
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Beamer.of(context).beamToNamed('/feed');
                      },
                      child: Text(
                        "LOGO",
                        style: TextStyle(
                            fontFamily: 'Segoe UI Black',
                            fontSize: 28,
                            color: Theme.of(context).colorScheme.brandColor),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
                    child: Row(
                      children: [
                        const DarkModeSwitcherIcon(),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 180,
                          height: 100,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: AnimatedToggle(
                              firstInitialPosition: widget.isLoginInitial,
                              values: const ['Login', 'SignUp'],
                              onToggleCallback: (value) {
                                print("value: " + value.toString());
                                if (value == 0) {
                                  setState(() {
                                    isLogin = true;
                                  });
                                } else {
                                  setState(() {
                                    isLogin = false;
                                  });
                                }
                                print("isogin: " + isLogin.toString());
                              },
                              buttonColor:
                                  Theme.of(context).colorScheme.brandColor,
                              backgroundColor:
                                  Theme.of(context).colorScheme.searchBarColor,
                              textColor:
                                  Theme.of(context).colorScheme.highlightColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      veryLargeScreen: const Text("veryLargeScreen"),
    );
  }
}
