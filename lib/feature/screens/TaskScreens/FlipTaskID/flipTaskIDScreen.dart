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
import 'package:video_player/video_player.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../models/taskTimer.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';

class FlipTaskIDIntro extends StatefulWidget {
  @override
  _FlipTaskIDIntroState createState() => _FlipTaskIDIntroState();
}

class _FlipTaskIDIntroState extends State<FlipTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/flip.mp4')
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
                  bodyFlex: 6,
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
                    const Card(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        Strings.questionnaireTaskBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                    const SizedBox(
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
  bool showHiddenProperties = false;
  bool gestureEnabled = true;
  late CounterService counterService;
  final TaskTimer taskTimer = GetIt.instance.get<TaskTimer>();
  final Stopwatch stopwatch = Stopwatch();
  Duration sensorInterval = SensorInterval.uiInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    counterService = GetIt.instance.get<CounterService>();
    _startGyroscopeListener();
    taskTimer.startTask('Flip', counterService.counter);
    stopwatch.start();
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
              stopwatch.stop();
              taskTimer.endTask('Flip', counterService.counter, stopwatch.elapsed);
              taskTimer.getAllTaskDurations().forEach((taskName, durations) {
                for (int i = 0; i < durations.length; i++) {
                  print('$taskName-${i + 1} duration: ${durations[i].inMilliseconds}ms');
                }
              });
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
    return Scaffold(
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
    return AgencyQuestionnaireWidget(
      taskType: TaskType.flipPhone,
      taskAssigningService: taskAssigningService,
    );
  }
}
