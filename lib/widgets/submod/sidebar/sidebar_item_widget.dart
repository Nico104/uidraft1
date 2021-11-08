import 'package:flutter/material.dart';

class SideBarItem extends StatefulWidget {
  const SideBarItem({Key? key, required this.isExpanded, required this.fun})
      : super(key: key);

  final bool isExpanded;
  final Function() fun;

  @override
  _SideBarItemState createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem>
    with SingleTickerProviderStateMixin {
  double _elevation = 0;
  bool _onHover = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => setState(() {
      //   widget.isExpanded = !widget.isExpanded;
      // }),
      onTap: () => widget.fun.call(),
      onHover: (val) {
        print(val);
        if (val) {
          setState(() {
            _onHover = true;
            _animationController.forward();
          });
        } else {
          setState(() {
            _onHover = false;
            _animationController.reverse();
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
                  // Icon(Icons.menu, size: _onHover ? 48 : 36),
                  AnimatedIcon(
                    // size: _onHover ? 48 : 36,
                    color: Colors.blue,
                    icon: AnimatedIcons.close_menu,
                    progress: _animationController,
                  ),
                  widget.isExpanded
                      ? const SizedBox(width: 8)
                      : const SizedBox(),
                  Flexible(
                    child: AnimatedOpacity(
                        curve: Curves.fastOutSlowIn,
                        opacity: widget.isExpanded ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: widget.isExpanded
                            ? const Text("Menu")
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
