import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/widgets/submod/submod_posts/submod_post_list_item_widget.dart';

class SubModPostTab extends StatefulWidget {
  const SubModPostTab({Key? key}) : super(key: key);

  @override
  _SubModPostTabState createState() => _SubModPostTabState();
}

class _SubModPostTabState extends State<SubModPostTab> {
  TextEditingController _searchTextController = TextEditingController();

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          FutureBuilder(
              future: fetchReportedPostIds('isgut', _searchTextController.text),
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SubModPostListItem(
                            postId: snapshot.data!.elementAt(index),
                            notifyParent: () => refresh());
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Column(
                          children: const [
                            // SizedBox(
                            //   height: 8,
                            // ),
                            Divider(
                              color: Colors.white60,
                            ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("no reported posts"));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          Positioned(
              right: 20,
              top: 20,
              child: SizedBox(
                // color: Colors.purple.withOpacity(0.9),
                width: 180,
                height: 40,
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      // autofocus: true,
                      controller: _searchTextController,
                      style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Segoe UI',
                          letterSpacing: 0.3),
                      cursorColor:
                          Theme.of(context).colorScheme.textInputCursorColor,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.brandColor,
                              width: 1),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.brandColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor,
                        labelText: 'Search',
                        labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 15,
                            color: Theme.of(context)
                                .colorScheme
                                .searchBarTextColor),
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                            bottom: 15, top: 15, left: 15, right: 10),
                        //Error
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorStyle: const TextStyle(
                            fontSize: 14.0, fontFamily: 'Segoe UI'),
                        // errorText: errorText,
                      ),
                      validator: (value) {
                        //check if username exists
                        if (value == null || value.isEmpty) {
                          return 'You may enter your username, sir';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                      // onFieldSubmitted: (_) => submit(),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
