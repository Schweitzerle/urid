import 'dart:async';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/pass_widget_flip.dart';
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

  Duration sensorInterval = SensorInterval.uiInterval;
  double x = 0;
  double y = 0;
  double z = 0;
  String direction = "";

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _startGyroscopeListener();
  }

  void _startGyroscopeListener() {
    _streamSubscriptions.add(
        gyroscopeEventStream(samplingPeriod: sensorInterval)
            .listen((GyroscopeEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
        updateDirection();
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void updateDirection() {
    if (y > 2.0) {
      direction = "rechts";
    } else if (y < -1.0) {
      direction = "links";
    } else if (x > 1.0) {
      direction = "hinten ";
    } else if (x < -1.0) {
      direction = "vorne";
    } else if (z > 1.0) {
      direction = "setilich links runter";
    } else if (z < -1.0) {
      direction = "seitlich rechts runter";
    } else {
      direction = "Keine Neigung";
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 140,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                x.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                y.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                z.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                direction,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: RotationTransition(
                  turns: showHiddenProperties
                      ? AlwaysStoppedAnimation(180 / 360)
                      : AlwaysStoppedAnimation(0 / 360),
                  child: PassWidgetFlip(
                    pass: DummyData.erikaMusterfrauPassObject(),
                    showHiddenProperties: showHiddenProperties,
                  ),
                )),
              ],
            ),
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
