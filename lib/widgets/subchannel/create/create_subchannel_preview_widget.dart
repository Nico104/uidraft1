import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

class CreateSubchannelPreviewLargeScreen extends StatelessWidget {
  const CreateSubchannelPreviewLargeScreen({
    Key? key,
    required this.realPreviewMode,
    required this.subchannelName,
    required this.banner,
    required this.subchannelPicture,
  }) : super(key: key);

  //PreviewMode
  final bool realPreviewMode;

  //Subchannel Data
  final String subchannelName;
  final Uint8List? banner;
  final Uint8List? subchannelPicture;

  //Subchannel
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            //Subchannel Banner
            realPreviewMode
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    child: banner != null
                        ? Image.memory(
                            banner!,
                            fit: BoxFit.cover, alignment: Alignment.center,
                            // width: MediaQuery.of(context).size.width,
                            height: 230,
                            width: 1920,
                          )
                        : Image.network(
                            baseURL +
                                "uploads/default/defaultSubchannelBanner.jpg",
                            fit: BoxFit.cover, alignment: Alignment.center,
                            // width: MediaQuery.of(context).size.width,
                            height: 230,
                            width: 1920,
                          ),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: banner != null
                        ? Image.memory(
                            banner!,
                            fit: BoxFit.cover, alignment: Alignment.center,
                            // width: MediaQuery.of(context).size.width,
                            height: 230,
                            width: 720,
                          )
                        : Image.network(
                            baseURL +
                                "uploads/default/defaultSubchannelBanner.jpg",
                            fit: BoxFit.cover, alignment: Alignment.center,
                            // width: MediaQuery.of(context).size.width,
                            height: 230,
                            width: 720,
                          ),
                  ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 180,
                ),
                Material(
                  color: Colors.transparent,
                  elevation: 8,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    child: subchannelPicture != null
                        ? Image.memory(
                            subchannelPicture!,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            width: 87,
                            height: 87,
                          )
                        : Image.network(
                            baseURL +
                                "uploads/default/defaultSubchannelPicture.jpg",
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            width: 87,
                            height: 87,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  subchannelName,
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
