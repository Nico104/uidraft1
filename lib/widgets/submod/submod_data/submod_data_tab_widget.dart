import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/utils/widgets/toggle/toggle_animated_button_widget.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_data_subchannel_preview_widget.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_update_data/submod_data_update_about.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_update_data/submod_data_update_banner.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_update_data/submod_data_update_picture.dart';

class SubModDataTab extends StatefulWidget {
  const SubModDataTab({Key? key}) : super(key: key);

  @override
  _SubModDataTabState createState() => _SubModDataTabState();
}

class _SubModDataTabState extends State<SubModDataTab> {
  SubModData _showData = SubModData.none;
  bool realPreviewMode = false;

  void changeShowData(SubModData data) {
    setState(() {
      _showData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (mounted) {
          setState(() {
            _showData = SubModData.none;
          });
        }
        print(_showData);
      },
      child: Row(
        children: [
          Flexible(flex: 1, child: Container()),
          //Preview
          Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  SizedBox(
                    width: 220,
                    height: 120,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AnimatedToggle(
                        firstInitialPosition: true,
                        values: const ['Fit', 'Real'],
                        onToggleCallback: (value) {
                          setState(() {
                            print("value");
                            realPreviewMode = !realPreviewMode;
                          });
                        },
                        buttonColor: Theme.of(context).colorScheme.brandColor,
                        backgroundColor:
                            Theme.of(context).colorScheme.searchBarColor,
                        textColor: Theme.of(context).colorScheme.highlightColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: realPreviewMode ? 40 : 80,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(minWidth: double.infinity),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SubModSubchannelPreview(
                                banner: null,
                                subchannelPicture: null,
                                realPreviewMode: realPreviewMode,
                                handeTap: changeShowData,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Flexible(flex: 1, child: Container()),
          AnimatedContainer(
            // alignment: Alignment.centerRight,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink,
                Colors.blue,
              ],
            )),
            width: (_showData != SubModData.none) ? 400 : 0,
            // height: 800,
            // child: _activeUsername != null
            //     ? SubModMemberDetails(
            //         username: _activeUsername!,
            //       )
            //     : const SizedBox(),
            // child: (_showData != SubModData.none)
            //     ? getCorrectDataUpdatePage(_showData)
            //     : const SizedBox(),
            child: (_showData != SubModData.none)
                ? const SubModUpdatePicture()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

Widget getCorrectDataUpdatePage(SubModData data) {
  print("now: " + data.toString());
  switch (data) {
    case SubModData.picture:
      return const SubModUpdatePicture();
    case SubModData.banner:
      return const SubModUpdateBanner();
    case SubModData.about:
      return const SubModUpdateAbout();
    default:
      return const SizedBox();
  }
}
