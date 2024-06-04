import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/screens/EndScreen/endScreen.dart';
import 'package:urid/feature/screens/interviewScreen/interviewScreen.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import '../../models/strings.dart';
import '../../screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import '../../screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import '../../screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import '../../screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import '../countdownDialog.dart';

class AgencyQuestionnaireWidget extends StatefulWidget {
  final TaskType taskType;
  final TaskAssigningService taskAssigningService;

  const AgencyQuestionnaireWidget({super.key, required this.taskType, required this.taskAssigningService});

  @override
  State<AgencyQuestionnaireWidget> createState() =>
      _AgencyQuestionnaireWidgetState();
}

class _AgencyQuestionnaireWidgetState extends State<AgencyQuestionnaireWidget> {
  late AgencyQuestionnaire agencyQuestionnaire;
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

  @override
  Widget build(BuildContext context) {
    final subject = getIt<Subject>();
    print(subject.uuid);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.navigate_next, size: 28),
    onPressed: () {
    CountdownDialog.showCountdownDialog(context, 2, () {
    if (widget.taskType == TaskType.coverPhone) {
    subject.coverTaskQuestionnaire = agencyQuestionnaire;
    Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context) {
    switch (widget.taskAssigningService.task) {
    case 1:
    return ButtonTaskIDIntro();
    case 2:
    return FlipTaskIDOverview();
    case 3:
    return AudioRecorderScreen();
    case 4:
    return VolumeButtonTaskIDIntro();
    default:
    return EndScreen();
    }
    }));
    } else if (widget.taskType == TaskType.holdButton) {
      subject.buttonTaskQuestionnaire = agencyQuestionnaire;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            switch (widget.taskAssigningService.task) {
              case 1:
                return FlipTaskIDOverview();
              case 2:
                return VolumeButtonTaskIDIntro();
              case 3:
                return CoverTaskIDIntro();
              case 4:
                return AudioRecorderScreen();
              default:
                return EndScreen();
            }
          }));
    } else if (widget.taskType == TaskType.flipPhone) {
      subject.flipTaskQuestionnaire = agencyQuestionnaire;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            switch (widget.taskAssigningService.task) {
              case 1:
                return VolumeButtonTaskIDIntro();
              case 2:
                return AudioRecorderScreen();
              case 3:
                return ButtonTaskIDIntro();
              case 4:
                return CoverTaskIDIntro();
              default:
                return EndScreen();
            }
          }));
    } else if (widget.taskType == TaskType.volumeButton) {
      subject.volumeTaskQuestionnaire = agencyQuestionnaire;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
            switch (widget.taskAssigningService.task) {
              case 1:
                return AudioRecorderScreen();
              case 2:
                return CoverTaskIDIntro();
              case 3:
                return FlipTaskIDOverview();
              case 4:
                return ButtonTaskIDIntro();
              default:
                return EndScreen();
            }
          }));
    }
    });
    },
        ),
      body: CustomWillPopScopeWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        Strings.questionnaireTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Task: ${widget.taskType.toNiceString()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              Strings.movementControlQuestion,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SfSlider(
                              min: 1,
                              max: 7,
                              value: agencyQuestionnaire.movementAgencyQuestionValue,
                              interval: 1,
                              showTicks: true,
                              showLabels: true,
                              tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                                switch (actualValue) {
                                  case 1:
                                    return Strings.stronglyDisagree;
                                  case 2:
                                    return Strings.disagree;
                                  case 3:
                                    return Strings.somewhatDisagree;
                                  case 4:
                                    return Strings.neutral;
                                  case 5:
                                    return Strings.somewhatAgree;
                                  case 6:
                                    return Strings.agree;
                                  case 7:
                                    return Strings.stronglyAgree;
                                }
                                return actualValue.toString();
                              },
                              enableTooltip: true,
                              labelPlacement: LabelPlacement.onTicks,
                              labelFormatterCallback: (dynamic actualValue, String formattedText) {
                                switch (actualValue) {
                                  case 1:
                                    return '';
                                  case 2:
                                    return Strings.disagree;
                                  case 3:
                                    return '';
                                  case 4:
                                    return Strings.neutral;
                                  case 5:
                                    return '';
                                  case 6:
                                    return Strings.agree;
                                  case 7:
                                    return ' ';
                                }
                                return actualValue.toString();
                              },
                              onChanged: (dynamic value) {
                                setState(() {
                                  agencyQuestionnaire.movementAgencyQuestionValue = value.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              Strings.controlFeelingQuestion,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SfSlider(
                              min: 1.0,
                              max: 7.0,
                              value: agencyQuestionnaire.agencyQuestionValue,
                              interval: 1,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                                switch (actualValue) {
                                  case 1:
                                    return Strings.veryLow;
                                  case 2:
                                    return Strings.low;
                                  case 3:
                                    return Strings.somewhatLow;
                                  case 4:
                                    return Strings.medium;
                                  case 5:
                                    return Strings.somewhatHigh;
                                  case 6:
                                    return Strings.high;
                                  case 7:
                                    return Strings.veryHigh;
                                }
                                return actualValue.toString();
                              },
                              labelPlacement: LabelPlacement.onTicks,
                              labelFormatterCallback: (dynamic actualValue, String formattedText) {
                                switch (actualValue) {
                                  case 1:
                                    return '';
                                  case 2:
                                    return Strings.low;
                                  case 3:
                                    return '';
                                  case 4:
                                    return Strings.medium;
                                  case 5:
                                    return '';
                                  case 6:
                                    return Strings.high;
                                  case 7:
                                    return '';
                                }
                                return actualValue.toString();
                              },
                              onChanged: (dynamic value) {
                                setState(() {
                                  agencyQuestionnaire.agencyQuestionValue = value.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              Strings.viewChangeQuestion,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SfSlider(
                              min: 1.0,
                              max: 7.0,
                              value: agencyQuestionnaire.controlFeelingViewChangeQuestionValue,
                              interval: 1,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                                switch (actualValue) {
                                  case 1:
                                    return Strings.notAtAll;
                                  case 2:
                                    return Strings.slightly;
                                  case 3:
                                    return Strings.somewhat;
                                  case 4:
                                    return Strings.moderately;
                                  case 5:
                                    return Strings.quite;
                                  case 6:
                                    return Strings.very;
                                  case 7:
                                    return Strings.completely;
                                }
                                return actualValue.toString();
                              },
                              labelPlacement: LabelPlacement.onTicks,
                              labelFormatterCallback: (dynamic actualValue, String formattedText) {
                                switch (actualValue) {
                                  case 1:
                                    return '';
                                  case 2:
                                    return Strings.slightly;
                                  case 3:
                                    return '';
                                  case 4:
                                    return Strings.moderately;
                                  case 5:
                                    return '';
                                  case 6:
                                    return Strings.very;
                                  case 7:
                                    return '';
                                }
                                return actualValue.toString();
                              },
                              onChanged: (dynamic value) {
                                setState(() {
                                  agencyQuestionnaire.controlFeelingViewChangeQuestionValue = value.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


