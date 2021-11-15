import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class OptionsGrid extends StatefulWidget {
  const OptionsGrid({Key? key}) : super(key: key);

  @override
  _OptionsGridState createState() => _OptionsGridState();
}

class _OptionsGridState extends State<OptionsGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          color: Theme.of(context).colorScheme.searchBarColor,
        ),
        child: GridView.count(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: const <Widget>[
            Icon(
              Icons.dark_mode,
              size: 32,
            ),
            Icon(
              Icons.dark_mode,
              size: 32,
            ),
            Icon(
              Icons.dark_mode,
              size: 32,
            ),
            Icon(
              Icons.dark_mode,
              size: 32,
            ),
          ],
        ));
  }
}
