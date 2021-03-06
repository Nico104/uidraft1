import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uidraft1/customIcons/light_outlined/light_outline_notification_icon_icons.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/navbar/search/search_bar_navbar_large_widget.dart';

import 'empty_navbar_profilerow_widget.dart';

class EmptyNavBarLarge extends StatefulWidget {
  const EmptyNavBarLarge({
    Key? key,
  }) : super(key: key);

  final double borderRadius = 26;

  @override
  State<EmptyNavBarLarge> createState() => _EmptyNavBarLargeState();
}

class _EmptyNavBarLargeState extends State<EmptyNavBarLarge> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: MediaQuery.of(context).size.width <= 1500
              ? Theme.of(context).canvasColor
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(21, 15, 21, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //LOGO
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              // "LOGO",
                              "LOGO",
                              style: TextStyle(
                                  fontFamily: 'Segoe UI Black',
                                  fontSize: 28,
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Search Bar
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width <= 1600
                              ? MediaQuery.of(context).size.width <= 1350
                                  ? 500
                                  : 700
                              : 1000,
                          //height: 30,
                          child: SearchBar(searchBarController: _controller),
                        ),
                      ),
                    ),
                    //Icons and PB
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.7),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: EmptyNavbarProfileRow(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
