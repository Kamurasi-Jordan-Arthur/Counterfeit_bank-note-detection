import 'dart:io';
// import 'dart:ui';
import 'package:flutter/cupertino.dart';
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
  Offset? focuspoint = null;

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
      await controller.setFlashMode(FlashMode
          .torch); // for some devices this means that the touch can be off
      // await controller.takePicture();
      notifyListeners();
      return;
    }
    await controller.setFlashMode(FlashMode.off);
    // await controller.takePicture();
    notifyListeners();
  }

  Future<void> snapimage() async {
    if (!takingpic) {
      print("taking pic");
      takingpic = true;
      notifyListeners();

      final tempimage = await controller.takePicture();

      saveToDevice(tempimage.path);
      print(tempimage.path);
      // just_taken = true;

      takingpic = false;
      notifyListeners();
      // takingpic = false;
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

  Future<void> setFocuspoint(
    Offset localposition,
    BoxConstraints constraints,
  ) async {
    // await controller.setFocusMode(FocusMode.auto);
    // await controller.setExposureMode(ExposureMode.auto);
    Offset relativeposition = Offset(
      localposition.dx / constraints.maxWidth,
      localposition.dy / constraints.maxHeight,
    );
    try {
      focusing = true;
      print("Focusing");

      focuspoint = Offset(
          relativeposition.dx.clamp(0, 1), relativeposition.dy.clamp(0, 1));

      await controller.setFocusPoint(focuspoint);
      await controller.setFocusMode(FocusMode.auto);

      notifyListeners();
      await Future.delayed(
        const Duration(
          seconds: 3,
        ),
      );

      focusing = false;
      focuspoint = null;

      notifyListeners();
      print("Focusing Ended");
    } catch (e) {
      print("Failed to set focus");
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
      // await controller.setExposureMode(ExposureMode.auto);
      // await controller.setFocusMode(FocusMode.auto);
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
