import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/auth/authentication_global.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class NavBarLargeStudio extends StatelessWidget implements PreferredSizeWidget {
class NavBarLargeStudio extends StatefulWidget {
  const NavBarLargeStudio({Key? key}) : super(key: key);
  @override
  State<NavBarLargeStudio> createState() => _NavBarLargeStudioState();
}

class _NavBarLargeStudioState extends State<NavBarLargeStudio> {
  bool _showMenu = false;

  String baseURL = 'http://localhost:3000/';

  //Get Studio Data by Username
  Future<Map<String, dynamic>> fetchMyProfileData() async {
    var url = Uri.parse('http://localhost:3000/user/getMyProfile');
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
        return map;
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 10, 21, 10),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.center,
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            //Logo
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Beamer.of(context).beamToNamed('/feed');
                print("taped");
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
          //MenuButtons
          const Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(top: 4), child: Text("Edit my Posts")),
          ),
          //Icons and PB
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: FutureBuilder(
                    future: isAuthenticated(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == 200) {
                        //If User Is Logged in
                        return FutureBuilder(
                            future: fetchMyProfileData(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Back to HomeScreen
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Beamer.of(context).beamToNamed('/feed');
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .navBarIconColor,
                                            size: 24,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text("Back to Home"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    //Dark Light Mode Switch
                                    Icon(
                                      Icons.dark_mode_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .navBarIconColor,
                                      size: 24,
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                    //ProfilePicture
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      // onTap: () {
                                      //   setState(() {
                                      //     _showMenu = !_showMenu;
                                      //   });
                                      // },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        child: Image.network(
                                          baseURL +
                                              snapshot
                                                  .data['profilePicturePath'],
                                          fit: BoxFit.contain,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Text("loading Profile Data...");
                              }
                            });
                      } else {
                        //If User Is NOT logged in
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Dark Light Mode Switch
                            Icon(
                              Icons.dark_mode_outlined,
                              color:
                                  Theme.of(context).colorScheme.navBarIconColor,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            //Login Button
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                              onPressed: () =>
                                  Beamer.of(context).beamToNamed('/login'),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .brandColor),
                              ),
                              onPressed: () =>
                                  Beamer.of(context).beamToNamed('/signup'),
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
              ))
        ],
      ),
    );
  }
}
