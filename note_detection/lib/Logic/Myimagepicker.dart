import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Myimagepicker extends ChangeNotifier {
  static final ImagePicker picker = ImagePicker();
  static List<File> selectedimages = [];

  static Future<List<File>> chooseimages() async {
    List<XFile> images = await picker.pickMultiImage(imageQuality: 100);
    if (images.isEmpty) {
      return [];
    }
    return images.map((e) => File(e.path)).toList();
  }

  static Future<List<File>> takeImageSnap() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    return [if (image != null) File(image.path)];
  }
}
