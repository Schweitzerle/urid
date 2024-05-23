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
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../taskOverview/taskOverview.dart';
import '../ButtonTaskID/buttonTaskIDScreen.dart';

class CoverTaskIDIntro extends StatefulWidget {
  @override
  _CoverTaskIDIntroState createState() => _CoverTaskIDIntroState();
}

class _CoverTaskIDIntroState extends State<CoverTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Center(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: Strings.coverTaskTitle,
                bodyWidget: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.coverTaskBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                image: Center(
                    child: Lottie.asset('assets/animations/handCover.json')),
                decoration: const PageDecoration(
                  bodyFlex: 5,
                  imageFlex: 3,
                  bodyAlignment: Alignment.topCenter,
                  imageAlignment: Alignment.center,
                  imagePadding: EdgeInsets.all(8),
                ),
              ),
              PageViewModel(
                title: Strings.nextStepTitle,
                bodyWidget: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.nextStepBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
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
                title: Strings.questionnaireTitle,
                image: Center(child: Lottie.asset('assets/animations/start.json')),
                bodyWidget: Column(
                  children: [
                    Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Strings.questionnaireTaskBody,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        )),
                    SizedBox(height: 20,),
                    Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            counterService.counter <= 0 ? 'Noch 3 Wiederholungen!' : counterService.counter == 1 ? 'Noch 2 Wiederholungen!' : counterService.counter >= 2 ? 'Noch 1 Wiederholung!' : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        )),

                  ],
                ),
                decoration: const PageDecoration(
                  bodyFlex: 5,
                  imageFlex: 3,
                  bodyAlignment: Alignment.topCenter,
                  imagePadding: EdgeInsets.all(8),
                ),
              ),
            ],
            showNextButton: false,
            done: const Text("Fertig"),
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
  final CounterService counterService = GetIt.instance.get<CounterService>();

  @override
  void initState() {
    super.initState();
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter >= 3) {
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CoverTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CoverTaskIDIntro();
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          showFloatingButton = true;
        });
      },
      child: Scaffold(
        floatingActionButton: showFloatingButton
            ? FloatingActionButton(
                child: const Icon(Icons.navigate_next, size: 28),
                onPressed: () {
                  _handleResetCounter();
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
    return AgencyQuestionnaireWidget(taskType: TaskType.coverPhone, taskAssigningService: taskAssigningService,);
  }
}
