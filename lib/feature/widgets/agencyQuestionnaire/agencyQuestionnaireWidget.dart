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
  final TaskCounterService taskCounterService = GetIt.instance.get<TaskCounterService>();
  final GetIt getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    agencyQuestionnaire = AgencyQuestionnaire(
      taskType: widget.taskType,
      movementAgencyQuestionValue: 4,
      agencyQuestionValue: 4,
      controlFeelingViewChangeQuestionValue: 4,
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

    CountdownDialog.showCountdownDialog(context, 2, () {
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
          agencyQuestionnaire.movementAgencyQuestionValue = value;
          break;
        case 2:
          agencyQuestionnaire.agencyQuestionValue = value;
          break;
        case 3:
          agencyQuestionnaire.controlFeelingViewChangeQuestionValue = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Text(
                Strings.questionnaireTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 30),
              Text(
                'Task: ${widget.taskType.toNiceString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: IntroductionScreen(
                  pages: _getPages(),
                  onDone: _onDone,
                  showSkipButton: false,
                  showNextButton: true,
                  showBackButton: false,
                  next: const Icon(Icons.arrow_forward),
                  done: const Text(Strings.finished, style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildCheckboxColumn(int questionIndex, int currentValue, String leftLabel, String rightLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(leftLabel, textAlign: TextAlign.center),
              SizedBox(height: 10),
              Column(
                children: List<Widget>.generate(7, (int index) {
                  return Column(
                    children: [
                      SizedBox(height: 1,),
                      RoundCheckBox(
                        isChecked: currentValue == (index + 1),
                        onTap: (selected) {
                          if (selected!) {
                            _updateQuestionValue(questionIndex, index + 1);
                          }
                        },
                      ),
                      SizedBox(height: 1,),
                    ],
                  );
                }),
              ),
              SizedBox(height: 10),
              Text(rightLabel, textAlign: TextAlign.center),
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
            _buildCheckboxColumn(1, agencyQuestionnaire.movementAgencyQuestionValue, Strings.stronglyDisagree, Strings.stronglyAgree),
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
            _buildCheckboxColumn(2, agencyQuestionnaire.agencyQuestionValue, Strings.veryLow, Strings.veryHigh),
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
            _buildCheckboxColumn(3, agencyQuestionnaire.controlFeelingViewChangeQuestionValue, Strings.notAtAll, Strings.completely),
          ],
        ),
      ),
    ];
  }

}
