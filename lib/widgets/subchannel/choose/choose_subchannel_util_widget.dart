import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uidraft1/utils/constants/global_constants.dart';

class ChooseSubchannelUtil extends StatefulWidget {
  const ChooseSubchannelUtil({Key? key, required this.notifyParent})
      : super(key: key);

  final Function(String val) notifyParent;

  @override
  _ChooseSubchannelUtilState createState() => _ChooseSubchannelUtilState();
}

class _ChooseSubchannelUtilState extends State<ChooseSubchannelUtil> {
  bool _loading = true;

  List<List<String>> subchannelNames = [];
  bool isLoading = false;

  final TextEditingController _searchText = TextEditingController();

  //Get SubchannleNames List
  Future<void> fetchSubchannels(String search) async {
    try {
      final response = await http
          .get(Uri.parse(baseURL + 'subchannel/searchSubchannel/$search'));

      if (response.statusCode == 200) {
        subchannelNames.clear();
        List<dynamic> values = <dynamic>[];
        values = json.decode(response.body);
        if (values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              subchannelNames.add([
                '${map['subchannelName']}',
                '${map['subchannelPreview']['subchannelSubchannelPicturePath']}'
              ]);
            }
          }
        }
        setState(() {
          _loading = false;
        });
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  void initState() {
    _loading = false;

    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => fetchSubchannels(_searchText.text));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  maxLength: 21,
                  cursorColor: Colors.white,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: "Subchannel Name",
                    labelStyle: const TextStyle(
                        fontFamily: "Segoe UI", color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                      fontFamily: "Segoe UI", color: Colors.white),
                  onChanged: (text) {
                    EasyDebounce.debounce(
                        'titleTextField-debouncer', // <-- An ID for this particular debouncer
                        const Duration(
                            milliseconds: 300), // <-- The debounce duration
                        () async {
                      await fetchSubchannels(text);
                      setState(() {
                        print("subchannel searched for $text");
                        print("subchannelList: " + subchannelNames.toString());
                      });
                    } // <-- The target method
                        );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: subchannelNames.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => widget.notifyParent(
                          subchannelNames.elementAt(index).elementAt(0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            child: Image.network(
                              // baseURL +
                              spacesEndpoint +
                                  subchannelNames.elementAt(index).elementAt(1),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "c/" + subchannelNames.elementAt(index).first,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 2,
                        ),
                        Divider(),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }
}
