import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageService {
  static Future<File?> getImage({required ImageSource from}) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    return imageFile != null ? File(imageFile.path) : null;
  }
}
