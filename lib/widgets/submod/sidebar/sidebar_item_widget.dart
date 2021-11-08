import 'package:flutter/material.dart';

class SideBarItem extends StatefulWidget {
  const SideBarItem(
      {Key? key,
      required this.isExpanded,
      required this.label,
      required this.icon,
      required this.setIndex,
      required this.index})
      : super(key: key);

  final bool isExpanded;
  final String label;
  final IconData icon;
  final Function(int) setIndex;
  final int index;

  @override
  _SideBarItemState createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem>
    with SingleTickerProviderStateMixin {
  double _elevation = 0;
  bool _onHover = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // onTap: () => setState(() {
      //   widget.isExpanded = !widget.isExpanded;
      // }),
      onTap: () {
        widget.setIndex(widget.index);
      },
      onHover: (val) {
        print(val);
        if (val) {
          setState(() {
            _onHover = true;
          });
        } else {
          setState(() {
            _onHover = false;
          });
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.fastOutSlowIn,
          alignment:
              widget.isExpanded ? Alignment.centerLeft : Alignment.center,
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 250),
            height: _onHover ? 40 : 30,
            child: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isExpanded
                      ? const SizedBox(width: 18)
                      : const SizedBox(),
                  Icon(widget.icon),
                  // AnimatedIcon(
                  //   // size: _onHover ? 48 : 36,
                  //   color: Colors.blue,
                  //   icon: widget.animIcon,
                  //   progress: _animationController,
                  // ),
                  widget.isExpanded
                      ? const SizedBox(width: 8)
                      : const SizedBox(),
                  Flexible(
                    child: AnimatedOpacity(
                        curve: Curves.fastOutSlowIn,
                        opacity: widget.isExpanded ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: widget.isExpanded
                            ? Text(widget.label)
                            : const SizedBox()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
