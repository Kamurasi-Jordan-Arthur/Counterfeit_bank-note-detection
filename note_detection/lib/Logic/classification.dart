import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:tflite_flutter_plus/src/bindings/types.dart' as tfl_P;

class OurClassifier extends ChangeNotifier {
  OurClassifier() {
    initialise();
  }
  bool classifying = false;
  bool initialised = false;
  bool error = false;
  List<String> labels = ["Counterfeit", "Genuine"];
  List<File> _selectedImages = [];
  // List<File> _copySelectedImages = [];
  List<int> changed = [];
  List<String> classification = [];
  Interpreter? interpreter;
  int width = 224;
  int height = 224;
  // Interpreter interpreter = Interpreter.fromAsset(
  //   'assets/model/model.tflite',
  //   options: InterpreterOptions()..useNnApiForAndroid = true,
  // ) as Interpreter;

  // IsolateInterpreter? isolateInterpreter;
  // IsolateInterpreter.create(address: interpreter.address);

  Future<void> initialise() async {
    if (!initialised) {
      try {
        // var interpreter = await Interpreter.fromAsset(
        //   'assets/model/model.tflite',
        //   options: InterpreterOptions()..useNnApiForAndroid = true,
        // );
        interpreter = await Interpreter.fromAsset('models/model.tflite');
        // interpreter = await Interpreter.fromAsset('models/ResNet152V2_2.h5');
        // isolateInterpreter =
        //     await isolateInterpreter.create(address: interpreter.address);

        labels = ["CounterFiet", "Genuine"];
        // await interpreter.allocateTensors();
        initialised = true;
      } catch (e) {
        print('Failed to load model: $e');
      }
    }
    initialised = true;
  }

  Future<void> classifyImages(List<File> imgListFile) async {
    classifying = true;
    notifyListeners();
    classification = [];
    print("classfy started");
    _selectedImages = imgListFile;
    // _copySelectedImages = imgListFile;

    if (!initialised) {
      print("Not initialesd");
      await initialise();
    }
    List<List<double>> outputTensors = [
      [0.0, 0.0]
    ];
    // List.filled(2, 0.0).reshape([1, 2]) as List<List<double>>;

    for (int i = 0; i < imgListFile.length; i++) {
      TensorImage normalizedImage = await _preProcessInput(i);

      print("normalised");

      try {
        print("Classifying");

        await classify(normalizedImage, outputTensors, i);
        notifyListeners();
      } catch (e) {
        print(e);
        classification = List.filled(_selectedImages.length, "Model Error");

        break;
      }
      // }
    }
    classifying = false;
  }

  Future<void> reclassifyImage({required int index}) async {
    classifying = true;
    notifyListeners();

    classification[index] = "Re-Classifiying";
    print("Image Re-Classifiying");

    if (!initialised) {
      print("Not initialesd");
      await initialise();
    }
    List<List<double>> outputTensors = [
      [0.0, 0.0]
    ];
    TensorImage normalizedImage = await _preProcessInput(index);

    print("normalised");

    try {
      print("Classifying");

      await classify(normalizedImage, outputTensors, index);
      classification.removeAt(index + 1);
      notifyListeners();
    } catch (e) {
      print(e);
      classification[index] = "Model Error";

      return;
    }
    classifying = false;
    notifyListeners();

    // }
  }

  // Future<Float32List> preprocessImage(int i) async {
  //   File imageFile = File(_selectedImages[i].path);
  //   Uint8List imageBytes = await imageFile.readAsBytes();

  //   img.Image? image = img.decodeNamedImage(
  //     Uint8List.fromList(imageBytes),
  //     _selectedImages[i].path,
  //   );
  //   print(image?.height);
  //   print(image?.width);
  //   height = (image!.height / 10).round();
  //   width = (image.width / 10).round();
  //   // // Resize the image to the required input size (224x224) using Lanczos filter for better quality
  //   img.Image resizedImage = img.copyResize(
  //     image,
  //     width: width,
  //     height: height,
  //     // interpolation: img.Interpolation.cubic,
  //   );

  //   // // Normalize the pixel values to be in the range [0, 1]
  //   // img.Image normalizedImage = img.normalize(resizedImage, min: 0, max: 1);

  //   // var normalizedImage = Float32List.fromList(resizedImage.data
  //   var normalizedImage = Float32List.fromList(resizedImage.data
  //       .map((pixel) => pixel / 4294967296) // Normalize each pixel value
  //       .toList());

  //   // var normalizedImage = Float32List.fromList(image.data)

  //   var expandedImage = normalizedImage
  //       .expand((element) => [element, element, element])
  //       .toList();

  //   // return normalizedImage;
  //   return Float32List.fromList(expandedImage);
  // }

  Future<void> classify(
    TensorImage inputTensor,
    List<List<double>> outputTensors,
    int i,
  ) async {
    print("real classifying");
    // print(inputTensor.dataType);
    // print(inputTensor.buffer);
    // print([inputTensor.getTensorBuffer()].shape);
    // print(inputTensor.buffer.asFloat32List().reshape([1, width, height, 3]));
    // TensorBuffer inputBuffer = inputTensor.getTensorBuffer();
    // List<int> originalShape = inputBuffer.getShape();
    // List<int> newShape = [1] + originalShape;
    // inputBuffer = inputBuffer.reshape(newShape);

    interpreter!.run(
      inputTensor.buffer.asFloat32List().reshape([1, width, height, 3]),
      // normalizedImage.reshape([
      //   1,
      //   width,
      //   height,
      //   3,
      // ]),
      // normalizedImage.reshape([1, 224, 224, 3]),
      outputTensors,
    );

    print("Done");
    var output = outputTensors[0];
    var maxIndex = output
        .indexOf(output.reduce((curr, next) => curr > next ? curr : next));
    // // _copySelectedImages[i] = _selectedImages[i];

    print("${labels[maxIndex]} ${output[maxIndex] * 100} at ${i + 1}");

    classification.insert(
        i, "${labels[maxIndex]} ${output[maxIndex] * 100} at ${i + 1}");
    // print(output);
    // print(maxIndex);
  }

  @override
  dispose() async {
    super.dispose();
    if (interpreter != null) {
      interpreter!.close();
    }
  }

  Future<TensorImage> _preProcessInput(int i) async {
    File imageFile = File(_selectedImages[i].path);
    Uint8List imageBytes = await imageFile.readAsBytes();

    img.Image? image = img.decodeNamedImage(
      Uint8List.fromList(imageBytes),
      _selectedImages[i].path,
    );
    // #1
    // final inputTensor = TensorImage(interpreter!.getInputTensor(0).type);
    final inputTensor = TensorImage(tfl_P.TfLiteType.float32);

    inputTensor.loadImage(image!);
    // print(inputTensor);

    // #2
// Assuming inputTensor is of type TensorImage or similar
    final minLength = inputTensor.height > inputTensor.width
        ? inputTensor.width
        : inputTensor.height;
    final cropOp = ResizeWithCropOrPadOp(minLength, minLength);

    // #3
    // final shapeLength = _model.inputShape[1];
    // final shapeLength = interpreter.getInputTensor(0)
    // Get input tensor information
    // final shapeLength = interpreter!.getInputTensor(0).shape[0];
    final shapeLength = interpreter!.getInputTensor(0).shape.length;
    print(shapeLength);
// Extract input tensor shape

    final resizeOp = ResizeOp(height, width, ResizeMethod.bilinear);

    // #4
    final normalizeOp = NormalizeOp(127.5, 127.5);

    // #5
    final imageProcessor = ImageProcessorBuilder()
        .add(cropOp)
        .add(resizeOp)
        .add(normalizeOp)
        .build();

    imageProcessor.process(inputTensor);

    // #6
    return inputTensor;
  }
}
