import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraDelegate {
  static Future<File?> takePhoto({bool isCamera = true}) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? photo = await imagePicker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (photo == null) {
      return null;
    }
    return File(photo.path);
  }

  static Future<List<File>?> selectMultiplePhotos() async {
    final ImagePicker imagePicker = ImagePicker();
    final List<XFile>? photos = await imagePicker.pickMultiImage();

    if (photos == null) {
      return null;
    }

    // Limit the number of photos to 2
    final List<XFile> limitedPhotos = photos.take(2).toList();

    return limitedPhotos.map((photo) => File(photo.path)).toList();
  }
}
