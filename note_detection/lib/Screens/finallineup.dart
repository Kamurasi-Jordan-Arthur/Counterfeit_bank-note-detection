import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:note_detection/Logic/classification.dart';
import 'package:provider/provider.dart';

class FinalSolist extends StatefulWidget {
  FinalSolist({
    super.key,
    required this.selectedImageFiles,
  });
  final List<File> selectedImageFiles;

  @override
  State<FinalSolist> createState() => _FinalSolistState();
}

class _FinalSolistState extends State<FinalSolist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedImages = widget.selectedImageFiles
          .map((e) => Image.file(
                e,
                fit: BoxFit.cover,
              ))
          .toList();
      CoppiedImages = [...widget.selectedImageFiles];
    });
  }

  late List<Image> selectedImages;
  List<File> CoppiedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conterfeit note detector"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: selectedImages.length,
            itemBuilder: (context, index) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          // padding: const EdgeInsets.all(10),
                          // width: 250,
                          // height: 250,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(4, 4),
                                  blurRadius: 15.0,
                                  color: Colors.grey.shade500,
                                  spreadRadius: 1.0),
                              const BoxShadow(
                                  offset: Offset(-4, -4),
                                  blurRadius: 15.0,
                                  color: Colors.white,
                                  spreadRadius: 1.0)
                            ],
                          ),
                          child: GestureDetector(
                              onDoubleTap: () async {
                                print("Double tapped");
                                CroppedFile? tempImage = await ImageCropper()
                                    .cropImage(
                                        cropStyle: CropStyle.rectangle,
                                        sourcePath: widget
                                            .selectedImageFiles[index].path);
                                if (tempImage != null) {
                                  CoppiedImages.insert(
                                      index, File(tempImage.path));
                                  selectedImages.insert(
                                      index,
                                      Image.file(
                                        File(tempImage.path),
                                        fit: BoxFit.cover,
                                      ));
                                  selectedImages.removeAt(index + 1);
                                  CoppiedImages.removeAt(index + 1);
                                }
                                setState(() {});
                              },
                              child: selectedImages[index]),
                        ),
                      ),
                    ),
                    Positioned(
                        child: Center(
                      child: Text(
                        (context
                                .watch<OurClassifier>()
                                .classification
                                .isNotEmpty) // if empty do that
                            ? (context
                                            .watch<OurClassifier>()
                                            .classification
                                            .length -
                                        1 >=
                                    index) // check if classified specific item been classified yet
                                ? context
                                    .watch<OurClassifier>()
                                    .classification[index]
                                : "" // orelse empty strings should be displayed
                            : "",
                        style: TextStyle(
                            color: (context
                                    .watch<OurClassifier>()
                                    .classification
                                    .isNotEmpty)
                                ? Colors.amber
                                : Colors.transparent),
                      ),
                    )),
                    // const Center(
                    //     child: Text(
                    //   "Counterfeit",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     // color: Colors.greenAccent,
                    //     color: Colors.transparent,
                    //   ),
                    // )),
                    Positioned(
                      bottom: 10,
                      left: 8,
                      child: Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 2.0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.selectedImageFiles.removeAt(index);
                              selectedImages.removeAt(index);
                              CoppiedImages.removeAt(index);
                              context
                                  .read<OurClassifier>()
                                  .classification
                                  .removeAt(index);
                            }); // for checking the lenth of list
                            // print(selectedImages.length);
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 35,
                          ),
                          color: Colors.black12,
                        ))
                  ],
                )),
      )
      // ListView(
      //   children: [

      //     Wrap(
      //       spacing: -20,
      //       runSpacing: 0,
      //       clipBehavior: Clip.hardEdge,
      //       children: selectedImages,
      //     ),
      //   ],
      // ),
      ,
      floatingActionButton: FloatingActionButton(
          child: Text(
            "TEST",
          ),
          onPressed: (context.read<OurClassifier>().classifying)
              ? () {
                  print("Pressed to test");
                  print(context.read<OurClassifier>().classifying);
                }
              : () {
                  print("Pressed to test");
                  print(context.read<OurClassifier>().classifying);
                  context.read<OurClassifier>().classifyImages(CoppiedImages);
                }), // code for testing each with the model
    );
  }
}

Widget image = Expanded(
  child: Stack(
    children: [
      GestureDetector(
        onDoubleTap: () {},
        child: Positioned.fill(
          child: Container(
            // padding: const EdgeInsets.all(15),
            // width: 250,
            // height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // color: Colors.yellow,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(4, 4),
                    blurRadius: 15.0,
                    color: Colors.grey.shade500,
                    spreadRadius: 1.0),
                const BoxShadow(
                    offset: Offset(-4, -4),
                    blurRadius: 15.0,
                    color: Colors.white,
                    spreadRadius: 1.0)
              ],
            ),
            child: const Center(child: null),
          ),
        ),
      ),
      Positioned(
        top: 1.0,
        left: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text("/number"),
        ),
      ),
      Positioned(
          top: 2.0,
          left: 2.0,
          child: IconButton(
            onPressed: () {
              print("object");
            },
            icon: const Icon(
              Icons.cancel_outlined,
            ),
            color: Colors.black12,
          ))
    ],
  ),
);
