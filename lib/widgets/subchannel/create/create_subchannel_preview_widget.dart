import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';


class CreateSubchannelPreviewLargeScreen extends StatelessWidget {
  const CreateSubchannelPreviewLargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CreateSubchannel());
  }
}

class CreateSubchannel extends StatefulWidget {
  const CreateSubchannel({Key? key}) : super(key: key);

  @override
  _CreateSubchannelState createState() => _CreateSubchannelState();
}

class _CreateSubchannelState extends State<CreateSubchannel> {
  //Profil
  bool _isFollowing = false;


  //PreviewMode
  bool realPreviewMode = false;

  //Subchannel
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        //Subchannel Banner
        realPreviewMode ? 
        ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          child: Image.network(
            "https://picsum.photos/1920/230",
            fit: BoxFit.fill,
            // width: MediaQuery.of(context).size.width,
            height: 230,
            width: 1920,
          ),
        ) :
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Image.network(
            "https://picsum.photos/1920/230",
            fit: BoxFit.cover,alignment: Alignment.center,
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
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              child: Image.network(
                "https://picsum.photos/700",
                fit: BoxFit.contain,
                width: 87,
                height: 87,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "c/CoolSamuraiStuff",
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
                    child: (!_isFollowing)
                        ? TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
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
                                  color: Theme.of(context).canvasColor),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
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
            // const SizedBox(
            //   height: 40,
            // ),
            // SubchannelVideosGridLargeScreen(),
          ],
        ),
      ],
    );
  }
}
