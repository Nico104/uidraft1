import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 10, 21, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "LOGO",
                  style: TextStyle(
                      fontFamily: 'Segoe UI Black',
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.brandColor),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SizedBox(
                    width: 1000,
                    //height: 30,
                    child: TextFormField(
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
                                color: Theme.of(context).colorScheme.brandColor,
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
                              bottom: 11, top: 11, left: 15, right: 10)),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 26,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Icon(
                          Icons.filter_list_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),
                          child: Image.network(
                            "https://picsum.photos/700",
                            fit: BoxFit.contain,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Text(
    //       "LOGO",
    //       style: getLogoTextStyle(Theme.of(context).colorScheme.brandColor),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: MaterialButton(
    //         onPressed: () => Navigator.of(context).pushNamed('/welcome'),
    //         color: Colors.blue,
    //         child: const Text("Welcome"),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: MaterialButton(
    //         onPressed: () => Navigator.of(context).pushNamed('/signup'),
    //         color: Colors.blue,
    //         child: const Text("SignUp"),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: MaterialButton(
    //         onPressed: () => Navigator.of(context).pushNamed('/login'),
    //         color: Colors.blue,
    //         child: const Text("Login"),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: MaterialButton(
    //         onPressed: () => Navigator.of(context).pushNamed('/uploadvideo'),
    //         color: Colors.blue,
    //         child: const Text("Upload"),
    //       ),
    //     )
    //   ],
    // );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(300);
}
