import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class CreateProfilePreviewLargeScreen extends StatelessWidget {
  const CreateProfilePreviewLargeScreen(
      {Key? key,
      required this.bio,
      required this.profilePicture,
      required this.username})
      : super(key: key);

  final String bio;
  final Uint8List? profilePicture;
  final String username;

  //Profile
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Profile Picture
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(37)),
          child: profilePicture != null
              ? Image.memory(
                  profilePicture!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: 500,
                  height: 500,
                )
              : Image.network(
                  'http://localhost:3000/uploads/default/defaultProfilePicture.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: 500,
                  height: 500,
                ),
        ),
        const SizedBox(
          height: 37,
        ),
        //Profile Data
        SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Username
                    Text(
                      "Username",
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 26,
                          color: Theme.of(context).colorScheme.brandColor),
                    ),
                    //Follow Button
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
                const SizedBox(height: 13),
                //Userpoints
                Text(
                  'XXX.XXX' + ' points',
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.brandColor),
                ),
                const SizedBox(height: 34),
                //User Bio
                Text(
                  bio,
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.userBioColor),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
