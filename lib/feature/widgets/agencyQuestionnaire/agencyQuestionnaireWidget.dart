import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/screens/EndScreen/endScreen.dart';
import 'package:urid/feature/screens/ErrorScreen/errorScreen.dart';
import 'package:urid/feature/screens/interviewScreen/interviewScreen.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import '../../models/strings.dart';
import '../../models/taskCounterService.dart';
import '../../screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import '../../screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import '../../screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import '../../screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import '../countdownDialog.dart';

class AgencyQuestionnaireWidget extends StatefulWidget {
  final TaskType taskType;
  final TaskAssigningService taskAssigningService;

  const AgencyQuestionnaireWidget(
      {super.key, required this.taskType, required this.taskAssigningService});

  @override
  State<AgencyQuestionnaireWidget> createState() =>
      _AgencyQuestionnaireWidgetState();
}

class _AgencyQuestionnaireWidgetState extends State<AgencyQuestionnaireWidget> {
  late AgencyQuestionnaire agencyQuestionnaire;
  final TaskCounterService taskCounterService =
      GetIt.instance.get<TaskCounterService>();
  final GetIt getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    agencyQuestionnaire = AgencyQuestionnaire(
      taskType: widget.taskType,
      movementControlQuestionValue: 3,
      controlFeelingQuestionValue: 3,
      controlFeelingViewChangeQuestionValue: 3,
      taskAwarenessQuestionValue: 3,
      interactionFeedbackQuestionValue: 3,
      dataPrivacyQuestionValue: 3,
      controlOverSharedContentQuestionValue: 3,
    );
  }

  void _onDone() {
    final subject = getIt<Subject>();
    if (widget.taskType == TaskType.coverPhone) {
      subject.coverTaskQuestionnaire = agencyQuestionnaire;
    } else if (widget.taskType == TaskType.holdButton) {
      subject.buttonTaskQuestionnaire = agencyQuestionnaire;
    } else if (widget.taskType == TaskType.flipPhone) {
      subject.flipTaskQuestionnaire = agencyQuestionnaire;
    } else if (widget.taskType == TaskType.volumeButton) {
      subject.volumeTaskQuestionnaire = agencyQuestionnaire;
    }

    CountdownDialog.showCountdownDialog(context, 60, () {
      taskCounterService.incrementCounter();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        switch (widget.taskAssigningService.task) {
          case 1:
            if (widget.taskType == TaskType.coverPhone)
              return ButtonTaskIDIntro();
            else if (widget.taskType == TaskType.holdButton)
              return FlipTaskIDIntro();
            else if (widget.taskType == TaskType.flipPhone)
              return VolumeButtonTaskIDIntro();
            else
              return AudioRecorderScreen();
          case 2:
            if (widget.taskType == TaskType.coverPhone)
              return FlipTaskIDIntro();
            else if (widget.taskType == TaskType.holdButton)
              return VolumeButtonTaskIDIntro();
            else if (widget.taskType == TaskType.flipPhone)
              return AudioRecorderScreen();
            else
              return CoverTaskIDIntro();
          case 3:
            if (widget.taskType == TaskType.coverPhone)
              return AudioRecorderScreen();
            else if (widget.taskType == TaskType.holdButton)
              return CoverTaskIDIntro();
            else if (widget.taskType == TaskType.flipPhone)
              return ButtonTaskIDIntro();
            else
              return FlipTaskIDIntro();
          case 4:
            if (widget.taskType == TaskType.coverPhone)
              return VolumeButtonTaskIDIntro();
            else if (widget.taskType == TaskType.holdButton)
              return AudioRecorderScreen();
            else if (widget.taskType == TaskType.flipPhone)
              return CoverTaskIDIntro();
            else
              return ButtonTaskIDIntro();
          default:
            return ErrorScreen();
        }
      }));
    });
  }

  void _updateQuestionValue(int questionIndex, int value) {
    setState(() {
      switch (questionIndex) {
        case 1:
          agencyQuestionnaire.movementControlQuestionValue = value;
          break;
        case 2:
          agencyQuestionnaire.controlFeelingViewChangeQuestionValue = value;
          break;
        case 3:
          agencyQuestionnaire.controlFeelingQuestionValue = value;
        case 4:
          agencyQuestionnaire.taskAwarenessQuestionValue = value;
        case 5:
          agencyQuestionnaire.interactionFeedbackQuestionValue = value;
        case 6:
          agencyQuestionnaire.dataPrivacyQuestionValue = value;
        case 7:
          agencyQuestionnaire.controlOverSharedContentQuestionValue = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.questionnaireTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                'Task: ${widget.taskType.toNiceString()}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Expanded(
                child: IntroductionScreen(
                  pages: _getPages(),
                  onDone: _onDone,
                  showSkipButton: false,
                  showNextButton: true,
                  showBackButton: false,
                  next: const Icon(Icons.arrow_forward),
                  done: const Text(Strings.nextTask,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(
      int questionIndex,
      int currentValue,
      String leftLabel,
      String middleLabel,
      String rightLabel,
      String bottomLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(5, (int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RoundCheckBox(
                isChecked: currentValue == index + 1,
                onTap: (selected) {
                  if (selected!) {
                    _updateQuestionValue(questionIndex, index + 1);
                  }
                },
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                flex: 5,
                child: Text(
                  leftLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11),
                )),
            Expanded(
                flex: 3,
                child: SizedBox(
                  width: 20,
                )),
            Expanded(
                flex: 5,
                child: Text(
                  middleLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11),
                )),
            Expanded(
                flex: 3,
                child: SizedBox(
                  width: 20,
                )),
            Expanded(
                flex: 5,
                child: Text(
                  rightLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11),
                )),
          ],
        ),
        SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RoundCheckBox(
                isChecked: currentValue == -1,
                onTap: (selected) {
                  if (selected!) {
                    _updateQuestionValue(questionIndex, -1);
                  }
                },
              ),
              SizedBox(width: 10),
              Text(
                bottomLabel,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PageViewModel> _getPages() {
    return [
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.movementControlQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                1,
                agencyQuestionnaire.movementControlQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.viewChangeQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                2,
                agencyQuestionnaire.controlFeelingViewChangeQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.controlFeelingQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                3,
                agencyQuestionnaire.controlFeelingQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.taskAwarenessQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                4,
                agencyQuestionnaire.taskAwarenessQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.interactionFeedbackQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                5,
                agencyQuestionnaire.interactionFeedbackQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.dataPrivacyQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                6,
                agencyQuestionnaire.dataPrivacyQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.controlOverSharedContentQuestion,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            _buildCheckboxRow(
                7,
                agencyQuestionnaire.controlOverSharedContentQuestionValue,
                Strings.stronglyDisagree,
                Strings.neutral,
                Strings.stronglyAgree,
                Strings.cantJudgeLabel),
          ],
        ),
      ),
    ];
  }
}
