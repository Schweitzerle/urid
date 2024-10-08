import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/widgets/pass/view/pass_widget.dart';
import 'package:video_player/video_player.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../models/taskCounterService.dart';
import '../../../models/taskTimer.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import 'package:flutter/cupertino.dart';

//Screen um die Geste und den Ablauf dieser Task zu erklären
class ButtonTaskIDIntro extends StatefulWidget {
  @override
  _ButtonTaskIDIntroState createState() => _ButtonTaskIDIntroState();
}
class _ButtonTaskIDIntroState extends State<ButtonTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskCounterService taskCounterService = GetIt.instance.get<TaskCounterService>();
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
      appBar: AppBar(title: Text('Task ${taskCounterService.taskCounter}',), backgroundColor: Theme.of(context).colorScheme.primaryContainer, automaticallyImplyLeading: false,),
      body: CustomWillPopScopeWidget(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: Card(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      Strings.buttonTaskTitle,
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
                          TextSpan(text: Strings.buttonTaskBody),
                          TextSpan(text: Strings.buttonTaskBodyBold, style: TextStyle(fontWeight: FontWeight.bold)),
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
          done: Text(Strings.finished),
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
    );
  }
}

//Klasse um zwischen den Ausführungen der Taskwiederholungen dem Nutzern nochmal kurz erklärt, was er zu tun hat
class ButtonTaskIDOverview extends StatefulWidget {
  @override
  _ButtonTaskIDOverviewState createState() => _ButtonTaskIDOverviewState();
}
class _ButtonTaskIDOverviewState extends State<ButtonTaskIDOverview> {
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
                                Strings.buttonTaskTitle,
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
                                    TextSpan(text: Strings.buttonTaskOverview, style: TextStyle(fontStyle: FontStyle.italic)),
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

//Klasse mit dem digitalen Ausweis und der eigentlichen Task
class ButtonTaskIDPass extends StatefulWidget {
  @override
  _ButtonTaskIDPassState createState() => _ButtonTaskIDPassState();
}
class _ButtonTaskIDPassState extends State<ButtonTaskIDPass> {
  //Variablen, um Zustand zu verwalten, ob Finger auf dem Bildschirm liegt
  bool showHiddenProperties = true;
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
            return ButtonTaskIDQuestionnaire();
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
            return ButtonTaskIDOverview();
          }),
        );
      });
    }
  }

  void _stopTask() {
    stopwatch.stop();
    taskTimer.endTask('Button', counterService.counter, stopwatch.elapsed);
    print('${taskTimer.getTaskDuration('Button', counterService.counter)} duration: ${stopwatch.elapsed.inMilliseconds}ms');
    _handleResetCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: GestureDetector(
              onTapDown: (details) { //Bei Erkennung von Finger-Press auf dem Bilschirm wird die öffentliche Ansicht angezeigt
                if (gestureEnabled) {
                  setState(() {
                    showHiddenProperties = false;
                  });
                }
              },
              onTapUp: (details) { //Bei Erkennung von Finger-Press weg von Bilschirm wird die private Ansicht angezeigt

                if (gestureEnabled) {
                  setState(() {
                    if (!showHiddenProperties) {
                      showHiddenProperties = true;
                      _stopTask();
                    }
                  });
                }
              },
              onVerticalDragEnd: (details) { //Bei Erkennung von Finger-Press, welcher vertikal swiped auf dem Bilschirm wird die private Ansicht angezeigt

                if (gestureEnabled) {
                  setState(() {
                    if (!showHiddenProperties) {
                      showHiddenProperties = true;
                      _stopTask();
                    }
                  });
                }
              },
              onHorizontalDragEnd: (details) { //Bei Erkennung von Finger-Press, welcher horizontal swiped auf dem Bilschirm wird die private Ansicht angezeigt

                if (gestureEnabled) {
                  setState(() {
                    if (!showHiddenProperties) {
                      showHiddenProperties = true;
                      _stopTask();
                    }
                  });
                }
              },
              child: RotationTransition( //180° Drehung des Ausweisen in öffentlicher Ansicht
              turns: !showHiddenProperties
                    ? AlwaysStoppedAnimation(180 / 360)
                    : AlwaysStoppedAnimation(0 / 360),
                child: PassWidget(
                  pass: DummyData.erikaMusterfrauPassObject(),
                  showHiddenProperties: showHiddenProperties, passType: PassType.button,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Klasse um den Agency-Questionnaire anzuzeigen
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
