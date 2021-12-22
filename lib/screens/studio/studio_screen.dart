import 'package:flutter/material.dart';
import 'package:uidraft1/screens/studio/studioPosts/studio_posts_screen.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/navbar/studio/studio_large_navbar.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({Key? key}) : super(key: key);

  @override
  _StudioState createState() => _StudioState();
}

class _StudioState extends State<StudioScreen> {
  int menuTab = 0;

  bool _isLeftHand = false;

  // //Get Post  Data by Id
  // Future<Map<String, dynamic>> fetchPostData(int id) async {
  //   final response =
  //       await http.get(Uri.parse('http://localhost:3000/post/getPost/$id'));

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     if (map.isNotEmpty) {
  //       return map;
  //     } else {
  //       throw Exception('Failed to load post');
  //     }
  //   } else {
  //     // If that call was not successful, throw an error.
  //     throw Exception('Failed to load post');
  //   }
  // }

  @override
  void initState() {
    // incrementPostViewsByOne(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWidget.isLargeScreen(context)
          ?
          //LargeScreenNavBar
          getLargeNavBar()
          : ResponsiveWidget.isVeryLargeScreen(context)
              ?
              //VeryLargeScreenNavBar
              null
              : null,
      drawer: ResponsiveWidget.isMediumScreen(context)
          ?
          //MediumScreenDrawer
          null
          : ResponsiveWidget.isSmallScreen(context)
              ?
              //SmallScreenDrawer
              null
              : null,
      body: const StudioPostsScreen(),
    );
  }

  //ExtractTest
  PreferredSize getLargeNavBar() {
    return const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child:
            Align(alignment: Alignment.topCenter, child: NavBarLargeStudio()));
  }
}

/*
Responsive Builder in Screen und in Navbar getrennt um current postId beizubehalten
*/