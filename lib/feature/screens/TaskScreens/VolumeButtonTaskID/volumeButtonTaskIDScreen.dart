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
      CountdownDialog.showCountdownDialog(context, 15, () {
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
      CountdownDialog.showCountdownDialog(context, 15, () {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            switch (taskAssigningService.task) {
              case 1:
                return FlipTaskIDIntro();
              case 2:
                //TODO: screen nach allen vier gesten
                return TaskOverviewScreen();
              case 3:
                return ButtonTaskIDIntro();
              case 4:
                return CoverTaskIDIntro();
              default:
                return const TaskOverviewScreen();
            }
          }));
        },
      ),
      body: CustomWillPopScopeWidget(
          child: AgencyQuestionnaireWidget(taskType: TaskType.holdButton)),
    );
  }
}
