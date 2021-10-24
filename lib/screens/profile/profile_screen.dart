import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/profile/navbar_large_profile_widget.dart';
import 'package:uidraft1/widgets/profile/large/profile_large_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  //Get Profile Data by Username
  Future<Map<String, dynamic>> fetchProfileData(String username) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/user/getProfile/$username'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map.isNotEmpty) {
        print("test2");
        return map;
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchProfileData(widget.username),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ResponsiveWidget(
              smallScreen: Text("smallScreen"),
              mediumScreen: Text("mediumScreen"),
              largeScreen: Material(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ProfileLargeScreen(
                      profileData: snapshot.data!,
                    ),
                    const NavBarLargeProfile()
                  ],
                ),
              ),
              veryLargeScreen: Text("veryLargeScreen"),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
