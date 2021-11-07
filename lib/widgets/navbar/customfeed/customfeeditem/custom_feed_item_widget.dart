import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class CustomFeedItem extends StatelessWidget {
  const CustomFeedItem(
      {Key? key,
      required this.customfeedName,
      required this.edit,
      this.isDefault = false})
      : super(key: key);

  final String customfeedName;
  final Function() edit;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://picsum.photos/40",
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  customfeedName,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        Flexible(
            flex: 2,
            child: !isDefault
                ? IconButton(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(Icons.edit),
                    onPressed: () => edit.call(),
                  )
                : const SizedBox()),
      ],
    );
    // return Text(customfeedName);
  }
}
