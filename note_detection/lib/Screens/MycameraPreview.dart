import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_detection/Logic/mycameradetails.dart';
import 'package:provider/provider.dart';

class Mycamerapreview extends StatefulWidget {
  const Mycamerapreview({super.key});

  @override
  State<Mycamerapreview> createState() => _MycamerapreviewState();
}

class _MycamerapreviewState extends State<Mycamerapreview> {
  @override
  void initState() {
    super.initState();

    context.read<MyCamera>().initialiseCamController().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ((context.read<MyCamera>().initialised))
        ? Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio:
                          context.read<MyCamera>().controller.value.aspectRatio,
                      child: CameraPreview(
                        context.read<MyCamera>().controller,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 125,
                    right: 15,
                    child: RotatedBox(
                      quarterTurns:
                          3, // Rotate the slider 90 degrees clockwise to make it vertical
                      child: Slider(
                        thumbColor: Colors.black,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        value: context.watch<MyCamera>().zoomLevel,
                        onChanged: (value) {
                          context.read<MyCamera>().setZoom(value);
                        },
                        label:
                            '${context.watch<MyCamera>().zoomLevel.round()}', // Display zoom value as label
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 25,
                      decoration: const BoxDecoration(color: Colors.black26),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Gallery",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/browser",
                                      arguments: context
                                          .read<MyCamera>()
                                          .user_selected_images);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.black,
                                  child: (context
                                          .watch<MyCamera>()
                                          .user_selected_images
                                          .isNotEmpty)
                                      ? Image.file(
                                          context
                                              .watch<MyCamera>()
                                              .user_selected_images[0],
                                          // File(context
                                          //     .watch<MyCamera>()
                                          //     .user_selected_images
                                          //     .path),
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.black,
                                        ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.read<MyCamera>().snapimage(),
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(60),
                                      border: Border.all(
                                          width: 4,
                                          color: Colors.white,
                                          style: BorderStyle.solid)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Flash",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              IconButton(
                                  onPressed: () =>
                                      context.read<MyCamera>().toggleflash(),
                                  icon: Icon(
                                    (context.watch<MyCamera>().flashon)
                                        ? Icons.flash_on_outlined
                                        : Icons.flash_off_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          )
        : const CircularProgressIndicator();
  }
}
