import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraDelegate {
  static Future<File?> takePhoto({bool isCamera = true}) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? photo = await imagePicker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (photo == null) {
      return null;
    }
    return File(photo.path);
  }
}