import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppBrief extends StatefulWidget {
  const AppBrief({super.key});

  @override
  State<AppBrief> createState() => _AppBriefState();
}

class _AppBriefState extends State<AppBrief> {
  final PageController _pageController = PageController();
  final List<Color> backgroudColor = [
    Colors.blue.shade100,
    Colors.greenAccent,
    Colors.deepPurple.shade100,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.cyan.shade200,
    Colors.white70,
    Colors.purpleAccent.shade100,
  ];
  int currentpage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroudColor[currentpage],
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: PageView(
              controller: _pageController,
              onPageChanged: (nextpage) {
                setState(() {
                  currentpage = nextpage;
                });
              },
              children: const [
                HelpPageContent(
                  // Wellcome message
                  message: "I will help show you around.",
                  animation: 'assets/images/Guide.png',
                ),
                HelpPageContent(
                  // Application Aim
                  message: "Aim...",
                  subtext: "Counterfeit bank note-detection.",
                  animation: 'assets/lottie/money.json',
                ),
                HelpPageContent(
                  // Take pictures
                  message: "Camera",
                  subtext: "Option to : take snapshots of suspected notes.",
                  animation: 'assets/lottie/snapPhoto.json',
                ),
                HelpPageContent(
                  // Brouse phone storage
                  message: "Gallery ",
                  subtext:
                      "Option to : Select images from your phone's gallery.",
                  animation: 'assets/images/PickFromGallery.png',
                ),
                HelpPageContent(
                  // choose multiple
                  message: "Multiple Choice",
                  subtext:
                      "Enhance speed and flexibility by processing multiple images simultaneously.",
                  animation: 'assets/lottie/ChooseMultipleTransparent.json',
                ),
                HelpPageContent(
                  // Classification
                  message: "Scan ...",
                  subtext: "Initiate image scanning and analysis",
                  animation: 'assets/lottie/analyse.json',
                ),
                HelpPageContent(
                  // Result presentation
                  message: "Detection Results",
                  subtext:
                      "AI Image recognition results will be displayed there after.",
                  animation: 'assets/images/ClassificationResult.png',
                ),
                HelpPageContent(
                  // Get stated
                  message: "Feeling Confident !!!.",
                  subtext:
                      "Take another tour? \n Or should we just get-started?",
                  animation: 'assets/images/Getstarted.png',
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (currentpage == 7)
                      ? () {
                          _pageController.animateToPage(0,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut);
                          setState(() {
                            currentpage = 0;
                          });
                        }
                      : () {
                          _pageController.animateToPage(7,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut);
                          setState(() {
                            currentpage = 7;
                          });
                        },
                  child: (currentpage == 7)
                      ? const Text("Yes")
                      : const Text("Skip"),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 8,
                  effect: SlideEffect(
                      radius: 10,
                      activeDotColor:
                          Theme.of(context).colorScheme.primary.withOpacity(.5),
                      dotColor: Colors.blue.shade200),
                ),
                TextButton(
                  onPressed: () {
                    (currentpage == 7)
                        ? Navigator.pushNamed(context, "/")
                        : _pageController.nextPage(
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeIn);
                  },
                  child: (currentpage == 7)
                      ? const Text("No")
                      : const Text("Next"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HelpPageContent extends StatefulWidget {
  const HelpPageContent(
      {super.key, this.message, this.subtext, required this.animation});
  final String? message;
  final String? subtext;
  final String animation;

  @override
  State<HelpPageContent> createState() => _HelpPageContentState();
}

class _HelpPageContentState extends State<HelpPageContent> {
  Widget pickAsset() {
    if (widget.animation.split("/")[1] == "images") {
      if (widget.animation == "assets/images/Getstarted.png") {
        return RotatedBox(
          quarterTurns: 1,
          child: Image.asset(widget.animation),
        );
      }
      return Image.asset(widget.animation);
    } else {
      if (widget.animation == "assets/images/Getstarted.png") {}
      return Lottie.asset(widget.animation, fit: BoxFit.fill);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.message ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.shrikhand(
                  fontSize: 20.0,

                  // fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary.withOpacity(.5),
                ),
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              Text(
                widget.subtext ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.charm(
                    fontSize: 15.0,
                    color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
          pickAsset()
        ],
      ),
    );
  }
}
