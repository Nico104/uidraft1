import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

import 'profile_user_videos_grid_large_widget.dart';

class ProfileLargeScreen extends StatelessWidget {
  const ProfileLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(alignment: Alignment.topCenter, child: Profile());
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Profil
  bool _isFollowing = false;

  //Profile
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile Information
            Column(
              children: [
                //Profile Picture
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(37),
                      bottomRight: Radius.circular(37)),
                  child: Image.network(
                    "https://picsum.photos/700",
                    fit: BoxFit.contain,
                    width: 600,
                    height: 600,
                  ),
                ),
                const SizedBox(
                  height: 37,
                ),
                //Profile Data
                SizedBox(
                  width: 600,
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
                                  color:
                                      Theme.of(context).colorScheme.brandColor),
                            ),
                            //Follow Button
                            SizedBox(
                                width: 160,
                                height: 35,
                                child: (!_isFollowing)
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .brandColor),
                                        onPressed: () {},
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                              fontFamily: 'Segoe UI Black',
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                      )
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          side: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .brandColor),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Followed',
                                          style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .brandColor),
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
                          'There are many variations of passages of Lorem Ipsum available,\nbut the majority have suffered alteration\n in some form, by injected humour,\n or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum\n generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words,\n combined with a handful of model sentence structures, to generate Lorem\n Ipsum which looks reasonable.\n The generated Lorem Ipsum is therefore always free from repetition,\n injected humour, or non-characteristic words etc.There are many variations of passages of Lorem Ipsum available',
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.userBioColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 100, right: 100),
              child: ProfileUserVideosLargeScreen(),
            )),
          ],
        ),
      ),
    );
  }
}
