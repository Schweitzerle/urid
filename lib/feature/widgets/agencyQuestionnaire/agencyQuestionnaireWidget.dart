import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';

import '../../screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import '../../screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import '../../screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import '../../screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import '../../screens/taskOverview/taskOverview.dart';
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
        onPressed: () {
          CountdownDialog.showCountdownDialog(context, 2, () {
            if (widget.taskType == TaskType.coverPhone) {
              subject.coverTaskQuestionnaire = agencyQuestionnaire;
              print('Cover Moveme ${subject.coverTaskQuestionnaire!.movementAgencyQuestionValue}');
              print('Cover Agency ${subject.coverTaskQuestionnaire!.agencyQuestionValue}');
              print('Cover Contr ${subject.coverTaskQuestionnaire!.controlFeelingViewChangeQuestionValue}');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    switch (widget.taskAssigningService.task) {
                      case 1:
                        return ButtonTaskIDIntro();
                      case 2:
                        return VolumeButtonTaskIDIntro();
                      case 3:
                      //TODO: screen nach allen vier gesten
                        return TaskOverviewScreen();
                      case 4:
                        return FlipTaskIDIntro();
                      default:
                        return const TaskOverviewScreen();
                    }
                  }));
            } else if (widget.taskType == TaskType.holdButton) {
              subject.buttonTaskQuestionnaire = agencyQuestionnaire;
              print('Buttn Moveme ${subject.buttonTaskQuestionnaire!.movementAgencyQuestionValue}');
              print('Butztn Agency ${subject.buttonTaskQuestionnaire!.agencyQuestionValue}');
              print('Buttn Contr ${subject.buttonTaskQuestionnaire!.controlFeelingViewChangeQuestionValue}');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    switch (widget.taskAssigningService.task) {
                      case 1:
                        return VolumeButtonTaskIDIntro();
                      case 2:
                        return FlipTaskIDIntro();
                      case 3:
                        return CoverTaskIDIntro();
                      case 4:
                      //TODO: screen nach allen vier gesten
                        return TaskOverviewScreen();
                      default:
                        return const TaskOverviewScreen();
                    }
                  }));
            } else if (widget.taskType == TaskType.flipPhone) {
              subject.flipTaskQuestionnaire = agencyQuestionnaire;
              print('Flip Moveme ${subject.flipTaskQuestionnaire!.movementAgencyQuestionValue}');
              print('Flip Agency ${subject.flipTaskQuestionnaire!.agencyQuestionValue}');
              print('Flip Contr ${subject.flipTaskQuestionnaire!.controlFeelingViewChangeQuestionValue}');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    switch (widget.taskAssigningService.task) {
                      case 1:
                      //TODO: screen nach allen vier gesten
                        return TaskOverviewScreen();
                      case 2:
                        return CoverTaskIDIntro();
                      case 3:
                        return VolumeButtonTaskIDIntro();
                      case 4:
                        return ButtonTaskIDIntro();
                      default:
                        return const TaskOverviewScreen();
                    }
                  }));
            } else if (widget.taskType == TaskType.volumeButton) {
              subject.volumeTaskQuestionnaire = agencyQuestionnaire;
              print('Vol Moveme ${subject.volumeTaskQuestionnaire!.movementAgencyQuestionValue}');
              print('Vol Agency ${subject.volumeTaskQuestionnaire!.agencyQuestionValue}');
              print('Vol Contr ${subject.volumeTaskQuestionnaire!.controlFeelingViewChangeQuestionValue}');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    switch (widget.taskAssigningService.task) {
                      case 1:
                        return FlipTaskIDIntro();
                      case 2:
                      //TODO: screen nach allen vier gesten
                        return TaskOverviewScreen();
                      case 3:
                        return ButtonTaskIDIntro();
                      case 4:
                        return CoverTaskIDIntro();
                      default:
                        return const TaskOverviewScreen();
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
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Text('Fragebogen Kontroll- und Sicherheitsgefühl', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Task: ${widget.taskType.toNiceString()}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        const Text('1. Es fühlte sich so an, als hätte Sie die Bewegungen während der Aufgabe unter Kontrolle gehabt.'
                            , style: TextStyle(fontWeight: FontWeight.bold)),
                        SfSlider.vertical(
                            min: 1,
                            max: 7,
                            value: agencyQuestionnaire.movementAgencyQuestionValue,
                            interval: 1,
                            showTicks: true,
                            showLabels: true,
                            tooltipTextFormatterCallback:  (dynamic actualValue, String formattedText) {
                              switch (actualValue) {
                                case 1:
                                  return 'stimme überhaupt nicht zu';
                                case 2:
                                  return 'stimme nicht zu';
                                case 3:
                                  return 'stimme eher nicht zu';
                                case 4:
                                  return 'weder noch';
                                case 5:
                                  return 'stimme eher zu';
                                case 6:
                                  return 'stimme zu';
                                case 7:
                                  return 'stimme vollkomen zu';
                              }
                              return actualValue.toString();
                            },
                            tooltipPosition: SliderTooltipPosition.right,
                            enableTooltip: true,
                            labelPlacement: LabelPlacement.onTicks,
                            labelFormatterCallback:
                                (dynamic actualValue, String formattedText) {
                              switch (actualValue) {
                                case 1:
                                  return 'stimme überhaupt nicht zu';
                                case 2:
                                  return 'stimme nicht zu';
                                case 3:
                                  return 'stimme eher nicht zu';
                                case 4:
                                  return 'weder noch';
                                case 5:
                                  return 'stimme eher zu';
                                case 6:
                                  return 'stimme zu';
                                case 7:
                                  return 'stimme vollkomen zu';
                              }
                              return actualValue.toString();
                            },
                            onChanged: (dynamic value) {
                              setState(() {
                                agencyQuestionnaire.movementAgencyQuestionValue = value.toInt();
                                print(agencyQuestionnaire.movementAgencyQuestionValue);
                              });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text('2. Wie stark war das Gefühl der Kontrolle, das Sie empfunden haben?', style: TextStyle(fontWeight: FontWeight.bold),),
                        SfSlider(
                            min: 1.0,
                            max: 7.0,
                            value: agencyQuestionnaire.agencyQuestionValue,
                            interval: 1,
                            showTicks: true,
                            showLabels: true,
                            enableTooltip: true,
                            tooltipTextFormatterCallback:  (dynamic actualValue, String formattedText) {
                              switch (actualValue) {
                                case 1:
                                  return 'sehr niedrig';
                                case 2:
                                  return 'niedrig';
                                case 3:
                                  return 'eher niedrig';
                                case 4:
                                  return 'mittel';
                                case 5:
                                  return 'eher hoch';
                                case 6:
                                  return 'hoch';
                                case 7:
                                  return 'sehr hoch';
                              }
                              return actualValue.toString();
                            },
                            labelPlacement: LabelPlacement.onTicks,
                            labelFormatterCallback:
                                (dynamic actualValue, String formattedText) {
                              switch (actualValue) {
                                case 1:
                                  return '';
                                case 2:
                                  return 'niedrig';
                                case 3:
                                  return '';
                                case 4:
                                  return 'mittel';
                                case 5:
                                  return '';
                                case 6:
                                  return 'hoch';
                                case 7:
                                  return '';
                              }
                              return actualValue.toString();
                            },
                            onChanged: (dynamic value) {
                              setState(() {
                                agencyQuestionnaire.agencyQuestionValue = value.toInt();
                                print(agencyQuestionnaire.agencyQuestionValue);
                              });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text('3. Geben Sie an, wie sehr es sich anfühlte, als würde die gerade durchgeführteInteraktionsform den Wechsel zwischen den beiden Ansichten verursachen.'
                            , style: TextStyle(fontWeight: FontWeight.bold)),
                        SfSlider(
                            min: 1.0,
                            max: 7.0,
                            value: agencyQuestionnaire.controlFeelingViewChangeQuestionValue,
                            interval: 1,
                            showTicks: true,
                            showLabels: true,
                            enableTooltip: true,
                            tooltipTextFormatterCallback:  (dynamic actualValue, String formattedText) {
                              switch (actualValue) {
                                case 1:
                                  return 'überhaupt nicht';
                                case 2:
                                  return 'wenig';
                                case 3:
                                  return 'leicht';
                                case 4:
                                  return 'eher';
                                case 5:
                                  return 'ziemlich';
                                case 6:
                                  return 'sehr';
                                case 7:
                                  return 'vollkomen';
                              }
                              return actualValue.toString();
                            },
                            labelPlacement: LabelPlacement.onTicks,
                            onChanged: (dynamic value) {
                              setState(() {
                                agencyQuestionnaire.controlFeelingViewChangeQuestionValue = value.toInt();
                                print(agencyQuestionnaire.controlFeelingViewChangeQuestionValue);
                              });
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
