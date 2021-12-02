import 'package:flutter/material.dart';

///Widget wich switches Screens based on Screen Width
///
///shows [smallScreen] for a Screen smaller than 800
///shows [mediumScreen] for a Screen between 1200 and 800
///shows [largeScreen] for a Screen between 1920 and 1200
///shows [veryLargeScreen] for a Screen larger than 1920
class ResponsiveWidget extends StatelessWidget {
  final Widget veryLargeScreen;
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const ResponsiveWidget(
      {Key? key,
      required this.veryLargeScreen,
      required this.largeScreen,
      required this.mediumScreen,
      required this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 1920 &&
        MediaQuery.of(context).size.width > 1200;
  }

  static bool isVeryLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1920;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1920) {
          return veryLargeScreen;
        } else if (constraints.maxWidth <= 1920 &&
            constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 800) {
          return mediumScreen;
        } else {
          return smallScreen;
        }
      },
    );
  }
}
