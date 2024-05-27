import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/pass_widget_button.dart';
import 'package:video_player/video_player.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../models/taskTimer.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import 'package:flutter/cupertino.dart';

class ButtonTaskIDIntro extends StatefulWidget {
  @override
  _ButtonTaskIDIntroState createState() => _ButtonTaskIDIntroState();
}

class _ButtonTaskIDIntroState extends State<ButtonTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/hold.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
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
                  child: _controller.value.isInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
                decoration: const PageDecoration(
                  bodyFlex: 7,
                  imageFlex: 5,
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
                image: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
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
                image:
                    Center(child: Lottie.asset('assets/animations/start.json')),
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
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.repeat,
                              size: 24,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 8),
                            Text(
                              counterService.counter <= 0
                                  ? 'Noch 3 Wiederholungen!'
                                  : counterService.counter == 1
                                  ? 'Noch 2 Wiederholungen!'
                                  : counterService.counter >= 2
                                  ? 'Noch 1 Wiederholung!'
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
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
  bool showHiddenProperties = false;
  bool gestureEnabled = true;
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskTimer taskTimer = GetIt.instance.get<TaskTimer>();
  final Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    taskTimer.startTask('Button', counterService.counter);
    stopwatch.start();
  }

  //TODO: Dialog Countdown wieder auf 15 bzw. 60 Sekunden setzten / im moment nur für Testzwecke so niedrig
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
      CountdownDialog.showCountdownDialog(context, 1, () {
        gestureEnabled = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return ButtonTaskIDIntro();
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
              child: GestureDetector(
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
                    stopwatch.stop();
                    taskTimer.endTask('Button', counterService.counter, stopwatch.elapsed);
                    taskTimer.getAllTaskDurations().forEach((taskName, durations) {
                      for (int i = 0; i < durations.length; i++) {
                        print('$taskName-${i + 1} duration: ${durations[i].inMilliseconds}ms');
                      }
                    });
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
    return AgencyQuestionnaireWidget(
      taskType: TaskType.holdButton,
      taskAssigningService: taskAssigningService,
    );
  }
}
