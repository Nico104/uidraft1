import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/network/http_client.dart';
import 'package:uidraft1/utils/responsive/responsive_builder_widget.dart';
import 'package:uidraft1/utils/subchannel/subchannel_util_methods.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionService>(builder: (context, connection, _) {
      return FutureBuilder(
          future: fetchSubchannelData(
              widget.subchannelName, connection.returnConnection()),
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
    });
  }
}
