import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/pass_widget_flip.dart';
import '../../../models/counterService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';

class FlipTaskIDIntro extends StatefulWidget {
  @override
  _FlipTaskIDIntroState createState() => _FlipTaskIDIntroState();
}

class _FlipTaskIDIntroState extends State<FlipTaskIDIntro> {
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
                image:
                    Center(child: Lottie.asset('assets/animations/study.json')),
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
    }));
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter >= 3) {
      _showCountdownDialog(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FlipTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      _showCountdownDialog(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FlipTaskIDIntro();
          }),
        );
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

  Future<void> _showCountdownDialog(Function onCountdownComplete) async {
    int countdownSeconds = 15;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CountdownDialog(
          countdownSeconds: countdownSeconds,
          onCountdownComplete: onCountdownComplete,
        );
      },
    );
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Bestätigungsdialog
          Navigator.pop(context, true);
        },
      ),
      body: CustomWillPopScopeWidget(
          child: AgencyQuestionnaireWidget(taskType: TaskType.flipPhone)),
    );
  }
}
