import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:note_detection/Data/constants.dart";
import "package:note_detection/Screens/Myimagepicker.dart";
// import "package:provider/provider.dart";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title /* required this.cameras*/});

  // final List<CameraDescription> cameras = [];
  final String title;
  // List<File> selecteditems = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BoxElement(
              selectfrom: const MyChoiceWidget(choice: "camera"),
              ontap: () {
                Navigator.pushNamed(context, "/camera");
              }, // Logic for camera tap i.e move to next page
            ),
            BoxElement(
              selectfrom: const MyChoiceWidget(choice: "Browser"),
              ontap: () async {
                List<File> selected = await Myimagepicker.chooseimages();
                if (selected.isNotEmpty) {
                  print(selected.length);
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

      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'History',
        child: Icon(Icons.history),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
