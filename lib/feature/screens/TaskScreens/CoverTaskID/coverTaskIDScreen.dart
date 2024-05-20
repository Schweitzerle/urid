import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/widgets/pass/pass.dart';
import '../../../models/taskAssigningService.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../taskOverview/taskOverview.dart';
import '../ButtonTaskID/buttonTaskIDScreen.dart';

class CoverTaskIDIntro extends StatefulWidget {
  @override
  _CoverTaskIDIntroState createState() => _CoverTaskIDIntroState();
}

class _CoverTaskIDIntroState extends State<CoverTaskIDIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Center(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: "Bildschirm Abdecken",
                body:
                    "In dem folgenden Screen siehst du die private Ansicht des digitalen Mitarbeiterausweises. Deine Aufgabe ist es bewusst Informationen mit mir zu teilen. Dies Erfolgt durch das Abdecken des relevanten Teils des Bildschirms durch deine Hand. 3x Widerholen....",
                image: Center(
                    child: Lottie.asset('assets/animations/study.json')),
                footer: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Let's Go!"),
                ),
              ),
              PageViewModel(
                title: "Title of custom button page",
                body:
                    "This is a description on a page with a custom button below.",
                image: Container(
                    child: Center(
                        child: Lottie.asset('assets/animations/study2.json'))),
                footer: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Let's Go!"),
                ),
              )
            ],
            showNextButton: false,
            done: const Text("Done"),
            onDone: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return CoverTaskIDPass();
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CoverTaskIDPass extends StatefulWidget {
  @override
  _CoverTaskIDPassState createState() => _CoverTaskIDPassState();
}

class _CoverTaskIDPassState extends State<CoverTaskIDPass> {
  bool showFloatingButton = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          showFloatingButton = true;
        });
      },
      child: Scaffold(

        floatingActionButton: showFloatingButton ?
        FloatingActionButton(
          child: const Icon(Icons.navigate_next, size: 28),
            onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return CoverTaskIDQuestionnaire();
                  }),
                );
              })
            : null,
        body: CustomWillPopScopeWidget(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: PassWidgetCover(
              pass: DummyData.erikaMusterfrauPassObject(),
            )),
          ),
        ),
      ),
    );
  }
}

class CoverTaskIDQuestionnaire extends StatefulWidget {
  @override
  _CoverTaskIDQuestionnaireState createState() =>
      _CoverTaskIDQuestionnaireState();
}

class _CoverTaskIDQuestionnaireState extends State<CoverTaskIDQuestionnaire> {
  late TaskAssigningService taskAssigningService;

  @override
  void initState() {
    taskAssigningService = GetIt.instance.get<TaskAssigningService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
          switch (taskAssigningService.task) {
            case 1:
              return ButtonTaskIDIntro();
            case 2:
              return VolumeButtonTaskIDIntro();
            case 3:
              //TODO: screen nach allen vier gesten
              return TaskOverviewScreen();
            case 4:
              return FlipTaskIDIntro();
            default:
              return const TaskOverviewScreen();
          }
        }));
      },
      ),
      body: CustomWillPopScopeWidget(
        child: AgencyQuestionnaireWidget(taskType: TaskType.coverPhone)
      ),
    );
  }
}
