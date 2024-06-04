import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/cupertino.dart';

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
              color: Colors.blue.shade200,
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
          (choice == "camera")
              ? CupertinoIcons.camera_fill
              : CupertinoIcons.folder_fill_badge_person_crop,
          size: 100,
        ),
        Text((choice == "camera") ? "Take Image" : "Browse Storage"),
      ],
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({
    super.key,
    required this.reportStopPosition,
    required this.beginPosition,
  });

  final Function(double) reportStopPosition;
  final double beginPosition;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late ScrollController scrollController;
  late double currentBeginPosition;
  late Future<String> markdownFuture;
  bool isSliderActive = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    currentBeginPosition = 0;
    markdownFuture = loadMarkdown(); // Initialize the future

    // Listen to scroll events
    scrollController.addListener(() {
      if (!isSliderActive) {
        setState(() {
          currentBeginPosition = (scrollController.offset /
                  scrollController.position.maxScrollExtent) *
              1000;
        });
        widget.reportStopPosition((scrollController.offset /
                scrollController.position.maxScrollExtent) *
            1000);
      }
    });

    // Schedule the callback to run after the initial frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(
          () {}); // Ensure the widget is built to reflect any initial state changes
      Future.delayed(const Duration(seconds: 1)).then((_) {
        scrollController.animateTo(
          (widget.beginPosition / 1000) *
              scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCirc,
        );
      });
    });
  }

  @override
  void dispose() {
    if (scrollController.hasClients) {
      scrollController.dispose();
    }

    super.dispose();
  }

  Future<String> loadMarkdown() async {
    return await rootBundle.loadString('assets/docs/chatbot.md');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: markdownFuture, // Use the stored future
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Markdown(
                data: snapshot.data ?? '',
                controller: scrollController,
                selectable: true,
              ),
              Positioned(
                right: 0,
                top: 3,
                bottom: 3,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      activeColor: const Color.fromARGB(255, 209, 209, 209),
                      min: 0,
                      max: 1000,
                      value: currentBeginPosition,
                      onChangeStart: (value) {
                        setState(() {
                          isSliderActive = true;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          currentBeginPosition = value;
                          scrollController.jumpTo(
                            (value / 1000) *
                                scrollController.position.maxScrollExtent,
                            // duration: const Duration(seconds: ),
                            // curve: Curves.easeIn,
                          );
                        });
                      },
                      onChangeEnd: (value) {
                        widget.reportStopPosition((scrollController.offset /
                                scrollController.position.maxScrollExtent) *
                            1000);
                        setState(() {
                          isSliderActive = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
