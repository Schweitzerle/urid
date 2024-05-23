import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/pass_widget_volume_button.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../taskOverview/taskOverview.dart';

class VolumeButtonTaskIDIntro extends StatefulWidget {
  @override
  _VolumeButtonTaskIDIntroState createState() =>
      _VolumeButtonTaskIDIntroState();
}
class _VolumeButtonTaskIDIntroState extends State<VolumeButtonTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Center(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: Strings.volumeTaskTitle,
                bodyWidget: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.volumeTaskBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                image: Center(
                    child: Lottie.asset('assets/animations/press_button.json')),
                decoration: const PageDecoration(
                  bodyFlex: 5,
                  imageFlex: 3,
                  bodyAlignment: Alignment.topCenter,
                  imageAlignment: Alignment.center,
                  imagePadding: EdgeInsets.all(8),
                ),
              ),
              PageViewModel(
                title: Strings.nextStepAutoTitle,
                bodyWidget: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.nextStepAutoBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                image: Center(
                    child: Lottie.asset('assets/animations/study.json')),
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
                image: Center(
                    child: Lottie.asset('assets/animations/start.json')),
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
                  return VolumeButtonTaskIDPass();
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}


class VolumeButtonTaskIDPass extends StatefulWidget {
  @override
  _VolumeButtonTaskIDPassState createState() => _VolumeButtonTaskIDPassState();
}
class _VolumeButtonTaskIDPassState extends State<VolumeButtonTaskIDPass> {
  bool showFloatingButton = false;
  bool showHiddenProperties = false;
  bool gestureEnabled = true;
  late CounterService counterService;

  @override
  void initState() {
    super.initState();
    counterService = GetIt.instance.get<CounterService>();
    _initializeVolumeController();
  }

  void _initializeVolumeController() {
    VolumeController().listener((volume) {
      if (gestureEnabled) {
        if (volume == 1) {
          setState(() {
            showHiddenProperties = true;
          });
        } else if (volume == 0) {
          setState(() {
            if (showHiddenProperties) {
              showHiddenProperties = false;
              _handleResetCounter();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print('Reset Counter: $resetCounter');
    if (resetCounter == 3) {
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return VolumeButtonTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
        setState(() {
          gestureEnabled = true;
        });
      });
    } else if (resetCounter < 3) {
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return VolumeButtonTaskIDIntro();
          }),
        );
        setState(() {
          gestureEnabled = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showFloatingButton
          ? FloatingActionButton(
          child: const Icon(Icons.navigate_next, size: 28),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return VolumeButtonTaskIDQuestionnaire();
              }),
            );
          })
          : null,
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  showFloatingButton = true;
                });
              },
              child: RotationTransition(
                turns: showHiddenProperties
                    ? AlwaysStoppedAnimation(180 / 360)
                    : AlwaysStoppedAnimation(0 / 360),
                child: PassWidgetVolumeButton(
                  pass: DummyData.erikaMusterfrauPassObject(),
                  showHiddenProperties: showHiddenProperties,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VolumeButtonTaskIDQuestionnaire extends StatefulWidget {
  @override
  _VolumeButtonTaskIDQuestionnaireState createState() =>
      _VolumeButtonTaskIDQuestionnaireState();
}
class _VolumeButtonTaskIDQuestionnaireState
    extends State<VolumeButtonTaskIDQuestionnaire> {
  late TaskAssigningService taskAssigningService;

  @override
  void initState() {
    taskAssigningService = GetIt.instance.get<TaskAssigningService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AgencyQuestionnaireWidget(taskType: TaskType.holdButton, taskAssigningService: taskAssigningService,);
  }
}
