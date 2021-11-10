import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/widgets/submod/submod_posts/submod_post_buttons_widget.dart';

class SubModPostListItem extends StatefulWidget {
  const SubModPostListItem({Key? key}) : super(key: key);

  @override
  _SubModPostListItemState createState() => _SubModPostListItemState();
}

class _SubModPostListItemState extends State<SubModPostListItem> {
  bool _onHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
      // onTap: () =>
      //     widget.handleUsername(userNames.elementAt(index).elementAt(0)),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: Image.network(
                    // baseURL + userNames.elementAt(index).elementAt(1),
                    "https://picsum.photos/1280/720",
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    // width: 40,
                    // height: 40,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    // userNames.elementAt(index).first,
                    "Title jojojsjas",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tags",
                    style: TextStyle(fontSize: 16, color: Colors.white60),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // userNames.elementAt(index).first,
                    "Title jojojsjas",
                    style: TextStyle(fontSize: 13, color: Colors.white38),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    // userNames.elementAt(index).first,
                    "Reports: ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // userNames.elementAt(index).first,
                    "Rating: ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // userNames.elementAt(index).first,
                    "Views: ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // userNames.elementAt(index).first,
                    "UploadDateTime: ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  // SizedBox(height: 8),
                ],
              ),
            ),
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: _onHover
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Delete
                        SubModPostButton(
                          color: Theme.of(context).colorScheme.brandColor,
                          iconData: Icons.delete,
                          toolTipMsg: "This is a tooltip",
                          handeleTap: () {},
                        ),
                        const SizedBox(height: 5),
                        SubModPostButton(
                          color: Colors.white70,
                          iconData: Icons.list,
                          toolTipMsg: "This is a tooltip",
                          handeleTap: () {},
                        ),
                        const SizedBox(height: 5),
                        SubModPostButton(
                          color: Colors.blue,
                          iconData: Icons.flag,
                          toolTipMsg: "This is a tooltip",
                          handeleTap: () {},
                        ),
                        const SizedBox(height: 5),
                        SubModPostButton(
                          color: Colors.orange,
                          iconData: Icons.chat_bubble,
                          toolTipMsg: "This is a tooltip",
                          handeleTap: () {},
                        ),
                        const SizedBox(height: 5),
                        SubModPostButton(
                          color: Colors.green,
                          iconData: Icons.check,
                          toolTipMsg: "This is a tooltip",
                          handeleTap: () {},
                        ),
                      ],
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
