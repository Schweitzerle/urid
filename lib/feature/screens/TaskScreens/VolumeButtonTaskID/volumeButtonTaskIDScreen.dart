import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/pass_widget_volume_button.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../../models/counterService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';

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
  late CounterService counterService;

  @override
  void initState() {
    counterService = GetIt.instance.get<CounterService>();
    //TODO: Manchmal zeigt er trzdem noch SystemUI
    VolumeController().showSystemUI = false;
    VolumeController().setVolume(.1, showSystemUI: false);
    VolumeController().listener((volume) {
      if (volume == 1) {
        setState(() {
          showHiddenProperties = true;
        });
      } else if(volume == 0) {
        setState(() {
          if(showHiddenProperties) {
            showHiddenProperties = false;
            _handleResetCounter();
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter == 3) {
      _showCountdownDialog(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return VolumeButtonTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      _showCountdownDialog(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return VolumeButtonTaskIDIntro();
          }),
        );
      });
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
          )),
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
          child: AgencyQuestionnaireWidget(taskType: TaskType.holdButton)),
    );
  }
}
