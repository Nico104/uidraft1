import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/submod/sidebar/sidebar_item_widget.dart';

class SubModSideBar extends StatefulWidget {
  const SubModSideBar({Key? key, required this.setIndex}) : super(key: key);

  final Function(int) setIndex;

  @override
  _SubModSideBarState createState() => _SubModSideBarState();
}

class _SubModSideBarState extends State<SubModSideBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        _isExpanded = !_isExpanded;
      }),
      onHover: (val) {
        print(val);
        if (val) {
          setState(() {
            _isExpanded = true;
            // _opacity = 1;
          });
        } else {
          setState(() {
            _isExpanded = false;
            // _opacity = 0;
          });
        }
      },
      child: Material(
        elevation: 8,
        child: AnimatedContainer(
          width: _isExpanded ? 200 : 100,
          height: double.infinity,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Logo-Header
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: InkWell(
                      onTap: () => Beamer.of(context).beamToNamed('/feed'),
                      child: Text(
                        "LOGO",
                        style: TextStyle(
                            fontFamily: 'Segoe UI Black',
                            // fontSize: 28,
                            color: Theme.of(context).colorScheme.brandColor),
                      ),
                    ),
                  ),
                ),
              ),
              //MenuItems
              Column(
                children: [
                  SideBarItem(
                    isExpanded: _isExpanded,
                    label: 'Data',
                    icon: Icons.build,
                    index: 0,
                    setIndex: widget.setIndex,
                  ),
                  const SizedBox(height: 18),
                  SideBarItem(
                    isExpanded: _isExpanded,
                    label: 'Users',
                    icon: Icons.people,
                    index: 1,
                    setIndex: widget.setIndex,
                  ),
                  const SizedBox(height: 18),
                  SideBarItem(
                    isExpanded: _isExpanded,
                    label: 'Posts',
                    icon: Icons.missed_video_call,
                    index: 2,
                    setIndex: widget.setIndex,
                  ),
                  const SizedBox(height: 18),
                  SideBarItem(
                    isExpanded: _isExpanded,
                    label: 'News',
                    icon: Icons.edit_notifications,
                    index: 3,
                    setIndex: widget.setIndex,
                  ),
                ],
              ),
              //Exit
              Column(
                children: [
                  SideBarItem(
                    isExpanded: _isExpanded,
                    label: 'Data',
                    icon: Icons.exit_to_app,
                    setIndex: (int) {
                      print("exit");
                    },
                    index: 3,
                  ),
                  const SizedBox(height: 18)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
