import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageSelector {
  static Future<File> selectImageFromGallery() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);

    return File(file!.path);
  }

  static Future<File> selectImageFromCamera() async {
    var file = await ImagePicker().pickImage(source: ImageSource.camera);

    return File(file!.path);
  }
}
