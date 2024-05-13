import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/widgets/pass/pass.dart';
import 'package:urid/feature/widgets/pass/view/pass_widget_button.dart';
import 'package:urid/feature/widgets/pass/view/pass_widget_fingerprint.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../../widgets/fingerprintDialog.dart';

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
                  /*
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FingerprintTaskIDQuestionnaire();
                  }),
                );
                 */
                  showFingerprintBottomSheet(context, (bool success) {
                    if (success) {
                      // Authentifizierung erfolgreich
                      // Führe die gewünschte Aktion aus
                    } else {
                      // Authentifizierung fehlgeschlagen
                      // Zeige eine Fehlermeldung oder führe alternative Aktionen aus
                    }
                  });
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
              ),
            )),
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
