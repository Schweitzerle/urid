
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../models/taskCounterService.dart';
import '../../../models/taskTimer.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../../widgets/pass/view/pass_widget.dart';

class VolumeButtonTaskIDIntro extends StatefulWidget {
  @override
  _VolumeButtonTaskIDIntroState createState() =>
      _VolumeButtonTaskIDIntroState();
}

class _VolumeButtonTaskIDIntroState extends State<VolumeButtonTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskCounterService taskCounterService = GetIt.instance.get<TaskCounterService>();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/volume.mp4')
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
                          Strings.volumeTaskTitle,
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
                              TextSpan(text: Strings.volumeTaskBody),
                              TextSpan(text: Strings.volumeTaskBodyBold, style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: Strings.volumeTaskBodyPostfix),
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
                return VolumeButtonTaskIDPass();
              }),
            );
          },
        ),
      ),
    );
  }
}

class VolumeTaskIDOverview extends StatefulWidget {
  @override
  _VolumeTaskIDOverviewState createState() => _VolumeTaskIDOverviewState();
}

class _VolumeTaskIDOverviewState extends State<VolumeTaskIDOverview> {
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
                                Strings.volumeTaskTitle,
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
                                    TextSpan(text: Strings.volumeTaskOverview, style: TextStyle(fontStyle: FontStyle.italic)),
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
  bool showHiddenProperties = true;
  bool gestureEnabled = true;
  late CounterService counterService;
  final TaskTimer taskTimer = GetIt.instance.get<TaskTimer>();
  final Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    counterService = GetIt.instance.get<CounterService>();
    _initializeVolumeController();
    taskTimer.startTask('Volume', counterService.counter);
    stopwatch.start();
  }

  Future<void> _initializeVolumeController() async {
    VolumeController().setVolume(.1, showSystemUI: false);
    await Future.delayed(Duration(seconds: 1));

    VolumeController().listener((volume) {
      if (gestureEnabled) {
        if (volume == 1) {
          setState(() {
            showHiddenProperties = false;
          });
        } else if (volume == 0) {
          setState(() {
            if (!showHiddenProperties) {
              showHiddenProperties = true;
              stopwatch.stop();
              _stopTask();
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

  void _stopTask() {
    stopwatch.stop();
    taskTimer.endTask('Volume', counterService.counter, stopwatch.elapsed);
    print('${taskTimer.getTaskDuration('Volume', counterService.counter)} duration: ${stopwatch.elapsed.inMilliseconds}ms');
    _handleResetCounter();
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print('Reset Counter: $resetCounter');
    if (resetCounter == 3) {
      setState(() {
        gestureEnabled = false;
      });
      CountdownDialog.showCountdownDialog(context, 10, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return VolumeButtonTaskIDQuestionnaire();
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
            return VolumeTaskIDOverview();
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
            child: RotationTransition(
              turns: !showHiddenProperties
                  ? AlwaysStoppedAnimation(180 / 360)
                  : AlwaysStoppedAnimation(0 / 360),
              child: PassWidget(
                pass: DummyData.erikaMusterfrauPassObject(),
                showHiddenProperties: showHiddenProperties, passType: PassType.volume,
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
    return AgencyQuestionnaireWidget(
      taskType: TaskType.volumeButton,
      taskAssigningService: taskAssigningService,
    );
  }
}
