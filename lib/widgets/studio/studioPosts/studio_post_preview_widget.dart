import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/studio/studio_util_methods.dart';

class StudioVideoPreview extends StatefulWidget {
  final int postId;

  const StudioVideoPreview({Key? key, required this.postId}) : super(key: key);

  @override
  State<StudioVideoPreview> createState() => _StudioVideoPreviewState();
}

class _StudioVideoPreviewState extends State<StudioVideoPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPostStudioPreviewData(widget.postId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                //Thumbnail
                ClipRRect(
                  // borderRadius: BorderRadius.circular(12.0),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    baseURL + "${snapshot.data!['postTumbnailPath']}",
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                //Data Preview
                LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: //Title
                          Container(
                        width: 320,
                        child: Text(
                          snapshot.data!['postTitle'],
                          //overflow: TextOverflow.fade,
                          //softWrap: false,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 17,
                              color: Theme.of(context)
                                  .colorScheme
                                  .videoPreviewTextColor,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                  );
                })
              ],
            );
          } else {
            return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Theme.of(context).canvasColor,
                child: const Text("loading"));
          }
        });
  }
}
