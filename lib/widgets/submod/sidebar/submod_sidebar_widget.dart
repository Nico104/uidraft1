import 'package:flutter/material.dart';
import 'package:uidraft1/widgets/submod/sidebar/sidebar_item_widget.dart';

class SubModSideBar extends StatefulWidget {
  const SubModSideBar({Key? key}) : super(key: key);

  @override
  _SubModSideBarState createState() => _SubModSideBarState();
}

class _SubModSideBarState extends State<SubModSideBar> {
  // final double _width = 100;
  double _elevation = 0;
  // double _opacity = 0;

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
          // clipBehavior: Clip.antiAlias,
          width: _isExpanded ? 200 : 100,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(_isExpanded ? 34 : 0),
          //       bottomRight: Radius.circular(_isExpanded ? 34 : 0)),
          // color: Colors.white54,
          // ),
          height: double.infinity,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SideBarItem(isExpanded: _isExpanded, fun: () => print("fun")),
            ],
          ),
        ),
      ),
    );
  }

  void expand() {}
  void collapse() {}
}
