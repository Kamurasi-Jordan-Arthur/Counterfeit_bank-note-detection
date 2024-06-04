import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
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

  void handleImagecrop(index) async {
    CroppedFile? tempImage = await ImageCropper().cropImage(
        cropStyle: CropStyle.rectangle,
        sourcePath: widget.selectedImageFiles[index].path);
    if (tempImage != null) {
      CoppiedImages.insert(index, File(tempImage.path));
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
  }

  GestureDetector renderResultAnime(int index, String location) {
    return GestureDetector(
      onDoubleTap: () {
        if (!context.read<OurClassifier>().classifying) {
          handleImagecrop(index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ("images" != location.split("/")[1])
            ? Lottie.asset(location)
            : Image.asset(location),
      ),
    );
  }

  late List<Image> selectedImages;
  List<File> CoppiedImages = [];
  int _zoomLevel = 2;
  bool? zoomedIn = null; // keeping track of change i.e zoom_In or Zoom_Out
  //true and false respectivly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text("Conterfeit note detector",
            style: GoogleFonts.protestGuerrilla()),
      ),
      body: InteractiveViewer(
        maxScale: 1,
        minScale: 1,
        onInteractionUpdate: (details) {
          if (zoomedIn == null) {
            if (details.scale != 1.0) {
              if (details.scale < 1) {
                setState(() {
                  zoomedIn = false;
                });
              } else {
                setState(() {
                  zoomedIn = true;
                });
              }
            }
          }
          print(details.scale);

          // setState(() {
          //   _zoomLevel = details.scale.truncate().abs();
          //   print(_zoomLevel);
          // });
        },
        onInteractionEnd: (details) {
          if (zoomedIn != null) {
            if (zoomedIn!) {
              if (_zoomLevel > 1) {
                setState(() {
                  _zoomLevel = _zoomLevel - 1;
                });
              }
            } else {
              if (_zoomLevel < 4) {
                setState(() {
                  _zoomLevel = _zoomLevel + 1;
                });
              }
            }
          }
          zoomedIn = null;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .025),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _zoomLevel,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: selectedImages.length,
              itemBuilder: (context, index) => LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Stack(
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
                                      blurRadius: 10.0,
                                      color: Colors.grey.shade500,
                                      spreadRadius: 0.6),
                                  const BoxShadow(
                                      offset: Offset(-4, -4),
                                      blurRadius: 10.0,
                                      color: Colors.white,
                                      spreadRadius: 0.6)
                                ],
                              ),
                              child: GestureDetector(
                                  onDoubleTap: () {
                                    if (!context
                                        .read<OurClassifier>()
                                        .classifying) {
                                      handleImagecrop(index);
                                    }
                                  },
                                  child: selectedImages[index]),
                            ),
                          ),
                        ),
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
                                ? Column(
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: context.watch<OurClassifier>().classification[index] ==
                                                "Re-Classifiying"
                                            ? renderResultAnime(
                                                index, 'assets/lottie/analyse.json')
                                            : (context
                                                        .watch<OurClassifier>()
                                                        .classification[index]
                                                        .split(" ")[0] ==
                                                    "Genuine")
                                                ? double.parse(context
                                                            .watch<
                                                                OurClassifier>()
                                                            .classification[
                                                                index]
                                                            .split(" ")[1]) <
                                                        80
                                                    ? renderResultAnime(
                                                        index, 'assets/images/Error.png')
                                                    : renderResultAnime(
                                                        index, 'assets/lottie/Genuine.json')
                                                : (context
                                                            .watch<OurClassifier>()
                                                            .classification[index]
                                                            .split(" ")[0] ==
                                                        "CounterFiet")
                                                    ? double.parse(context.watch<OurClassifier>().classification[index].split(" ")[1]) < 80
                                                        ? renderResultAnime(index, 'assets/images/Error.png')
                                                        : renderResultAnime(index, 'assets/lottie/Counterfeit.json')
                                                    : renderResultAnime(index, 'assets/images/Error.png'),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: ClassificationTab(
                                          index: index,
                                        ),
                                      ),
                                    ],
                                  )
                                : (index ==
                                        context
                                            .watch<OurClassifier>()
                                            .classification
                                            .length)
                                    ? renderResultAnime(
                                        index, 'assets/lottie/analyse.json')
                                    : Container() // or-else nothing should be displayed
                            : Container(),
                        Positioned(
                          top: constraints.biggest.height * .025,
                          right: constraints.biggest.width * .04,
                          child: IconButton(
                            onPressed: () {
                              if (!context.read<OurClassifier>().classifying) {
                                setState(() {
                                  widget.selectedImageFiles.removeAt(index);
                                  selectedImages.removeAt(index);
                                  CoppiedImages.removeAt(index);
                                  try {
                                    context
                                        .read<OurClassifier>()
                                        .classification
                                        .removeAt(index);
                                  } catch (e) {
                                    print("No classification done yet");
                                  }
                                }); // for checking the lenth of list
                                // print(selectedImages.length);
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.delete_left_fill,
                              color: Colors.amber,
                              size: constraints.biggest.width * .125,
                            ),
                            color: Colors.black12,
                          ),
                        )
                      ],
                    );
                  })),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (context.read<OurClassifier>().classifying)
              ? () {
                  print("Pressed at classifying");
                }
              : () {
                  context.read<OurClassifier>().classifyImages(CoppiedImages);
                },
          child: const Text(
            textAlign: TextAlign.center,
            "SCAN ALL",
          )), // code for testing each with the model
    );
  }
}

class ClassificationTab extends StatelessWidget {
  const ClassificationTab({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        color: Colors.black54,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Center(
                  child: Text(
                    (context
                                .watch<OurClassifier>()
                                .classification[index]
                                .length ==
                            11)
                        ? "Classification Failure"
                        : (context
                                    .watch<OurClassifier>()
                                    .classification[index] ==
                                "Re-Classifiying")
                            ? "Retrying"
                            : double.parse(context
                                        .watch<OurClassifier>()
                                        .classification[index]
                                        .split(" ")[1]) >
                                    80
                                ? "${context.watch<OurClassifier>().classification[index].split(" ")[1].substring(0, 5)}% Confidence"
                                : "Recognition Failure",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: constraints.maxHeight *
                          .3, // Use viewport-relative units here
                      decorationColor: Colors.amber,
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.contain,
              child: IconButton(
                onPressed: (context.read<OurClassifier>().classifying)
                    ? () {
                        print("Pressed during classifying");
                      }
                    : () {
                        context
                            .read<OurClassifier>()
                            .reclassifyImage(index: index);
                      },
                icon: const Icon(
                  CupertinoIcons.arrow_clockwise_circle_fill,
                  color: Colors.amber,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Widget image = Expanded(
//   child: Stack(
//     children: [
//       GestureDetector(
//         onDoubleTap: () {},
//         child: Positioned.fill(
//           child: Container(
//             // padding: const EdgeInsets.all(15),
//             // width: 250,
//             // height: 250,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               // color: Colors.yellow,
//               boxShadow: [
//                 BoxShadow(
//                     offset: const Offset(4, 4),
//                     blurRadius: 15.0,
//                     color: Colors.grey.shade500,
//                     spreadRadius: 1.0),
//                 const BoxShadow(
//                     offset: Offset(-4, -4),
//                     blurRadius: 15.0,
//                     color: Colors.white,
//                     spreadRadius: 1.0)
//               ],
//             ),
//             child: const Center(child: null),
//           ),
//         ),
//       ),
//       Positioned(
//         top: 1.0,
//         left: 1.0,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: const Text("/number"),
//         ),
//       ),
//       Positioned(
//           top: 2.0,
//           left: 2.0,
//           child: IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               CupertinoIcons.delete_simple,
//             ),
//             color: Colors.black12,
//           ))
//     ],
//   ),
// );
