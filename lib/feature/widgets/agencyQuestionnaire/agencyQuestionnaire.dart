import 'package:flutter/cupertino.dart';
import '../../models/strings.dart';

class AgencyQuestionnaire {
  final TaskType taskType;
  int movementAgencyQuestionValue;
  int agencyQuestionValue;
  int controlFeelingViewChangeQuestionValue;

  AgencyQuestionnaire({
    required this.taskType,
    required this.movementAgencyQuestionValue,
    required this.agencyQuestionValue,
    required this.controlFeelingViewChangeQuestionValue,
  });
}

enum TaskType {
  coverPhone,
  holdButton,
  flipPhone,
  volumeButton
}

extension ParseToString on TaskType {
  String toNiceString() {
    switch (this) {
      case TaskType.coverPhone:
        return Strings.coverPhone;
      case TaskType.holdButton:
        return Strings.holdButton;
      case TaskType.flipPhone:
        return Strings.flipPhone;
      case TaskType.volumeButton:
        return Strings.volumeButton;
      default:
        return Strings.unidentifiedTaskType;
    }
  }
}
