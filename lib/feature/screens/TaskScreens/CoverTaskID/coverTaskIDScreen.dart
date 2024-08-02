import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/models/taskCounterService.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaireWidget.dart';
import 'package:urid/feature/widgets/pass/pass.dart';
import 'package:video_player/video_player.dart';
import '../../../models/counterService.dart';
import '../../../models/strings.dart';
import '../../../models/taskAssigningService.dart';
import '../../../models/taskTimer.dart';
import '../../../widgets/countdownDialog.dart';
import '../../../widgets/customWillPopScope.dart';
import '../../../widgets/pass/view/pass_widget.dart';

class CoverTaskIDIntro extends StatefulWidget {
  @override
  _CoverTaskIDIntroState createState() => _CoverTaskIDIntroState();
}

class _CoverTaskIDIntroState extends State<CoverTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskCounterService taskCounterService =
      GetIt.instance.get<TaskCounterService>();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/cover.mp4')
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
      appBar: AppBar(
        title: Text(
          'Task ${taskCounterService.taskCounter}',
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
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
                    Text(
                      Strings.coverTaskTitle,
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
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: Strings.coverTaskBody),
                          TextSpan(
                              text: Strings.coverTaskBodyBold,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              decoration: const PageDecoration(titlePadding: EdgeInsets.zero),
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
              decoration: const PageDecoration(titlePadding: EdgeInsets.zero),
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
                      Strings.nextStepBody,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )),
              decoration: const PageDecoration(titlePadding: EdgeInsets.zero),
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
              decoration: const PageDecoration(titlePadding: EdgeInsets.zero),
            ),
          ],
          showNextButton: false,
          done: Text(Strings.finished),
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return CoverTaskIDPass();
              }),
            );
          },
        ),
      ),
    );
  }
}

class CoverTaskIDOverview extends StatefulWidget {
  @override
  _CoverTaskIDOverviewState createState() => _CoverTaskIDOverviewState();
}

class _CoverTaskIDOverviewState extends State<CoverTaskIDOverview> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskCounterService taskCounterService =
      GetIt.instance.get<TaskCounterService>();

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
      appBar: AppBar(
        title: Text(
          'Task ${taskCounterService.taskCounter}',
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
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
                            Strings.coverTaskTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(text: Strings.taskOverviewPrefix),
                                TextSpan(
                                    text: Strings.coverTaskOverview,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic)),
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
                decoration: const PageDecoration(titlePadding: EdgeInsets.zero),
              ),
            ],
            showNextButton: false,
            done: const Text(Strings.finished),
            onDone: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return CoverTaskIDPass();
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CoverTaskIDPass extends StatefulWidget {
  @override
  _CoverTaskIDPassState createState() => _CoverTaskIDPassState();
}

class _CoverTaskIDPassState extends State<CoverTaskIDPass> {
  bool showFloatingButton = false;
  final CounterService counterService = GetIt.instance.get<CounterService>();
  final TaskTimer taskTimer = GetIt.instance.get<TaskTimer>();
  final Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    taskTimer.startTask('Cover', counterService.counter);
    stopwatch.start();
  }

  void _stopTask() {
    stopwatch.stop();
    taskTimer.endTask('Cover', counterService.counter, stopwatch.elapsed);
    print('${taskTimer.getTaskDuration('Cover', counterService.counter)} duration: ${stopwatch.elapsed.inMilliseconds}ms');
    _handleResetCounter();
  }

  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter >= 3) {
      CountdownDialog.showCountdownDialog(context, 10, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CoverTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      CountdownDialog.showCountdownDialog(context, 10, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CoverTaskIDOverview();
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
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    child: Column(
                      children: [
                        const Icon(Icons.navigate_next, size: 28),
                        SizedBox(height: 2,),
                        FittedBox(child: Text(Strings.next)),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  stopwatch.stop();
                 _stopTask();
                })
            : null,
        body: CustomWillPopScopeWidget(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: PassWidgetCover(
              pass: DummyData.erikaMusterfrauPassObject(),
            )),
          ),
        ),
      ),
    );
  }
}

class CoverTaskIDQuestionnaire extends StatefulWidget {
  @override
  _CoverTaskIDQuestionnaireState createState() =>
      _CoverTaskIDQuestionnaireState();
}

class _CoverTaskIDQuestionnaireState extends State<CoverTaskIDQuestionnaire> {
  late TaskAssigningService taskAssigningService;

  @override
  void initState() {
    taskAssigningService = GetIt.instance.get<TaskAssigningService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AgencyQuestionnaireWidget(
      taskType: TaskType.coverPhone,
      taskAssigningService: taskAssigningService,
    );
  }
}
