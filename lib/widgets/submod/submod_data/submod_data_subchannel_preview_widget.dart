import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/submod/submod_util_methods.dart';

class SubModSubchannelPreview extends StatelessWidget {
  const SubModSubchannelPreview({
    Key? key,
    required this.realPreviewMode,
    // required this.subchannelName,
    required this.banner,
    required this.subchannelPicture,
    required this.handeTap,
  }) : super(key: key);

  //PreviewMode
  final bool realPreviewMode;

  //Subchannel Data
  // final String subchannelName;
  final Uint8List? banner;
  final Uint8List? subchannelPicture;

  final Function(SubModData) handeTap;

  //Subchannel
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            //Subchannel Banner
            Stack(
              children: [
                realPreviewMode
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                        child: banner != null
                            ? Image.memory(
                                banner!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                // width: MediaQuery.of(context).size.width,
                                height: 230,
                                width: 1920,
                              )
                            : Image.network(
                                "https://picsum.photos/1920/230",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                // width: MediaQuery.of(context).size.width,
                                height: 230,
                                width: 1920,
                              ),
                      )
                    : ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        child: banner != null
                            ? Image.memory(
                                banner!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                // width: MediaQuery.of(context).size.width,
                                height: 230,
                                width: 720,
                              )
                            : Image.network(
                                "https://picsum.photos/820/230",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                // width: MediaQuery.of(context).size.width,
                                height: 230,
                                width: 820,
                              ),
                      ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Transform.translate(
                    offset: const Offset(0, 10),
                    child: InkWell(
                      onTap: () => handeTap(SubModData.banner),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple,
                        ),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 180,
                ),
                Stack(
                  children: [
                    Material(
                      color: Colors.transparent,
                      elevation: 8,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: subchannelPicture != null
                            ? Image.memory(
                                subchannelPicture!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: 87,
                                height: 87,
                              )
                            : Image.network(
                                "https://picsum.photos/120",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: 87,
                                height: 87,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Transform.translate(
                        offset: const Offset(10, 10),
                        child: InkWell(
                          onTap: () => handeTap(SubModData.picture),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple,
                            ),
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                //Man konn in nomen net ändern nico...
                // Container(
                //   width: 400,
                //   child: TextFormField(
                //     textAlign: TextAlign.center,
                //     // subchannelName,
                //     initialValue: "SubName",
                //     decoration:
                //         const InputDecoration(enabledBorder: InputBorder.none),
                //     style: TextStyle(
                //         fontFamily: 'Segoe UI',
                //         fontSize: 30,
                //         color: Theme.of(context).colorScheme.navBarIconColor),
                //   ),
                // ),
                Text(
                  "SubName",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.navBarIconColor),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Subchannelname
                    Text(
                      "1432 followers",
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.navBarIconColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //Dot in the middle
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.navBarIconColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //Views
                    Text(
                      "420 online",
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.navBarIconColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 35,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.brandColor),
                        ),
                        onPressed: () {},
                        child: Text(
                          'About',
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.brandColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                        width: 160,
                        height: 35,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.brandColor),
                          onPressed: () {},
                          child: Text(
                            'Follow',
                            style: TextStyle(
                                fontFamily: 'Segoe UI Black',
                                fontSize: 18,
                                color: Theme.of(context).canvasColor),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "SubName\nSubNameSubNameSubName\nSubName\nSubNameSubName\nSubNameSubNameSubNameubNameSubNameßnSubName\nSubNameSubName\nSubNameSubNameSubName\nSubName\nSubNameSubName\nSubNameSubNameSubName\n\nSubNameSubNameßnSubName\nSubNameSubName\nSubNameSubNameSubName\nSubName\nSubNameSubName\nSubNameSubNameSubName\n\nSubNameSubNameßnSubName\nSubNameSubName\nSubNameSubNameSubName\nSubName\nSubNameSubName\nSubNameSubNameSubName\n\nSubNameSubNameßnSubName\nSubName",
                  style: const TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18,
                      color: Colors.white60),
                  maxLines: realPreviewMode ? null : 5,
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(
                  height: 17,
                ),
                // const SizedBox(
                //   height: 40,
                // ),
                // SubchannelVideosGridLargeScreen(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
