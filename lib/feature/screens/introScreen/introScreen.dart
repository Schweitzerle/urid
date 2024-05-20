import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import '../../models/subject.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});


  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController subjectIDTextController = TextEditingController(text: '18'); //Später User selbst eingeben
  late TaskAssigningService taskAssigningService;

  @override
  void initState() {
    taskAssigningService = GetIt.instance.get<TaskAssigningService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: introSliderPages()
    );
  }

  @override
  void dispose() {
    subjectIDTextController.dispose();
    super.dispose();
  }

  Widget introSliderPages() {
    return CustomWillPopScopeWidget(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Wilkommen zu meiner Studie",
            body: "Vielen Dank, dass du an meiner Studie teilnimmst. Im Folgenden wird dir nochmal der Studienablauf erklärt und deine Aufgaben. Viel Spas bei der Studie!",
            image: Center(child: Lottie.asset('assets/animations/study.json')),
          ),
          PageViewModel(
            title: "Studienablauf",
            body: "Im Verlauf der Studie wirst du einen digitalen Mitarbeiterausweis der Universität Regensburg benutzen....Task startet immer in privater Ansciht und aufgabe ist es in die öffentliche zu gehene(bwusste informationsfreigabe) durch interaktionsgesten, 3x wiederholen.",
            image: Center(child: Lottie.asset('assets/animations/study2.json')),
          ),
          PageViewModel(
            title: "Probanden ID",
            image: Center(child: Lottie.asset('assets/animations/study2.json')),
            bodyWidget: Column(
              children: [
                Text("Trage hier bitte die Probanden ID ein, welche du vom Versuchsleiter gesagt bekommst."),
                TextField(
                  controller: subjectIDTextController,
                  decoration: InputDecoration(labelText: "Probanden ID"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],

                ),
              ],
            ),
          )
        ],
        showNextButton: false,
        done: const Text("Done"),
        onDone: () {
          registerCurrentUserData(int.parse(subjectIDTextController.text));
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
      ),
    );
  }

  void registerCurrentUserData(int subjectId) {
    Subject subject = Subject(id: subjectId);
    final getIt = GetIt.instance;
    getIt.allowReassignment = true;
    getIt.registerSingletonAsync<Subject>(() => Future.value(subject),
    );  }

}
