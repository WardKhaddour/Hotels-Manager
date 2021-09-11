import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../models/cloud_storage_result.dart';

class FirebaseStorageServise {
  static Future<CloudStorageResult?> uploadImage(
      String title, File imageToUpload) async {
    var storage = FirebaseStorage.instance;
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();
    final firebaseStorageRef = storage.ref().child(imageFileName);
    var upload = await firebaseStorageRef.putFile(imageToUpload);
    var downloadUrl = await upload.ref.getDownloadURL();
    if (upload.state == TaskState.success) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }
    print('failddddd');
    return null;
  }
}
