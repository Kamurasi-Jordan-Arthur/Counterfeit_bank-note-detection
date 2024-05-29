// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// class OurClassifier extends ChangeNotifier {
//   OurClassifier() {
//     initialise();
//   }
//   bool classifying = false;
//   bool initialised = false;
//   List<String> labels = ["counterfeit", "Genuine"];
//   List<File> _selectedImages = [];
//   List<File> _copySelectedImages = [];
//   List<int> changed = [];
//   List<String> classification = [];

//   Interpreter interpreter = Interpreter.fromAsset(
//     'assets/model/model.tflite',
//     options: InterpreterOptions()..useNnApiForAndroid = true,
//   ) as Interpreter;

//   IsolateInterpreter? isolateInterpreter;
//   // IsolateInterpreter.create(address: interpreter.address);

//   Future<void> initialise() async {
//     if (!initialised) {
//       try {
//         // var interpreter = await Interpreter.fromAsset(
//         //   'assets/model/model.tflite',
//         //   options: InterpreterOptions()..useNnApiForAndroid = true,
//         // );
//         interpreter = await Interpreter.fromAsset('assets/model/model.tflite');
//         isolateInterpreter =
//             await IsolateInterpreter.create(address: interpreter.address);

//         labels = ["CounterFiet", "Genuine"];
//         // await interpreter.allocateTensors();
//         initialised = true;
//       } catch (e) {
//         print('Failed to load model: $e');
//       }
//     }
//     initialised = true;
//   }

//   Future<void> classifyImages(List<File> imgListFile) async {
//     classifying = true;
//     _copySelectedImages = imgListFile;
//     classifying = true;
//     if (!initialised) {
//       await initialise();
//     }
//     if (_copySelectedImages.isNotEmpty) {
//       for (int i = 0; i < _selectedImages.length; i++) {
//         if (_selectedImages[i] != _copySelectedImages[i]) {
//           // File imageFile = File(_selectedImages[i].path);
//           // Uint8List imageBytes = await imageFile.readAsBytes();

//           // // Decode the image bytes
//           // img.Image? image =
//           //     img.decodeNamedImage(_selectedImages[i].path, imageBytes);

//           // // Resize the image to the required input size (224x224) using Lanczos filter for better quality
//           // img.Image resizedImage = img.copyResize(image!,
//           //     width: 224, height: 224, interpolation: img.Interpolation.cubic);

//           // // Normalize the pixel values to be in the range [0, 1]
//           // img.Image normalizedImage =
//           //     img.normalize(resizedImage, min: 0, max: 1);

//           //     img.flate
//           //   normalizedImage.toList()
//           // List<double> normalizedPixels = List<double>.generate(
//           //   224 * 224 * 3,
//           //   (index) {
//           //     int pixelValue = resizedImage.data?.[index];

//           //     // Normalize pixel values to range [0, 1]
//           //     return pixelValue / 255.0;
//           //   },
//           // );

//           // // Convert normalized pixel values to Uint8List // this is the input tensor
//           // Uint8List normalizedImageBytes = Uint8List.fromList(
//           //     normalizedPixels.map((value) => (value * 255).round()).toList());

//           // // var outputTensors = List.filled(1,
//           // // Float64List(1000)); // Adjust the size based on your model output
//           var outputTensors = List.filled(2, 0.0).reshape([1, 2]);

//           try {
//             // Perform inference
//             // Replace this with your inference logic using the interpreter
            // interpreter.run(
//                 _selectedImages[i], List.filled(2, 0.0).reshape([1, 2]));
//             var output = outputTensors[0];
//             var maxIndex = output.indexOf(
//                 output.reduce((curr, next) => curr > next ? curr : next));
//             classification[i] = labels[maxIndex];
//             changed.add(i);
//             _copySelectedImages[i] = _selectedImages[i];
//             notifyListeners();
//           } catch (e) {
//             print(e);
//           }
//         }
//       }
//     } else {
//       // Similar logic for inference when _copySelectedImages is empty
//       for (int i = 0; i < _selectedImages.length; i++) {
//         // if (_selectedImages[i] != _copySelectedImages[i]) {
//         var input = _selectedImages[i].path;
//         try {
//           var output = List.filled(labels.length, 0.0).reshape([1, 2]);
//           interpreter.run(input, output);
//           // var output = outputTensors[0];
//           var maxIndex = output.indexOf(
//               output[0].reduce((curr, next) => curr > next ? curr : next));
//           classification[i] = labels[maxIndex];
//           _copySelectedImages[i] = _selectedImages[i];
//           notifyListeners();
//         } catch (e) {
//           print(e);
//         }
//         // }
//       }
//     }
//     classifying = false;
//   }

//   // Future<void> classifyImages(List<File> imgListFile) async {
//   //   _copySelectedImages = imgListFile;
//   //   classifying = true;
//   //   if (!initialised) {
//   //     await initialise();
//   //   }
//   //   if (_copySelectedImages.isNotEmpty) {
//   //     for (int i = 0; i < _selectedImages.length; i++) {
//   //       if (_selectedImages[i] != _copySelectedImages[i]) {
//   //         notifyListeners();
//   //         var input = _selectedImages[i].path;
//   //         var output = List.generate(labels.length, (_) => List.filled(1, 0.0));
//   //         try {
//   //           await Tflite.runModelOnBinary(
//   //             binary: File(input).readAsBytesSync(),
//   //             numResults: 1,
//   //             outputBuffer: output,
//   //           );
//   //           classification[i] = labels[
//   //               output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b))];
//   //           changed.add(i);
//   //           _copySelectedImages[i] = _selectedImages[i];
//   //           notifyListeners();
//   //         } catch (e) {
//   //           print(e);
//   //         }
//   //       }
//   //     }
//   //   } else {
//   //     for (File x in _selectedImages) {
//   //       var input = x.path;
//   //       var output = List.generate(labels.length, (_) => List.filled(1, 0.0));
//   //       try {
//   //         await Tflite.runModelOnBinary(
//   //           binary: File(input).readAsBytesSync(),
//   //           numResults: 1,
//   //           outputBuffer: output,
//   //         );
//   //         classification.add(labels[
//   //             output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b))]);
//   //         _copySelectedImages.add(x);
//   //         notifyListeners();
//   //       } catch (e) {
//   //         print('Failed to classify image: $e');
//   //       }
//   //     }
//   //     classifying = false;
//   //     notifyListeners();
//   //   }
//   // }

//   @override
//   dispose() async {
//     super.dispose();
//     interpreter.close();
//   }
// }
