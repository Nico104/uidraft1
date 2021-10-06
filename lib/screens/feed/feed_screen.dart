import 'package:flutter/material.dart';
import 'package:uidraft1/widgets/feed/feed_grid_widget.dart';
import 'package:uidraft1/widgets/navbar/navbar_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      // body: FeedGridScreen(),
      body: const Text("FeedGridScreen"),
    );
  }
}
