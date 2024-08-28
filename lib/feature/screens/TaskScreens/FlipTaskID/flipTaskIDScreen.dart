import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:video_player/video_player.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../models/taskCounterService.dart';
import '../../../models/taskTimer.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../../widgets/pass/view/pass_widget.dart';

//Screen um die Geste und den Ablauf dieser Task zu erklären
class FlipTaskIDIntro extends StatefulWidget {
  @override
  _FlipTaskIDIntroState createState() => _FlipTaskIDIntroState();
}
class _FlipTaskIDIntroState extends State<FlipTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskCounterService taskCounterService = GetIt.instance.get<TaskCounterService>();
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
      appBar: AppBar(title: Text('Task ${taskCounterService.taskCounter}',), backgroundColor: Theme.of(context).colorScheme.primaryContainer, automaticallyImplyLeading: false,),
      body: CustomWillPopScopeWidget(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          Strings.flipTaskTitle,
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black
                            ),
                            children: <TextSpan>[
                              TextSpan(text: Strings.flipTaskBody),
                              TextSpan(text: Strings.flipTaskBodyBold, style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: Strings.flipTaskBodyPostfix),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              decoration: const PageDecoration(
                  titlePadding: EdgeInsets.zero
              ),
            ),
            PageViewModel(
              title: Strings.tutorial,
              bodyWidget: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(
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
              ),
              decoration: const PageDecoration(
                  titlePadding: EdgeInsets.zero
              ),
            ),
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          Strings.nextStepTitle,
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          Strings.nextStepAutoBody,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )),
              decoration: const PageDecoration(
                  titlePadding: EdgeInsets.zero
              ),
            ),
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: Column(
                children: [
                  Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              Strings.questionnaireTitle,
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              Strings.questionnaireTaskBody,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 18),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
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
                                        ? Strings.repetitionsLeft
                                        : counterService.counter == 1
                                        ? Strings.twoRepetitionsLeft
                                        : counterService.counter >= 2
                                        ? Strings.oneRepetitionLeft
                                        : '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),

                ],
              ),
              decoration: const PageDecoration(
                  titlePadding: EdgeInsets.zero
              ),
            ),
          ],
          showNextButton: false,
          done: const Text(Strings.finished),
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
    );
  }
}

//Klasse um zwischen den Ausführungen der Taskwiederholungen dem Nutzern nochmal kurz erklärt, was er zu tun hat
class FlipTaskIDOverview extends StatefulWidget {
  @override
  _FlipTaskIDOverviewState createState() => _FlipTaskIDOverviewState();
}
class _FlipTaskIDOverviewState extends State<FlipTaskIDOverview> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskCounterService taskCounterService = GetIt.instance.get<TaskCounterService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task ${taskCounterService.taskCounter}',), backgroundColor: Theme.of(context).colorScheme.primaryContainer, automaticallyImplyLeading: false,),
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                titleWidget: Container(),
                bodyWidget: Column(
                  children: [
                    Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                Strings.flipTaskTitle,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              RichText(
                                textAlign: TextAlign.start,
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: Strings.taskOverviewPrefix),
                                    TextSpan(text: Strings.flipTaskOverview, style: TextStyle(fontStyle: FontStyle.italic)),
                                    TextSpan(text: Strings.taskOverviewPostfix),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
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
                                          ? Strings.repetitionsLeft
                                          : counterService.counter == 1
                                          ? Strings.twoRepetitionsLeft
                                          : counterService.counter >= 2
                                          ? Strings.oneRepetitionLeft
                                          : '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                decoration: const PageDecoration(
                    titlePadding: EdgeInsets.zero
                ),
              ),
            ],
            showNextButton: false,
            done: const Text(Strings.finished),
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

//Klasse mit dem digitalen Ausweis und der eigentlichen Task
class FlipTaskIDPass extends StatefulWidget {
  @override
  _FlipTaskIDPassState createState() => _FlipTaskIDPassState();
}
class _FlipTaskIDPassState extends State<FlipTaskIDPass> {
  //Variablen, um Zustand zu verwalten, ob Finger auf dem Bildschirm liegt
  bool showHiddenProperties = true;
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

  void _stopTask() {
    stopwatch.stop();
    taskTimer.endTask('Flip', counterService.counter, stopwatch.elapsed);
    print('${taskTimer.getTaskDuration('Flip', counterService.counter)} duration: ${stopwatch.elapsed.inMilliseconds}ms');
    _handleResetCounter();
  }

  //Listener um den Zustand des Gyroskops abuzfangen
  void _startGyroscopeListener() {
    _streamSubscriptions.add(
        gyroscopeEventStream(samplingPeriod: sensorInterval)
            .listen((GyroscopeEvent event) {
          if (gestureEnabled) {
            if (event.x > 3.0) { //Wenn Gyroskop veränderung um +3 auf der x-Achse wahrnimmt, wird die öffentliche Ansicht gezeigt
              setState(() {
                if (!showHiddenProperties) {
                  showHiddenProperties = true;
                 _stopTask();
                }
              });
            }
            else if (event.x < -3.0) { //Wenn Gyroskop veränderung um -3 auf der x-Achse wahrnimmt, wird die private Ansicht gezeigt
              setState(() {
                showHiddenProperties = false;
              });
            }
          }
        }));
  }

  //Wiedrholungscounter händeln
  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter >= 3) {
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 10, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FlipTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 10, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return FlipTaskIDOverview();
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
          child: RotationTransition( //180° Drehung des Ausweisen in öffentlicher Ansicht
          turns: !showHiddenProperties
                    ? AlwaysStoppedAnimation(180 / 360)
                    : AlwaysStoppedAnimation(0 / 360),
                child: PassWidget(
                  pass: DummyData.erikaMusterfrauPassObject(),
                  showHiddenProperties: showHiddenProperties, passType: PassType.flip,
                ),
              )),
        ),
      ),
    );
  }
}

//Klasse um den Agency-Questionnaire anzuzeigen
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
