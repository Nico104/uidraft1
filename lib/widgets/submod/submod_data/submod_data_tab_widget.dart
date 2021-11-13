import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';
import 'package:uidraft1/utils/widgets/toggle/toggle_animated_button_widget.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_data_subchannel_preview_widget.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_update_data/dialogs/submod_data_update_about_dialog.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_update_data/dialogs/submod_data_update_banner_dialog.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_update_data/dialogs/submod_data_update_picture_dialog.dart';

class SubModDataTab extends StatefulWidget {
  const SubModDataTab({Key? key}) : super(key: key);

  @override
  _SubModDataTabState createState() => _SubModDataTabState();
}

class _SubModDataTabState extends State<SubModDataTab> {
  SubModData _showData = SubModData.none;
  bool realPreviewMode = false;

  double _left = 0;
  double _right = 0;
  double _top = 0;
  double _bottom = 0;

  void changeShowData(SubModData data) {
    setState(() {
      _showData = data;
    });
    setPaddingvalues();
    showRightDialog();
  }

  void setPaddingvalues() {
    switch (_showData) {
      case SubModData.picture:
        setState(() {
          _left = 0;
          _right = 200;
          _top = 0;
          _bottom = 0;
        });
        break;
      case SubModData.banner:
        setState(() {
          _left = 0;
          _right = 500;
          _top = 150;
          _bottom = 0;
        });
        break;
      case SubModData.about:
        setState(() {
          _left = 600;
          _right = 0;
          _top = 100;
          _bottom = 0;
        });
        break;
      default:
        setState(() {
          _left = 0;
          _right = 0;
          _top = 0;
          _bottom = 0;
        });
        break;
    }
  }

  void showRightDialog() {
    switch (_showData) {
      case SubModData.picture:
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return const SubModUpdatePictureDialog();
          },
        ).then((value) {
          setState(() {
            _showData = SubModData.none;
          });
          setPaddingvalues();
        });
        break;
      case SubModData.banner:
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return const SubModUpdateBannerDialog();
          },
        ).then((value) {
          setState(() {
            _showData = SubModData.none;
          });
          setPaddingvalues();
        });
        break;
      case SubModData.about:
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return const SubModUpdateAboutDialog();
          },
        ).then((value) {
          setState(() {
            _showData = SubModData.none;
          });
          setPaddingvalues();
        });
        break;
      default:
        print("defaultDialog");
        break;
    }
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
              child: AnimatedPadding(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.fromLTRB(_left, _top, _right, _bottom),
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
                          textColor:
                              Theme.of(context).colorScheme.highlightColor,
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
                              constraints: const BoxConstraints(
                                  minWidth: double.infinity),
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
                ),
              )),
          Flexible(flex: 1, child: Container()),
          // AnimatedContainer(
          //   // alignment: Alignment.centerRight,
          //   duration: const Duration(milliseconds: 200),
          //   curve: Curves.fastOutSlowIn,
          //   decoration: const BoxDecoration(
          //       //   gradient: LinearGradient(
          //       // begin: Alignment.topLeft,
          //       // end: Alignment.bottomRight,
          //       // colors: [
          //       //   Colors.pink,
          //       //   Colors.blue,
          //       // ],
          //       color: Colors.transparent),
          //   width: (_showData != SubModData.none) ? 400 : 0,
          //   // height: 800,
          //   // child: _activeUsername != null
          //   //     ? SubModMemberDetails(
          //   //         username: _activeUsername!,
          //   //       )
          //   //     : const SizedBox(),
          //   // child: (_showData != SubModData.none)
          //   //     ? getCorrectDataUpdatePage(_showData)
          //   //     : const SizedBox(),
          //   // child: (_showData != SubModData.none)
          //   //     ? const SubModUpdatePicture()
          //   //     : const SizedBox(),
          // ),
        ],
      ),
    );
  }
}

// Widget getCorrectDataUpdatePage(SubModData data) {
//   print("now: " + data.toString());
//   switch (data) {
//     case SubModData.picture:
//       return const SubModUpdatePicture();
//     case SubModData.banner:
//       return const SubModUpdateBanner();
//     case SubModData.about:
//       return const SubModUpdateAbout();
//     default:
//       return const SizedBox();
//   }
// }
