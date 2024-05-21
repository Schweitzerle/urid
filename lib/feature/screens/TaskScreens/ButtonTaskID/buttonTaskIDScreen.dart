import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/widgets/pass/pass.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/pass_widget_button.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../taskOverview/taskOverview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:get_it/get_it.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';


class ButtonTaskIDIntro extends StatefulWidget {
  @override
  _ButtonTaskIDIntroState createState() => _ButtonTaskIDIntroState();
}

class _ButtonTaskIDIntroState extends State<ButtonTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Center(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: Strings.buttonTaskTitle,
                bodyWidget: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.buttonTaskBody,
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
                  return ButtonTaskIDPass();
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonTaskIDPass extends StatefulWidget {
  @override
  _ButtonTaskIDPassState createState() => _ButtonTaskIDPassState();
}

class _ButtonTaskIDPassState extends State<ButtonTaskIDPass> {
  bool showFloatingButton = false;
  bool showHiddenProperties = false;
  bool gestureEnabled = true;
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
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 15, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return ButtonTaskIDQuestionnaire();
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
      CountdownDialog.showCountdownDialog(context, 15, () {
        gestureEnabled = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return ButtonTaskIDIntro();
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
                    return ButtonTaskIDQuestionnaire();
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
            onTapDown: (details) {
              if (gestureEnabled) {
                setState(() {
                  showHiddenProperties = true;
                });
              }
            },
            onTapUp: (details) {
              if (gestureEnabled) {
                setState(() {
                  if (showHiddenProperties) {
                    showHiddenProperties = false;
                    _handleResetCounter();
                  }
                });
              }
            },
            onVerticalDragEnd: (details) {
              if (gestureEnabled) {
                setState(() {
                  if (showHiddenProperties) {
                    showHiddenProperties = false;
                    _handleResetCounter();
                  }
                });
              }
            },
            onHorizontalDragEnd: (details) {
              if (gestureEnabled) {
                setState(() {
                  if (showHiddenProperties) {
                    showHiddenProperties = false;
                    _handleResetCounter();
                  }
                });
              }
            },
            child: RotationTransition(
              turns: showHiddenProperties
                  ? AlwaysStoppedAnimation(180 / 360)
                  : AlwaysStoppedAnimation(0 / 360),
              child: PassWidgetButton(
                pass: DummyData.erikaMusterfrauPassObject(),
                showHiddenProperties: showHiddenProperties,
              ),
            ),
          )),
        ),
      ),
    );
  }
}

class ButtonTaskIDQuestionnaire extends StatefulWidget {
  @override
  _ButtonTaskIDQuestionnaireState createState() =>
      _ButtonTaskIDQuestionnaireState();
}

class _ButtonTaskIDQuestionnaireState extends State<ButtonTaskIDQuestionnaire> {
  late TaskAssigningService taskAssigningService;

  @override
  void initState() {
    taskAssigningService = GetIt.instance.get<TaskAssigningService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CountdownDialog.showCountdownDialog(context, 60, () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  switch (taskAssigningService.task) {
                    case 1:
                      return VolumeButtonTaskIDIntro();
                    case 2:
                      return FlipTaskIDIntro();
                    case 3:
                      return CoverTaskIDIntro();
                    case 4:
                    //TODO: screen nach allen vier gesten
                      return TaskOverviewScreen();
                    default:
                      return const TaskOverviewScreen();
                  }
                }));
          });
        },
      ),
      body: CustomWillPopScopeWidget(
          child: AgencyQuestionnaireWidget(taskType: TaskType.holdButton)),
    );
  }
}
