import 'package:flutter/material.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_large_widget.dart';
import 'package:uidraft1/widgets/subchannel/large/subchannel_large_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubchannelScreen extends StatefulWidget {
  const SubchannelScreen({Key? key, required this.subchannelName})
      : super(key: key);

  final String subchannelName;

  @override
  _SubchannelState createState() => _SubchannelState();
}

class _SubchannelState extends State<SubchannelScreen> {
  String baseURL = 'http://localhost:3000/';

  //Get Subchannel Data by SubchannelName
  Future<Map<String, dynamic>> fetchSubchannelData(
      String subchannelName) async {
    final response = await http.get(Uri.parse(
        baseURL + 'subchannel/getSubchannelWithPreview/' + subchannelName));

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
        future: fetchSubchannelData(widget.subchannelName),
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
                    SubchannelLargeScreen(
                      subchannelData: snapshot.data!,
                    ),
                    NavBarLarge(
                      setActiveFeed: (_) {},
                      activeFeed: 0,
                      customFeed: false,
                    ),
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
