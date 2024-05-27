import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:urid/application/dummyData/dummy_data.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
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
import '../ButtonTaskID/buttonTaskIDScreen.dart';

class CoverTaskIDIntro extends StatefulWidget {
  @override
  _CoverTaskIDIntroState createState() => _CoverTaskIDIntroState();
}

class _CoverTaskIDIntroState extends State<CoverTaskIDIntro> {
  final CounterService counterService = GetIt.instance.get<CounterService>();
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
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: IntroductionScreen(
            pages: [
              PageViewModel(

                title: Strings.coverTaskTitle,
                bodyWidget: const Card(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    Strings.coverTaskBody,
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
                  bodyFlex: 5,
                  imageFlex: 3,
                  bodyAlignment: Alignment.topCenter,
                  imageAlignment: Alignment.center,
                  imagePadding: EdgeInsets.all(8),
                ),
              ),
              PageViewModel(
                title: Strings.nextStepTitle,
                bodyWidget: const Card(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    Strings.nextStepBody,
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
                            const Icon(
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

  //TODO: Dialog Countdown wieder auf 15 bzw. 60 Sekunden setzten / im moment nur für Testzwecke so niedrig
  void _handleResetCounter() {
    counterService.incrementCounter();
    int resetCounter = counterService.counter;
    print(resetCounter);
    if (resetCounter >= 3) {
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CoverTaskIDQuestionnaire();
          }),
        );
        counterService.resetCounter();
      });
    } else if (resetCounter < 3) {
      CountdownDialog.showCountdownDialog(context, 1, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CoverTaskIDIntro();
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
                  stopwatch.stop();
                  taskTimer.endTask('Cover', counterService.counter, stopwatch.elapsed);
                  taskTimer.getAllTaskDurations().forEach((taskName, durations) {
                    for (int i = 0; i < durations.length; i++) {
                      print('$taskName-${i + 1} duration: ${durations[i].inMilliseconds}ms');
                    }
                  });
                  _handleResetCounter();
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
