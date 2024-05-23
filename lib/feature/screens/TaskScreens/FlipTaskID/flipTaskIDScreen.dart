import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import 'package:urid/feature/screens/taskOverview/taskOverview.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/pass_widget_flip.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';

class FlipTaskIDIntro extends StatefulWidget {
  @override
  _FlipTaskIDIntroState createState() => _FlipTaskIDIntroState();
}

class _FlipTaskIDIntroState extends State<FlipTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Center(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: Strings.flipTaskTitle,
                bodyWidget: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.flipTaskBody,
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
                  return FlipTaskIDPass();
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FlipTaskIDPass extends StatefulWidget {
  @override
  _FlipTaskIDPassState createState() => _FlipTaskIDPassState();
}

class _FlipTaskIDPassState extends State<FlipTaskIDPass> {
  bool showFloatingButton = false;
  bool showHiddenProperties = false;
  bool gestureEnabled = true;

  late CounterService counterService;

  Duration sensorInterval = SensorInterval.uiInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    counterService = GetIt.instance.get<CounterService>();
    _startGyroscopeListener();
  }

  void _startGyroscopeListener() {
    _streamSubscriptions.add(
        gyroscopeEventStream(samplingPeriod: sensorInterval)
            .listen((GyroscopeEvent event) {
      if (gestureEnabled) {
        if (event.x > 2.0) {
          setState(() {
            if (showHiddenProperties) {
              showHiddenProperties = false;
              _handleResetCounter();
            }
          });
        } else if (event.x < -2.0) {
          setState(() {
            showHiddenProperties = true;
          });
        }
      }
    }));
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter >= 3) {
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FlipTaskIDQuestionnaire();
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
            return FlipTaskIDIntro();
          }),
        );
        setState(() {
          gestureEnabled = true;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FlipTaskIDQuestionnaire();
                    }),
                  );
                })
            : null,
        body: CustomWillPopScopeWidget(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: RotationTransition(
              turns: showHiddenProperties
                  ? AlwaysStoppedAnimation(180 / 360)
                  : AlwaysStoppedAnimation(0 / 360),
              child: PassWidgetFlip(
                pass: DummyData.erikaMusterfrauPassObject(),
                showHiddenProperties: showHiddenProperties,
              ),
            )),
          ),
        ),
      ),
    );
  }
}

class FlipTaskIDQuestionnaire extends StatefulWidget {
  @override
  _FlipTaskIDQuestionnaireState createState() =>
      _FlipTaskIDQuestionnaireState();
}

class _FlipTaskIDQuestionnaireState extends State<FlipTaskIDQuestionnaire> {
  late TaskAssigningService taskAssigningService;

  @override
  void initState() {
    taskAssigningService = GetIt.instance.get<TaskAssigningService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AgencyQuestionnaireWidget(taskType: TaskType.flipPhone, taskAssigningService: taskAssigningService,);
  }
}
