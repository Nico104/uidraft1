import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/theme/theme_notifier.dart';

///Icon which toggles the application theme on Tap
///takes in a Double for [iconSize] and sized the Icon accrodingly
class DarkModeSwitcherIcon extends StatelessWidget {
  const DarkModeSwitcherIcon({
    Key? key,
    this.iconSize,
  }) : super(key: key);

  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (theme.getTheme() == theme.darkTheme) {
            theme.setLightMode();
          } else {
            theme.setDarkMode();
          }
        },
        child: Icon(
          Icons.dark_mode_outlined,
          color: Theme.of(context).colorScheme.navBarIconColor,
          size: iconSize ?? 24,
        ),
      ),
    );
  }
}
