import 'package:flutter/material.dart';

class UploadStatus with ChangeNotifier {
  List<UploadObject> uploads = <UploadObject>[];

  List<UploadObject> getUploads() => uploads;

  int addUploadProcess(String name) {
    UploadObject uo = UploadObject(name, Progress.uploading);

    uploads.add(uo);

    notifyListeners();

    return uploads.length - 1;
  }

  void setSuccess(int index) {
    uploads[index].progress = Progress.success;
    notifyListeners();
  }

  void setError(int index) {
    uploads[index].progress = Progress.error;
    notifyListeners();
  }
}

class UploadObject {
  final String name;
  Progress progress;

  UploadObject(this.name, this.progress);
}

enum Progress { uploading, success, error }
