import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class NavBarLarge extends StatelessWidget implements PreferredSizeWidget {
  const NavBarLarge({Key? key}) : super(key: key);

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
                //Logo
                child: Text(
                  "LOGO",
                  style: TextStyle(
                      fontFamily: 'Segoe UI Black',
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.brandColor),
                ),
              ),
              //SearchBar
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width <= 1500 ? 700 : 1000,
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
                        fillColor: Theme.of(context).colorScheme.searchBarColor,
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
                            bottom: 11, top: 11, left: 15, right: 10),
                        //SearchButton
                        suffixIcon: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              print("search Button clicked");
                            },
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
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
                    ),
                  ),
                ),
              ),
              //Icons and PB
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Notifications
                        Icon(
                          Icons.notifications_none_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 26,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        //Dark Light Mode Switch
                        Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        //FeedSelection
                        Icon(
                          Icons.filter_list_outlined,
                          color: Theme.of(context).colorScheme.navBarIconColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        //ProfilePicture
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
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(300);
}
