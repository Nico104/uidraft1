import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

///Returns the Users Profile Picture with rounded Corners
///takes [commentUsername] as the Username to beam to
///takes [profilePicturePath] as the path where the Profile Picture is stored
class CommentProfilePicture extends StatelessWidget {
  const CommentProfilePicture({
    Key? key,
    required this.commentUsername,
    required this.profilePicturePath,
  }) : super(key: key);

  final String commentUsername;
  final String profilePicturePath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // excludeFromSemantics: true,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Beamer.of(context).beamToNamed('profile/' + commentUsername);
        print("go to profile");
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: Image.network(
          // baseURL
          spacesEndpoint + profilePicturePath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
