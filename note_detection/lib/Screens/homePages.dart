import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:note_detection/Data/constants.dart";
import "package:note_detection/Logic/Myimagepicker.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title /* required this.cameras*/});

  // final List<CameraDescription> cameras = [];
  final String title;
  final PageController _pageController = PageController();

  // List<File> selecteditems = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? aboutstopPosition;
  // double? howstopPosition;

  @override
  void dispose() {
    // TODO: implement dispose
    widget._pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Ensure the page controller is set to the initial page index
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   setState(() {});
    //   Future.delayed(const Duration(microseconds: 500000))
    //       .then((value) => {widget._pageController.jumpToPage(1)});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Positioned.fill(
          child: PageView(
            controller: widget._pageController,
            children: [
              // Scaffold(
              //   appBar: AppBar(
              //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              //     title: const Center(
              //         child: Text("H o w  t o  u s e  t h e  A p p .")),
              //   ),
              //   body: AboutPage(
              //     reportStopPosition: (val) {
              //       setState(() {
              //         howstopPosition = val;
              //       });
              //     },
              //     beginPosition: howstopPosition ?? 10,
              //   ),
              // ),
              //TODO

              WorkPage(
                homeWidget: widget,
                navigate2Help: () {
                  // widget._pageController.animateToPage(
                  //   0,
                  //   duration: const Duration(milliseconds: 1000),
                  //   curve: Curves.bounceIn,
                  // );
                  Navigator.pushNamed(context, "/About the app");
                },
              ),
              Scaffold(
                backgroundColor: Colors.blue.shade100,
                appBar: AppBar(
                  backgroundColor: Colors.blue.shade100,
                  title: Center(
                      child: Text(
                    "About : Ugandan Currency.",
                    style: GoogleFonts.protestGuerrilla(),
                  )),
                ),
                body: AboutPage(
                  reportStopPosition: (val) {
                    setState(() {
                      aboutstopPosition = val;
                    });
                  },
                  beginPosition: aboutstopPosition ?? 10,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          child: SmoothPageIndicator(
            controller: widget._pageController,
            count: 2,
            effect: JumpingDotEffect(
                radius: 10,
                activeDotColor: Colors.black,
                dotColor: Colors.blue.shade200),
          ),
        ),
      ],
    );
  }
}

class WorkPage extends StatelessWidget {
  const WorkPage({
    super.key,
    required this.homeWidget,
    required this.navigate2Help,
  });

  final MyHomePage homeWidget;
  final VoidCallback navigate2Help;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Center(
          child: Text(
            homeWidget.title,
            style: GoogleFonts.protestGuerrilla(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BoxElement(
              selectfrom: const MyChoiceWidget(choice: "camera"),
              ontap: () {
                Navigator.pushNamed(context, "/camera");
              },
            ),
            BoxElement(
              selectfrom: const MyChoiceWidget(choice: "Browser"),
              ontap: () async {
                List<File> selected = await Myimagepicker.chooseimages();
                if (selected.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    "/browser",
                    arguments: {
                      "selectedImageFiles": selected,
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigate2Help,
        tooltip: 'Need Help!',
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.help),
      ),
    );
  }
}
