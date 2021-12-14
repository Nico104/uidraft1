import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/widgets/submod/submod_posts/submod_post_list_item_widget.dart';

class SubModPostTab extends StatefulWidget {
  const SubModPostTab({Key? key, required this.subchannelName})
      : super(key: key);

  final String subchannelName;

  @override
  _SubModPostTabState createState() => _SubModPostTabState();
}

class _SubModPostTabState extends State<SubModPostTab> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode fnSearch = FocusNode();
  bool _isCollapsed = true;

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Consumer<ConnectionService>(builder: (context, connection, _) {
        return Stack(
          children: [
            FutureBuilder(
                future: fetchReportedPostIds(widget.subchannelName,
                    _searchTextController.text, connection.returnConnection()),
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
                child: _isCollapsed
                    ? InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        excludeFromSemantics: true,
                        onTap: () {
                          setState(() {
                            _isCollapsed = false;
                          });
                          fnSearch.requestFocus();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.purple),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.search,
                              size: 27,
                            ),
                          ),
                        ))
                    : SizedBox(
                        width: 180,
                        height: 40,
                        child: TextFormField(
                          // autofocus: true,
                          focusNode: fnSearch,
                          controller: _searchTextController,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Segoe UI',
                              letterSpacing: 0.3),
                          cursorColor: Theme.of(context)
                              .colorScheme
                              .textInputCursorColor,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.brandColor,
                                  width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.brandColor,
                                  width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
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
                            errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                            errorStyle: const TextStyle(
                                fontSize: 14.0, fontFamily: 'Segoe UI'),
                            //Visibility Icon
                            suffixIcon: IconButton(
                              hoverColor: Colors.transparent,
                              onPressed: () => setState(() {
                                _isCollapsed = true;
                              }),
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
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
                      ))
          ],
        );
      }),
    );
  }
}
