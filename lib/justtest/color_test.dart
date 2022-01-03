import 'package:flutter/material.dart';

class ColorTest extends StatefulWidget {
  const ColorTest({Key? key}) : super(key: key);

  @override
  _ColorTestState createState() => _ColorTestState();
}

class _ColorTestState extends State<ColorTest> {
  bool isDarkMode = true;
  bool showSemantics = true;

  //https://colors.eva.design/

  Color brandcolor = const Color(0xff7A56FF);
  Color success = const Color(0xff6BC128);
  Color info = const Color(0xff1DBEF4);
  Color warning = const Color(0xffFFE949);
  Color danger = const Color(0xffFF442B);

  //Light Theme Colors
  Color backgroundDark = const Color(0xff121212);
  // Color backgroundDark = const Color(0xff1E1926);

  //Dark Theme Colors
  // Color backgroundLight = const Color(0xffFDF7FF);
  Color backgroundLight = const Color(0xffF8F8FF);

  Color textDark1 = const Color(0xffFFFFFF); //important
  Color textDark2 = const Color(0xffF8F8FF); //default
  Color textDark3 = const Color(0xffF0F0F0); //non important

  Color textLight1 = const Color(0xff000000); //important
  Color textLight2 = const Color(0xff121212); //default
  Color textLight3 = const Color(0xff202020); //non important

  // Color accent = const Color(0xffFFD470);
  Color accent = const Color(0xffFFEE57);

  Color buttonHover = const Color(0xffFFEE57).withOpacity(0.9);
  Color buttonPressed = const Color(0xffFFEE57).withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          !isDarkMode ? const Color(0xFFF8F8FF) : const Color(0xFF121212),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showSemantics = !showSemantics;
              });
            },
          ),
          const SizedBox(width: 18),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 30,
            runSpacing: 30,
            children: [
              ColorBlock(
                  color: brandcolor,
                  hex: "7A56FF",
                  desc: "brandcolor",
                  width: 600,
                  height: 700,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: accent,
                  hex: "FFD470",
                  desc: "accent",
                  width: 500,
                  height: 600,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),

              //? Button Hover and Pressed
              ColorBlock(
                  color: buttonHover,
                  hex: "121212",
                  desc: "Button Hover",
                  width: 180,
                  height: 230,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: buttonPressed,
                  hex: "121212",
                  desc: "Button Pressed",
                  width: 180,
                  height: 230,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),

              //? Semantics
              showSemantics
                  ? ColorBlock(
                      color: success,
                      hex: "6BC128",
                      desc: "success",
                      width: 200,
                      height: 250,
                      textcolor: isDarkMode ? backgroundLight : backgroundDark)
                  : const SizedBox(),

              showSemantics
                  ? ColorBlock(
                      color: info,
                      hex: "1DBEF4",
                      desc: "info",
                      width: 200,
                      height: 250,
                      textcolor: isDarkMode ? backgroundLight : backgroundDark)
                  : const SizedBox(),

              // showSemantics ?
              // ColorBlock(
              //     color: warning,
              //     hex: "FFE949",
              //     desc: "warning",
              //     width: 200,
              //     height: 250,
              //     textcolor: isDarkMode ? backgroundLight : backgroundDark)
              // : const SizedBox(),

              showSemantics
                  ? ColorBlock(
                      color: danger,
                      hex: "FF442B",
                      desc: "error/danger",
                      width: 200,
                      height: 250,
                      textcolor: isDarkMode ? backgroundLight : backgroundDark)
                  : const SizedBox(),

              //? Text
              ColorBlock(
                  color: textDark1,
                  hex: "121212",
                  desc: "textDark1 - important",
                  width: 150,
                  height: 180,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: textDark2,
                  hex: "121212",
                  desc: "textDark2 - default",
                  width: 150,
                  height: 180,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: textDark3,
                  hex: "121212",
                  desc: "textDark3 - non important",
                  width: 150,
                  height: 180,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: textLight1,
                  hex: "121212",
                  desc: "textLight1 - important",
                  width: 150,
                  height: 180,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: textLight2,
                  hex: "121212",
                  desc: "textLight2 - default",
                  width: 150,
                  height: 180,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
              ColorBlock(
                  color: textLight3,
                  hex: "121212",
                  desc: "textLight3 - non important",
                  width: 150,
                  height: 180,
                  textcolor: isDarkMode ? backgroundLight : backgroundDark),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorBlock extends StatelessWidget {
  const ColorBlock(
      {Key? key,
      required this.color,
      required this.hex,
      required this.width,
      required this.height,
      required this.textcolor,
      required this.desc})
      : super(key: key);

  final Color color;
  final Color textcolor;

  final String hex;
  final String desc;

  final double width, height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
              child: Container(
            color: color,
          )),
          const SizedBox(width: 14),
          Text(
            hex + " - " + desc,
            style: TextStyle(color: textcolor, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}
