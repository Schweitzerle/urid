import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import 'package:urid/feature/screens/taskOverview/taskOverview.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';

import '../../models/strings.dart';
import '../../models/subject.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TaskAssigningService taskAssigningService =
  GetIt.instance<TaskAssigningService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: introSliderPages(context),
    );
  }

  Widget introSliderPages(BuildContext context) {
    return CustomWillPopScopeWidget(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: Strings.welcomeTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.welcomeBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/hello.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
          PageViewModel(
            title: Strings.confidentialityTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.confidentialityBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/privacy.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
          PageViewModel(
            title: Strings.studyProcessTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.studyProcessBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/study.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
          PageViewModel(
            title: Strings.interactionMethodsTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.interactionMethodsBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/interaction.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
          PageViewModel(
            title: Strings.questionnaireTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.questionnaireBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/survey.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
          PageViewModel(
            title: Strings.interviewTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.interviewBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/coopWork.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
          PageViewModel(
            title: Strings.readyTitle,
            bodyWidget: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.readyBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            image: Center(child: Lottie.asset('assets/animations/start.json')),
            decoration: const PageDecoration(
              bodyFlex: 5,
              imageFlex: 3,
              bodyAlignment: Alignment.topCenter,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.all(8),
            ),
          ),
        ],
        showNextButton: true,
        next: const Icon(Icons.arrow_forward),
        done: const Text("Start"),
        onDone: () async {
          await taskAssigningService.incrementCounter();
          print(taskAssigningService.task);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              switch (taskAssigningService.task) {
                case 1:
                  return CoverTaskIDIntro();
                case 2:
                  return ButtonTaskIDIntro();
                case 3:
                  return FlipTaskIDIntro();
                case 4:
                  return VolumeButtonTaskIDIntro();
                default:
                  return const TaskOverviewScreen();
              }
            }),
          );
        },
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
          size: const Size.square(10.0),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: Colors.white,
      ),
    );
  }

  void registerCurrentUserData(int subjectId) {
    Subject subject = Subject(id: subjectId);
    final getIt = GetIt.instance;
    getIt.allowReassignment = true;
    getIt.registerSingletonAsync<Subject>(() => Future.value(subject));
  }
}
