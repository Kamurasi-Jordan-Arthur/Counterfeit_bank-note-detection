import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

late List<File> user_selected_images = [];

class MyCamera extends ChangeNotifier {
  late CameraController controller;

  late List<CameraDescription> cameras;

  late List<File> user_selected_images = [];

  double zoomLevel = 0.0;
  double maxzoom = 0;
  double minzoom = 0.5;
  bool focusing = false;

  bool flashon = false;

  // late XFile memoImage;

  bool initialised = false;
  bool takingpic = false;
  // bool just_taken = false;

  Future<void> setZoom(double value) async {
    double new_value = value / 100.0 * (maxzoom - minzoom) + minzoom;
    if (new_value == minzoom) {
      new_value = value / 100.0 * 3 + minzoom;
    }
    controller.setZoomLevel(new_value);
    // controller.setZoomLevel(4);
    zoomLevel = value;
    notifyListeners();
  }

  Future<void> toggleflash() async {
    flashon = !flashon;
    if (flashon) {
      await controller.setFlashMode(FlashMode.always);
      notifyListeners();
      return;
    }
    await controller.setFlashMode(FlashMode.off);

    notifyListeners();
  }

  Future<void> snapimage() async {
    if (!takingpic) {
      print("taking pic");
      takingpic = true;
      notifyListeners();
      final tempimage = await controller.takePicture();
      saveToDevice(tempimage.path);
      // just_taken = true;

      notifyListeners();
      takingpic = false;
    }
  }

  void upDateSelected({
    required bool insert,
    required File imagefile,
  }) {
    print("inseting *********************************");
    if (insert) {
      user_selected_images.insert(0, imagefile);
      print("length of selected ${user_selected_images.length}");
      return;
    }
    user_selected_images.remove(imagefile);
  }

  Future<void> saveToDevice(String memoImageLocation) async {
    print("savingtodevice");
    final Directory directory = await getApplicationDocumentsDirectory();
    final imagename = p.basename(memoImageLocation);
    final newloc = "${directory.path}/$imagename";
    // final newloc = "${directory.path}/${DateTime.now()}/$imagename";

    final File newimage = await File(memoImageLocation).copy(newloc);
    upDateSelected(insert: true, imagefile: newimage);

    notifyListeners();
  }

  Future<void> setFocuspoint(Offset relativeposition) async {
    Offset myoffset = Offset(
      relativeposition.dx.clamp(0.0, 1),
      relativeposition.dy.clamp(0.0, 1),
    );
    try {
      await controller.setFocusPoint(myoffset);
      focusing = true;
      notifyListeners();
      Future.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      await controller.setFocusPoint(null);
      focusing = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> initialiseCamController() async {
    // await getAvailableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      await controller.initialize();
      minzoom = await controller.getMinZoomLevel();
      maxzoom = await controller.getMinZoomLevel();
      await controller.setFlashMode(FlashMode.off);
      initialised = true;

      notifyListeners();
    } else {
      // Handle scenario when no cameras are available
      await getAvailableCameras();

      await initialiseCamController();
    }
  }

  Future<void> getAvailableCameras() async {
    cameras = await availableCameras();
    notifyListeners();
  }

  // void camInstantDispose() {
  //   controller.dispose();
  // }

  @override
  void dispose() {
    print("disposing camera");
    controller.dispose();
    initialised = false;
    // just_taken = false;
    notifyListeners();
    super.dispose();
  }
}
