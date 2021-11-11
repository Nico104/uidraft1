import 'package:flutter/material.dart';
import 'package:uidraft1/widgets/submod/submod_data/submod_data_subchannel_preview_widget.dart';

class SubModDataTab extends StatefulWidget {
  const SubModDataTab({Key? key}) : super(key: key);

  @override
  _SubModDataTabState createState() => _SubModDataTabState();
}

class _SubModDataTabState extends State<SubModDataTab> {
  bool _showDetail = false;
  String? _activeUsername;

  void setToDetail(String username) {
    setState(() {
      _showDetail = true;
      _activeUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      child: const SubModSubchannelPreview(
        banner: null,
        subchannelPicture: null,
      ),
    );
  }
}
