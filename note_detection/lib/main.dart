import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:note_detection/Logic/routeLogic.dart';

late final List<CameraDescription> cameras;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final List<CameraDescription> cameras;

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      // initialRoute: "/",
      // routes: {
      //   '/': (context) => const MyHomePage(title: 'Counterfiet Note Detector'),
      //   '/camera': (context) => MultiProvider(
      //         providers: [
      //           ChangeNotifierProvider(
      //             // create: (context) => MyCamera(),
      //             create: (context) {
      //               MyCamera m = MyCamera();
      //               m.cameras = cameras;
      //               return m;
      //             },
      //           )
      //         ],
      //         child: const Mycamerapreview(),
      //       ),
      //   '/brouser': (context) => FinalSolist(
      //         selectedImageFiles: [],
      //       )
      // },
      // home: MultiProvider(providers: [
      //   ChangeNotifierProvider(
      //     create: (context) => MyCamera(),
      //   )
      // ], child: const MyHomePage(title: 'Counterfiet Note Detector')),
    );
  }
}
