import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_detection/Logic/classification.dart';
import 'package:note_detection/Logic/mycameradetails.dart';
import 'package:note_detection/Screens/MycameraPreview.dart';
import 'package:note_detection/Screens/applicationBrief.dart';
import 'package:note_detection/Screens/finallineup.dart';
import 'package:note_detection/Screens/homePages.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => MyHomePage(title: 'Counterfiet Note Detector'));
      case "/camera":
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                // create: (context) => MyCamera(),
                create: (context) {
                  MyCamera m = MyCamera();
                  m.cameras = [];
                  return m;
                },
              )
            ],
            child: const Mycamerapreview(),
          ),
        );
      case "/browsers":
      case "/browser":
        return MaterialPageRoute(builder: (_) {
          // List<File> argss = List<File>.from(args);
          // ChangeNotifierProvider(
          //   create: (context) => OurClassifier(),
          //   child: FinalSolist(
          //     selectedImageFiles: argss.values.first,
          //   ),
          // );
          try {
            Map<String, List<File>>? argss = args as Map<String, List<File>>;
            return ChangeNotifierProvider(
              create: (context) => OurClassifier(),
              child: FinalSolist(
                selectedImageFiles: argss.values.first,
              ),
            );
          } catch (e) {
            print(e);
            if (args is List<File>) {
              return ChangeNotifierProvider(
                create: (context) => OurClassifier(),
                child: FinalSolist(
                  selectedImageFiles: args,
                ),
              );
            }
          }

          // print(argss);
          // print(argss.values.first.runtimeType);
          // print(args[0]);
          return const Errorpage();
          // if (argss is List<File>) {
        });

      case "/About the app":
        return MaterialPageRoute(builder: (_) => AppBrief());
      default:
        return MaterialPageRoute(
          builder: (_) => const Errorpage(),
        );
    }
  }
}

class Errorpage extends StatelessWidget {
  const Errorpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: const Text("ERROR"),
    );
  }
}
