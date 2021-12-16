import 'package:flutter/material.dart';
import 'package:uidraft1/uiwidgets/navicons/dark_mode_switcher_icon.dart';
import 'package:uidraft1/uiwidgets/navicons/left_hand_switcher_icon.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/navbar/options/uploadprogress/upload_progress_list.dart';

class OptionsGrid extends StatefulWidget {
  const OptionsGrid(
      {Key? key, required this.lhIsLeftHand, required this.lhOnPressed})
      : super(key: key);

  final bool lhIsLeftHand;
  final Function() lhOnPressed;

  @override
  _OptionsGridState createState() => _OptionsGridState();
}

enum ShowOption { grid, uploads }

class _OptionsGridState extends State<OptionsGrid> {
  ShowOption _activeOption = ShowOption.grid;
  double _witdh = 150;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        width: _witdh,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          color: Theme.of(context).colorScheme.searchBarColor,
        ),
        child: getOption());
  }

  void setActiveOption(ShowOption newOpt) {
    if (mounted) {
      switch (newOpt) {
        case ShowOption.grid:
          setState(() {
            _activeOption = ShowOption.grid;
            _witdh = 150;
          });
          break;
        case ShowOption.uploads:
          setState(() {
            _activeOption = ShowOption.uploads;
            _witdh = 250;
          });
          break;
      }
    }
  }

  Widget getOption() {
    switch (_activeOption) {
      case ShowOption.grid:
        return GridView.count(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            //Left Hand Switcher
            LeftHandSwitcherIcon(
                isLeftHand: widget.lhIsLeftHand,
                onPressed: () => widget.lhOnPressed.call(),
                iconSize: 32),
            //Dark Mode Switcher
            const DarkModeSwitcherIcon(iconSize: 32),
            InkWell(
              onTap: () => setActiveOption(ShowOption.uploads),
              child: const Icon(
                Icons.upload_outlined,
                size: 32,
              ),
            ),
            const Icon(
              Icons.dark_mode,
              size: 32,
            ),
          ],
        );
      case ShowOption.uploads:
        return const UploadProgressList();
    }
  }
}
