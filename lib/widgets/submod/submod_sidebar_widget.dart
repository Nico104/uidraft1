import 'package:flutter/material.dart';

class SubModSideBar extends StatefulWidget {
  const SubModSideBar({Key? key}) : super(key: key);

  @override
  _SubModSideBarState createState() => _SubModSideBarState();
}

class _SubModSideBarState extends State<SubModSideBar> {
  // final double _width = 100;
  double _elevation = 0;

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
          });
        } else {
          setState(() {
            _isExpanded = false;
          });
        }
      },
      child: AnimatedContainer(
        clipBehavior: Clip.antiAlias,
        width: _isExpanded ? 300 : 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(_isExpanded ? 34 : 0),
              bottomRight: Radius.circular(_isExpanded ? 34 : 0)),
          color: Colors.white54,
        ),
        height: double.infinity,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() {
                _isExpanded = !_isExpanded;
              }),
              onHover: (val) {
                print(val);
                if (val) {
                  setState(() {
                    _elevation = 18;
                  });
                } else {
                  setState(() {
                    _elevation = 0;
                  });
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: AnimatedPhysicalModel(
                  clipBehavior: Clip.hardEdge,
                  duration: const Duration(milliseconds: 210),
                  curve: Curves.fastOutSlowIn,
                  elevation: _elevation,
                  shape: BoxShape.rectangle,
                  shadowColor: Colors.black,
                  color: Colors.green,
                  // borderRadius: _first
                  //     ? const BorderRadius.all(Radius.circular(0))
                  //     : const BorderRadius.all(Radius.circular(10)),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 110),
                    // curve: Curves.fastOutSlowIn,
                    alignment:
                        _isExpanded ? Alignment.centerLeft : Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isExpanded
                            ? const SizedBox(width: 18)
                            : const SizedBox(),
                        const Icon(Icons.menu, size: 36),
                        _isExpanded
                            ? const SizedBox(width: 8)
                            : const SizedBox(),
                        _isExpanded ? const Text("Menu") : const SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void expand() {}
  void collapse() {}
}
