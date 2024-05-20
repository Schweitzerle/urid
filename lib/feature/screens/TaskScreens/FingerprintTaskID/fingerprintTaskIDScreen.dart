import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/screens/TaskScreens/FingerprintTaskID/pass_widget_fingerprint.dart';
import '../../../models/counterService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';

import '../../../widgets/fingerprintDialog.dart';
import '../FlipTaskID/flipTaskIDScreen.dart';

class FingerprintTaskIDIntro extends StatefulWidget {
  @override
  _FingerprintTaskIDIntroState createState() => _FingerprintTaskIDIntroState();
}

class _FingerprintTaskIDIntroState extends State<FingerprintTaskIDIntro> {
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
                  return FingerprintTaskIDPass();
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}



class FingerprintTaskIDPass extends StatefulWidget {
  @override
  _FingerprintTaskIDPassState createState() => _FingerprintTaskIDPassState();
}

class _FingerprintTaskIDPassState extends State<FingerprintTaskIDPass> {
  bool showFloatingButton = false;
  bool showHiddenProperties = false;
  final LocalAuthentication auth = LocalAuthentication();
  late CounterService counterService;

  @override
  void initState() {
    counterService = GetIt.instance.get<CounterService>();
    super.initState();
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print('Reset Counter: $resetCounter');
    if (resetCounter >= 3) {
      CountdownDialog.showCountdownDialog(context, 15, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FingerprintTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else {
      CountdownDialog.showCountdownDialog(context, 15, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FingerprintTaskIDIntro();
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return FingerprintTaskIDQuestionnaire();
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
                child: PassWidgetFingerprint(
                  pass: DummyData.erikaMusterfrauPassObject(),
                  showHiddenProperties: showHiddenProperties,
                  onAuthenticate: () {
                    showFingerprintBottomSheet(context, (bool success) {
                      if (success) {
                        setState(() {
                          if (showHiddenProperties) {
                            showHiddenProperties = false;
                            _handleResetCounter();
                          } else {
                            showHiddenProperties = true;
                          }
                        });
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class FingerprintTaskIDQuestionnaire extends StatefulWidget {
  @override
  _FingerprintTaskIDQuestionnaireState createState() =>
      _FingerprintTaskIDQuestionnaireState();
}

class _FingerprintTaskIDQuestionnaireState
    extends State<FingerprintTaskIDQuestionnaire> {
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
          child: AgencyQuestionnaireWidget(taskType: TaskType.fingerprint)),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
