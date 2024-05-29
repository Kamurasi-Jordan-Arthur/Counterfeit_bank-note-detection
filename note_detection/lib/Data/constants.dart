import 'package:flutter/material.dart';
// import 'package:note_detection/Screens/MycameraPreview.dart';
// import 'package:note_detection/Screens/homePage.dart';
// import 'package:provider/provider.dart';

// Map<String, Widget Function(BuildContext)> myroutes = {
//   '/': (context) => MultiProvider(providers: [
//         ChangeNotifierProvider<MyCamera>(
//           create: (context) => MyCamera(),
//         )
//       ], child: const MyHomePage(title: 'Counterfiet Note Detector')),
//   '/camera': (context) => const Mycamerapreview(),
// };

class MyCamera {}

class BoxElement extends StatelessWidget {
  final Widget selectfrom;
  final VoidCallback ontap;
  const BoxElement({super.key, required this.selectfrom, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: ontap,
          child: Container(
            // padding: const EdgeInsets.all(15),
            width: 250,
            height: 250,
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
            child: Center(child: selectfrom),
          ),
        ),
      ),
    );
  }
}

class MyChoiceWidget extends StatelessWidget {
  final String choice;

  const MyChoiceWidget({super.key, required this.choice});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          (choice == "camera") ? Icons.camera_alt : Icons.folder,
          size: 100,
        ),
        Text((choice == "camera") ? "Take Image" : "Browse Phone"),
      ],
    );
  }
}
