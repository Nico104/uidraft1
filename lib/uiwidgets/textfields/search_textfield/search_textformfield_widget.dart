import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class SearchBarTextFormField extends StatelessWidget {
  const SearchBarTextFormField({
    Key? key,
    required this.searchBarController,
    this.onChange,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController searchBarController;
  final Function(String)? onChange;

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: searchBarController,
      style: const TextStyle(
          fontSize: 16, fontFamily: 'Segoe UI', letterSpacing: 0.3),
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
              color: Theme.of(context).colorScheme.brandColor, width: 0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.searchBarColor,
        //fillColor: Colors.yellow,
        hintText: 'Search...',
        hintStyle: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 16,
            color: Theme.of(context).colorScheme.searchBarTextColor),
        isDense: true,
        contentPadding:
            const EdgeInsets.only(bottom: 11, top: 11, left: 25, right: 10),
        //SearchButton
        suffixIcon: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (searchBarController.text.isEmpty) {
                Beamer.of(context).beamToNamed('/feed');
              } else {
                Beamer.of(context)
                    .beamToNamed('/search/${searchBarController.text}');
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.brandColor)),
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
            maxHeight: 24, minWidth: 20, minHeight: 20, maxWidth: 24 + 10),
      ),
      onFieldSubmitted: (search) {
        if (search.isEmpty) {
          Beamer.of(context).beamToNamed('/feed');
        } else {
          Beamer.of(context).beamToNamed('/search/$search');
        }
      },
      onChanged: onChange != null ? (search) => onChange!.call(search) : (_) {},
    );
  }
}
