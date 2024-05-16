import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/widgets/pass/pass.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/pass_widget_button.dart';
import '../../../models/counterService.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';

class ButtonTaskIDIntro extends StatefulWidget {
  @override
  _ButtonTaskIDIntroState createState() => _ButtonTaskIDIntroState();
}

class _ButtonTaskIDIntroState extends State<ButtonTaskIDIntro> {
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
                image: Center(
                    child: Lottie.asset('assets/animations/study.json')),
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
  late CounterService counterService;

  @override
  void initState() {
    counterService = GetIt.instance.get<CounterService>();
    super.initState();
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
          return ButtonTaskIDQuestionnaire();
        }),
      );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      _showCountdownDialog(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return ButtonTaskIDIntro();
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
        floatingActionButton: showFloatingButton ?
        FloatingActionButton(
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
                    setState(() {
                      showHiddenProperties = true;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      if (showHiddenProperties) {
                        showHiddenProperties = false;
                        _handleResetCounter();
                      }
                    });
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      if (showHiddenProperties) {
                        showHiddenProperties = false;
                        _handleResetCounter();
                      }
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (showHiddenProperties) {
                      showHiddenProperties = false;
                      _handleResetCounter();
                    }
                  },
                  child: RotationTransition(
                    turns: showHiddenProperties ? AlwaysStoppedAnimation(180/360) : AlwaysStoppedAnimation(0/360),
                    child: PassWidgetButton(
                                  pass: DummyData.erikaMusterfrauPassObject(), showHiddenProperties: showHiddenProperties,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        //TODO: Screen dazwischen schalten, welcher aus der id den nächsten Task nach LatingSquare entnimmt, auch pause dazwischen
        Navigator.pop(context, true);
      },
      ),
      body: CustomWillPopScopeWidget(
        child: AgencyQuestionnaireWidget(taskType: TaskType.holdButton)
      ),
    );
  }
}
