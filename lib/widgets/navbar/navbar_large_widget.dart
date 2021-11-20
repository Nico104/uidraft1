import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/customIcons/light_outlined/light_outline_notification_icon_icons.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/navbar/navbar_util_methods.dart';
import 'package:uidraft1/utils/theme/theme_notifier.dart';
import 'package:uidraft1/widgets/navbar/customfeed/customfeedlist/custom_feed_list_dialog_widget.dart';
import 'dart:convert';
import 'dart:html' as html;

// import 'package:uidraft1/widgets/navbar/navbar_menu_large_widget.dart';
import 'package:uidraft1/widgets/notification/notificationList/notification_list_dialog_widget.dart';

import 'navbar_menu_large_widget.dart';
import 'options/options_grid_widget.dart';

//! Test GlobalKey for tap menu
// GlobalKey<_NavBarLargeState> globalKey = GlobalKey();

// class NavBarLarge extends StatelessWidget implements PreferredSizeWidget {
class NavBarLarge extends StatefulWidget {
  NavBarLarge({
    Key? key,
    required this.setActiveFeed,
    required this.activeFeed,
    this.leftHand = true,
    this.notification = true,
    this.theme = true,
    this.customFeed = true,
    this.profile = true,
    this.searchInitialValue = "",
  }) : super(key: globalKey);

  final int activeFeed;
  final Function(int i) setActiveFeed;

  final bool leftHand;
  final bool notification;
  final bool theme;
  final bool customFeed;
  final bool profile;

  final String searchInitialValue;

  //! Test GlobalKey for tap menu
  static final GlobalKey<_NavBarLargeState> globalKey = GlobalKey();

  @override
  State<NavBarLarge> createState() => _NavBarLargeState();
}

class _NavBarLargeState extends State<NavBarLarge> {
  Menu activeMenu = Menu.none;

  bool _isLeftHand = false;

  String baseURL = 'http://localhost:3000/';

  late String username;

  TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBarController.text = widget.searchInitialValue;
  }

  //Get Profile Data by Username
  Future<Map<String, dynamic>> fetchMyProfileData() async {
    var url = Uri.parse(baseURL + 'user/getMyProfile');
    String? token = await getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print("fetchprofile5");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        // setState(() {
        //   username = map['username'];
        // });
        username = map['username'];
        print(map);
        return map;
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  refresh() {
    setState(() {});
  }

  collapseMenus() {
    print("colapse menus ");
    setState(() {
      activeMenu = Menu.none;
    });
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
            padding: const EdgeInsets.fromLTRB(21, 10, 21, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: _isLeftHand
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      //Logo
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          print("taped");
                          // html.window.location.reload();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //       builder: (context) => const FeedScreen()),
                          // );
                          Beamer.of(context).beamToNamed('/feed');
                        },
                        child: Text(
                          // "LOGO",
                          "LIGMA",
                          style: TextStyle(
                              fontFamily: 'Segoe UI Black',
                              fontSize: 28,
                              color: Theme.of(context).colorScheme.brandColor),
                        ),
                      ),
                    ),
                    //SearchBar
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width <= 1600
                              ? MediaQuery.of(context).size.width <= 1350
                                  ? 500
                                  : 700
                              : 1000,
                          //height: 30,
                          child: TextFormField(
                            // initialValue: widget.searchInitialValue,
                            controller: _searchBarController,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Segoe UI',
                                letterSpacing: 0.3),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor,
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.searchBarColor,
                              //fillColor: Colors.yellow,
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .searchBarTextColor),
                              isDense: true,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 11, top: 11, left: 25, right: 10),
                              //SearchButton
                              suffixIcon: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (_searchBarController.text.isEmpty) {
                                      Beamer.of(context).beamToNamed('/feed');
                                    } else {
                                      Beamer.of(context).beamToNamed(
                                          '/search/${_searchBarController.text}');
                                    }
                                  },
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .brandColor)),
                                  ),
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                  maxHeight: 24,
                                  minWidth: 20,
                                  minHeight: 20,
                                  maxWidth: 24 + 10),
                            ),
                            onFieldSubmitted: (search) {
                              if (search.isEmpty) {
                                Beamer.of(context).beamToNamed('/feed');
                              } else {
                                Beamer.of(context)
                                    .beamToNamed('/search/$search');
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    //Icons and PB
                    Align(
                      alignment: _isLeftHand
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                            color: Theme.of(context).canvasColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FutureBuilder(
                                future: isAuthenticated(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data == 200) {
                                    //If User Is Logged in
                                    return FutureBuilder(
                                        future: fetchMyProfileData(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Row(
                                              textDirection: _isLeftHand
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                //LeftHand Switch
                                                // widget.leftHand
                                                //     ? LeftHandSwitcherIcon(
                                                //         isLeftHand: _isLeftHand,
                                                //         onPressed: () =>
                                                //             setState(() {
                                                //               _isLeftHand =
                                                //                   !_isLeftHand;
                                                //             }))
                                                //     : const SizedBox(),
                                                // const SizedBox(
                                                //   width: 18,
                                                // ),
                                                //Notifications
                                                widget.notification
                                                    ? FutureBuilder(
                                                        future:
                                                            getMyUnseenNotificationCount(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (activeMenu ==
                                                                        Menu.notification) {
                                                                      activeMenu =
                                                                          Menu.none;
                                                                    } else {
                                                                      activeMenu =
                                                                          Menu.notification;
                                                                    }
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      // Icons
                                                                      //     .notifications_none_outlined,
                                                                      // Icons
                                                                      //     .bus_alert,
                                                                      LightOutlineNotificationIcon
                                                                          .notification,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .navBarIconColor,
                                                                      size: 24,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(snapshot
                                                                        .data
                                                                        .toString())
                                                                  ],
                                                                ));
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        })
                                                    : const SizedBox(),
                                                const SizedBox(
                                                  width: 18,
                                                ),
                                                //Dark Light Mode Switch
                                                // widget.theme
                                                //     ? const DarkModeSwitcherIcon()
                                                //     : const SizedBox(),
                                                // const SizedBox(
                                                //   width: 18,
                                                // ),
                                                //CustomFeedSelection
                                                widget.customFeed
                                                    ? InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          setState(() {
                                                            if (activeMenu ==
                                                                Menu.customfeed) {
                                                              activeMenu =
                                                                  Menu.none;
                                                            } else {
                                                              activeMenu = Menu
                                                                  .customfeed;
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .filter_list_outlined,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .navBarIconColor,
                                                          size: 30,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                const SizedBox(
                                                  width: 18,
                                                ),
                                                //Options Menu
                                                widget.notification
                                                    ? InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          setState(() {
                                                            if (activeMenu ==
                                                                Menu.options) {
                                                              activeMenu =
                                                                  Menu.none;
                                                            } else {
                                                              activeMenu =
                                                                  Menu.options;
                                                            }
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .apps_outlined,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .navBarIconColor,
                                                              size: 26,
                                                            ),
                                                          ],
                                                        ))
                                                    : const SizedBox(),
                                                const SizedBox(width: 32),
                                                //ProfilePicture
                                                widget.profile
                                                    ? InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          setState(() {
                                                            if (activeMenu ==
                                                                Menu.menu) {
                                                              activeMenu =
                                                                  Menu.none;
                                                            } else {
                                                              activeMenu =
                                                                  Menu.menu;
                                                            }
                                                          });
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.0),
                                                          child: Image.network(
                                                            baseURL +
                                                                snapshot.data[
                                                                    'profilePicturePath'],
                                                            fit: BoxFit.contain,
                                                            width: 40,
                                                            height: 40,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            );
                                          } else {
                                            return const Text(
                                                "loading Profile Data...");
                                          }
                                        });
                                  } else {
                                    //If User Is NOT logged in
                                    return Row(
                                      textDirection: _isLeftHand
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //LeftHand Switch
                                        IconButton(
                                          icon: Icon(
                                            _isLeftHand
                                                ? Icons.switch_left
                                                : Icons.switch_right,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor,
                                            size: 24,
                                          ),
                                          onPressed: () => setState(() {
                                            _isLeftHand = !_isLeftHand;
                                          }),
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        //Dark Light Mode Switch
                                        widget.theme
                                            ? Consumer<ThemeNotifier>(
                                                builder: (context, theme, _) =>
                                                    InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    if (theme.getTheme() ==
                                                        theme.darkTheme) {
                                                      theme.setLightMode();
                                                    } else {
                                                      theme.setDarkMode();
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.dark_mode_outlined,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .navBarIconColor,
                                                    size: 24,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        // Consumer<ThemeNotifier>(
                                        //   builder: (context, theme, _) => Icon(
                                        //     Icons.dark_mode_outlined,
                                        //     color: Theme.of(context)
                                        //         .colorScheme
                                        //         .navBarIconColor,
                                        //     size: 24,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        //Login Button
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).canvasColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .brandColor),
                                          ),
                                          onPressed: () => Beamer.of(context)
                                              .beamToNamed('/login'),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .brandColor),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text("or"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        //SignUp Button
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).canvasColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .brandColor),
                                          ),
                                          onPressed: () => Beamer.of(context)
                                              .beamToNamed('/signup'),
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .brandColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: _isLeftHand ? Alignment.topLeft : Alignment.topRight,
          child: Padding(
            padding: _isLeftHand
                ? const EdgeInsets.only(left: 25)
                : const EdgeInsets.only(right: 25),
            child: getMenu(activeMenu),
          ),
        )
      ],
    );
  }

  Widget getMenu(Menu m) {
    switch (m) {
      case Menu.none:
        return const SizedBox();
      case Menu.menu:
        return NavBarMenu(username: username);
      case Menu.notification:
        return NotificationList(
          myUsername: username,
          notifyParent: refresh,
          isLeftHand: _isLeftHand,
        );
      case Menu.customfeed:
        return CustomFeedList(
          myUsername: username,
          isLeftHand: _isLeftHand,
          setActiveFeed: widget.setActiveFeed,
          activeFeed: widget.activeFeed,
        );
      case Menu.options:
        // return CustomFeedList(
        //   myUsername: username,
        //   isLeftHand: _isLeftHand,
        //   setActiveFeed: widget.setActiveFeed,
        //   activeFeed: widget.activeFeed,
        // );
        return OptionsGrid(
          lhIsLeftHand: _isLeftHand,
          lhOnPressed: () => setState(() {
            _isLeftHand = !_isLeftHand;
          }),
        );
    }
  }
}
