import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/utils/upload/post/uploadDialog/upload_post_dialog_utils.dart';
import 'package:uidraft1/utils/upload/provider/upload_status.dart';

class UploadProgressList extends StatefulWidget {
  const UploadProgressList({Key? key}) : super(key: key);

  @override
  _UploadProgressListState createState() => _UploadProgressListState();
}

class _UploadProgressListState extends State<UploadProgressList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UploadStatus>(builder: (context, uploadstatus, _) {
      if (uploadstatus.uploads.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: getUploadListWidget(uploadstatus.uploads, context),
          ),
        );
      } else {
        return InkWell(
          onTap: () => showPostUploadDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: const [
                Icon(Icons.upload_outlined),
                Text("No current uploads"),
              ],
            )),
          ),
        );
      }
    });
  }
}

List<Widget> getUploadListWidget(
    List<UploadObject> uploads, BuildContext context) {
  List<Widget> ulWidgets = [];
  for (UploadObject element in uploads) {
    ulWidgets.add(ListTile(
      title: Text(element.name),
      trailing: getTrailingWidget(element.progress),
    ));
  }
  // ulWidgets.add(GestureDetector(
  //   onTap: () => showPostUploadDialog(context),
  //   child: Row(
  //     children: const [
  //       Icon(Icons.upload_outlined),
  //       Text("New Upload"),
  //     ],
  //   ),
  // ));
  return ulWidgets;
}

Widget getTrailingWidget(Progress prg) {
  switch (prg) {
    case Progress.uploading:
      return const CircularProgressIndicator();
    case Progress.success:
      return const Icon(Icons.check);
    case Progress.error:
      return const Icon(Icons.error);
  }
}


// Consumer<ConnectionService>(builder: (context, connection, _) {